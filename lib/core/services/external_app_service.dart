import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../features/network/domain/entities/network_model.dart';


class ExternalAppService {
  final _imagePicker = ImagePicker();

  // Pick image from camera or gallery
  Future<File?> pickImage(ImageSource source, {int imageQuality = 85}) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: imageQuality,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to pick image: ${e.toString()}');
    }
  }

  // Pick PDF file
  Future<PdfPickResult?> pickPdfFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result == null || result.files.single.path == null) {
        return null;
      }

      final pickedPath = result.files.single.path!;
      final extension = result.files.single.extension?.toLowerCase() ?? '';

      if (extension != 'pdf') {
        throw Exception('Please select a PDF file.');
      }

      final pdfFile = File(pickedPath);
      if (!await pdfFile.exists()) {
        throw Exception('Selected file does not exist.');
      }

      return PdfPickResult(
        file: pdfFile,
        fileName: result.files.single.name,
      );
    } catch (e) {
      throw Exception('Failed to pick PDF file: ${e.toString()}');
    }
  }

  // make direct phone call with card phone number
  Future<void> makePhoneCall(String? phone) async {
    if (phone == null || phone.isEmpty) {
      throw Exception('Phone number is not available');
    }
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw Exception('Could not launch phone dialer');
    }
  }


  // find card phone number in whatsapp
  Future<void> openWhatsApp(String whatsappNumber) async {
    try {
      if (await canLaunch("whatsapp://send?phone=$whatsappNumber")) {
        await launch("whatsapp://send?phone=$whatsappNumber");
      } else {
        throw Exception('Could not launch WhatsApp');
      }
    } catch (e) {
      throw Exception('Failed to open WhatsApp: ${e.toString()}');
    }
  }


  // Send email
  Future<void> sendEmail(String? email) async {
    if (email == null || email.isEmpty) {
      throw Exception('Email address is not available');
    }
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch email client');
    }
  }


  // Search Card holder name in LinkedIn
  Future<void> openLinkedInSearch(String? name) async {
    if (name == null || name.isEmpty) {
      throw Exception('Name is not available');
    }
    // URL encode the name for LinkedIn search
    final encodedName = Uri.encodeComponent(name);
    final uri = Uri.parse(
        'https://www.linkedin.com/search/results/people/?keywords=$encodedName');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch LinkedIn');
    }
  }


  // Search Card holder name in facebook
  Future<void> openFacebookSearch(String? name) async {
    if (name == null || name.isEmpty) {
      throw Exception('Name is not available');
    }
    // URL encode the name for Facebook search
    final encodedName = Uri.encodeComponent(name);
    final uri =
        Uri.parse('https://www.facebook.com/search/top/?q=$encodedName');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch Facebook');
    }
  }


  // Open address in Google Map
  Future<void> openGoogleMaps(String? address) async {
    if (address == null || address.isEmpty) {
      throw Exception('Address is not available');
    }
    // URL encode the address for Google Maps search
    final encodedAddress = Uri.encodeComponent(address);
    // Use Google Maps URL scheme - this will open the app if installed, or web version
    final uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$encodedAddress');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch Google Maps');
    }
  }


  // Open website
  Future<void> openWebsite(String? website) async {
    if (website == null || website.isEmpty) {
      throw Exception('Website URL is not available');
    }
    final url = website.startsWith('http') ? website : 'https://$website';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch website');
    }
  }


  // Save business card's phone number to phone contact
  Future<void> saveContactToDevice(NetworkModel network) async {
    // Check and request contacts permission
    final permission = await Permission.contacts.status;
    if (permission.isDenied) {
      final result = await Permission.contacts.request();
      if (result.isDenied) {
        throw Exception('Contacts permission is required to save contact');
      }
    }

    if (permission.isPermanentlyDenied) {
      throw Exception('Please enable contacts permission in app settings');
    }

    // Create a new contact
    final newContact = Contact(
      name: Name(
        first: network.name ?? '',
        last: '',
      ),
    );

    // Add phone number if available
    if (network.phone != null && network.phone!.isNotEmpty) {
      newContact.phones = [
        Phone(network.phone!),
      ];
    }

    // Add email if available
    if (network.email != null && network.email!.isNotEmpty) {
      newContact.emails = [
        Email(network.email!),
      ];
    }

    // Add company/organization if available
    if (network.company != null && network.company!.isNotEmpty) {
      newContact.organizations = [
        Organization(
          company: network.company!,
          title: network.title ?? '',
        ),
      ];
    }

    // Add address if available
    if (network.address != null && network.address!.isNotEmpty) {
      newContact.addresses = [
        Address(network.address!),
      ];
    }

    // Add website if available
    if (network.website != null && network.website!.isNotEmpty) {
      newContact.websites = [
        Website(network.website!),
      ];
    }

    // Insert the contact
    await FlutterContacts.insertContact(newContact);
  }


  // Copy text to clipboard
  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }


  // Share text, images or other content
  Future<void> shareContent(String text) async {
    try {
      if (text.isEmpty) {
        throw Exception('Share content cannot be empty');
      }
      await SharePlus.instance.share(ShareParams(text: text));
    } catch (e) {
      throw Exception('Failed to share content: ${e.toString()}');
    }
  }


  // Export text to a file and share it
  Future<void> exportTextToFile(String text, {String? fileName}) async {
    try {
      if (text.isEmpty) {
        throw Exception('Export content cannot be empty');
      }
      // Create a temporary file in the system temp directory
      final tempDir = Directory.systemTemp;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${tempDir.path}/${fileName ?? 'scanned_text'}_$timestamp.txt');
      await file.writeAsString(text);

      // Share the file
      final xFile = XFile(file.path);
      await Share.shareXFiles([xFile], text: 'Scanned Text Export');
    } catch (e) {
      throw Exception('Failed to export text: ${e.toString()}');
    }
  }
}

// Result class for PDF file picking
class PdfPickResult {
  final File file;
  final String fileName;

  PdfPickResult({
    required this.file,
    required this.fileName,
  });
}
