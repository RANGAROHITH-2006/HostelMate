import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

/// Utility class for phone-related operations
class PhoneUtils {
  /// Makes a phone call to the specified phone number after showing a confirmation dialog
  /// and requesting necessary permissions
  static Future<void> makePhoneCall(
    BuildContext context,
    String phoneNumber,
    String name,
  ) async {
    // Show permission dialog first
    bool? shouldProceed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Make Phone Call'),
        content: Text('Do you want to call $name at $phoneNumber?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (shouldProceed == true) {
      // Check and request phone permission
      var status = await Permission.phone.status;
      if (status.isDenied) {
        status = await Permission.phone.request();
      }

      if (status.isGranted || status.isLimited) {
        final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
        try {
          if (await canLaunchUrl(phoneUri)) {
            await launchUrl(phoneUri);
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Could not launch phone dialer')),
              );
            }
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error making call: $e')),
            );
          }
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Phone permission denied')),
          );
        }
      }
    }
  }
}
