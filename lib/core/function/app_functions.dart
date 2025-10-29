import 'package:flutter/material.dart';
import 'package:my_portfolio/core/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class AppFunction {
  static void launch(String urlValue, {LaunchMode? mode}) async {
    final url = Uri.parse(urlValue);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: mode ?? LaunchMode.platformDefault);
    } else {
      throw 'Could not launch $url';
    }
  }

  static void launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: Constants.myEmail,
      queryParameters: {'subject': 'Hello', 'body': 'I want to contact you.'},
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw 'Could not launch $emailLaunchUri';
    }
  }

  static Future<void> launchPhone() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: Constants.myPhone);

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch phone dialer';
    }
  }

  static void scrollTo(GlobalKey key) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
