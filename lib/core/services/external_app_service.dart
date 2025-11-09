import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../features/network/domain/entities/network_model.dart';

/// Service for handling external app integrations
/// This service provides methods to interact with external applications
/// like phone dialer, WhatsApp, email, social media, maps, and contacts
class ExternalAppService {
  /// Makes a phone call using the device's dialer
  ///
  /// Throws [Exception] if phone number is invalid or cannot launch dialer
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

  /// Opens WhatsApp with the specified phone number
  ///
  /// Throws [Exception] if WhatsApp cannot be launched
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

  /// Opens the default email client with the specified email address
  ///
  /// Throws [Exception] if email is invalid or email client cannot be launched
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

  /// Opens LinkedIn search with the specified name
  ///
  /// Throws [Exception] if name is invalid or LinkedIn cannot be launched
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

  /// Opens Facebook search with the specified name
  ///
  /// Throws [Exception] if name is invalid or Facebook cannot be launched
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

  /// Opens Google Maps with the specified address
  ///
  /// Throws [Exception] if address is invalid or Google Maps cannot be launched
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

  /// Opens a website URL in external browser
  ///
  /// Throws [Exception] if URL is invalid or cannot be launched
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

  /// Saves a contact to the device's contact list
  ///
  /// Throws [Exception] if permission is denied or contact cannot be saved
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

  /// Copies text to clipboard
  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  /// Shares content using the device's share functionality
  /// 
  /// Throws [Exception] if sharing fails
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

}
