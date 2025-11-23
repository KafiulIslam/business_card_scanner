# OpenAI API Setup Instructions

## Step 1: Create .env file

Create a `.env` file in the root directory of your project (same level as `pubspec.yaml`).

## Step 2: Add your OpenAI API Key

Add the following line to your `.env` file:

```
OPENAI_API_KEY=your_actual_openai_api_key_here
```

Replace `your_actual_openai_api_key_here` with your actual OpenAI API key.

## Step 3: Get your OpenAI API Key

1. Go to https://platform.openai.com/api-keys
2. Sign in or create an account
3. Click "Create new secret key"
4. Copy the key and paste it in your `.env` file

## Step 4: Ensure .env is in .gitignore

Make sure your `.env` file is listed in `.gitignore` to avoid committing your API key to version control.

## Important Notes

- The `.env` file should be in the project root directory
- Never commit your `.env` file to git
- If the API key is missing, the app will automatically fallback to regex-based extraction
- The app will work without the API key, but with lower accuracy

## Testing

After setting up, test by scanning a business card. The app will:
1. First try AI extraction (if API key is configured)
2. Fallback to regex extraction if AI fails or API key is missing

