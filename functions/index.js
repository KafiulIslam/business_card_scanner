const { initializeApp } = require("firebase-admin/app");
const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");
const {
  REFUSAL,
  SAFETY_SETTINGS,
  EMAIL_SYSTEM,
  CARD_SYSTEM,
  builderAnswerFor,
  assertAllowed,
  assertModelAllowed,
  enforceDailyLimit,
} = require("./safety");

initializeApp();

const geminiApiKey = defineSecret("GEMINI_API_KEY");
const MODEL = "gemini-3.8-flash";

exports.extractCard = onCall({ secrets: [geminiApiKey] }, async (request) => {
  requireAuth(request);
  const rawText = requireText(request.data?.rawText, "rawText", 8000);
  assertAllowed(rawText);
  await enforceDailyLimit(request.auth.uid, "extractCard");
  const prompt = `Extract business card fields from the text below.
Return only JSON with these keys: name, jobTitle, company, email, phone, address, website.
Use an empty string when a field is missing.
Name is the person, not the company. Job title is their role.

Text:
${rawText}`;

  const text = await generate(geminiApiKey.value(), prompt, {
    system: CARD_SYSTEM,
    json: true,
    temperature: 0.1,
    maxOutputTokens: 500,
  });
  const parsed = parseJson(text);
  return {
    name: field(parsed.name),
    jobTitle: field(parsed.jobTitle ?? parsed.job_title),
    company: field(parsed.company),
    email: field(parsed.email),
    phone: field(parsed.phone),
    address: field(parsed.address),
    website: field(parsed.website),
  };
});

exports.generateEmail = onCall({ secrets: [geminiApiKey] }, async (request) => {
  requireAuth(request);
  const senderName = requireText(request.data?.senderName, "senderName", 200);
  const emailConcept = requireText(request.data?.emailConcept, "emailConcept", 2000);
  const builderAnswer = builderAnswerFor(`${senderName}\n${emailConcept}`);
  if (builderAnswer) return { text: builderAnswer };
  assertAllowed(`${senderName}\n${emailConcept}`, { email: true });
  await enforceDailyLimit(request.auth.uid, "generateEmail");
  const prompt = `Write a professional email.
Sender name: ${senderName}
Concept: ${emailConcept}

Format the response exactly as:
SUBJECT: [subject line]
BODY: [email body]`;

  const text = await generate(geminiApiKey.value(), prompt, {
    system: EMAIL_SYSTEM,
    temperature: 0.4,
    maxOutputTokens: 1000,
  });
  return { text };
});

function requireAuth(request) {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Sign in required.");
  }
}

function requireText(value, name, maxLength) {
  if (typeof value !== "string" || value.trim().length === 0) {
    throw new HttpsError("invalid-argument", `${name} is required.`);
  }
  const text = value.trim();
  if (text.length > maxLength) {
    throw new HttpsError("invalid-argument", `${name} is too long.`);
  }
  return text;
}

function field(value) {
  if (value == null) return "";
  return String(value).trim();
}

function parseJson(text) {
  const match = text.match(/\{[\s\S]*\}/);
  if (!match) {
    throw new HttpsError("internal", "Gemini did not return card fields.");
  }
  try {
    return JSON.parse(match[0]);
  } catch (error) {
    throw new HttpsError("internal", "Gemini returned invalid card fields.");
  }
}

async function generate(apiKey, prompt, options) {
  const response = await fetch(
    `https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent`,
    {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "x-goog-api-key": apiKey,
      },
      body: JSON.stringify({
        systemInstruction: { parts: [{ text: options.system }] },
        contents: [{ role: "user", parts: [{ text: prompt }] }],
        safetySettings: SAFETY_SETTINGS,
        generationConfig: {
          temperature: options.temperature,
          maxOutputTokens: options.maxOutputTokens,
          ...(options.json ? { responseMimeType: "application/json" } : {}),
        },
      }),
    },
  );

  if (!response.ok) {
    let detail = "";
    try {
      const body = await response.json();
      detail = String(body?.error?.message || body?.error?.status || "");
    } catch (error) {
      detail = "";
    }
    const message = detail
      ? `Gemini request failed. ${detail}`.slice(0, 280)
      : "Gemini request failed.";
    throw new HttpsError("internal", message);
  }

  const data = await response.json();
  if (data.promptFeedback?.blockReason) {
    throw new HttpsError("failed-precondition", REFUSAL);
  }
  const candidate = data.candidates?.[0];
  if (candidate?.finishReason === "SAFETY") {
    throw new HttpsError("failed-precondition", REFUSAL);
  }
  const text = (candidate?.content?.parts ?? [])
    .map((part) => part.text ?? "")
    .join("")
    .trim();
  if (!text) {
    throw new HttpsError("internal", "Gemini returned an empty response.");
  }
  assertModelAllowed(text);
  return text;
}
