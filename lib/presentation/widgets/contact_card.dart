import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactCard extends StatelessWidget {
  final String email;
  final String linkedin;
  final String github;

  static String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'smith@example.com',
    query: encodeQueryParameters(<String, String>{
      'subject': 'Example Subject & Symbols are allowed!',
    }),
  );

  final Uri _urlLinkedin = Uri.parse(
    'https://www.linkedin.com/in/eang-chanvuthea-2ab92a1a4/',
  );

  ContactCard({
    required this.email,
    required this.linkedin,
    required this.github,
  });

  Future<void> _launchEmail() async {
    if (!await launchUrl(emailLaunchUri)) {
      throw Exception('Could not launch $emailLaunchUri');
    }
  }

  Future<void> _launchLinkedin() async {
    if (!await launchUrl(_urlLinkedin)) {
      throw Exception('Could not launch $_urlLinkedin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Contact', style: TextStyle(fontSize: 18)),
        SizedBox(height: 8),
        Card(
          child: ListTile(
            title: Text('Email'),
            subtitle: Text(email),
            onTap: () {
              _launchEmail();
            },
          ),
        ),
        Card(
          child: ListTile(
            title: Text('Linked'),
            subtitle: Text(linkedin),
            onTap: () {
              _launchLinkedin();
            },
          ),
        ),
      ],
    );
  }
}
