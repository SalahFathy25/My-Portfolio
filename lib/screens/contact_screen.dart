import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Contact Me', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text('📧 Email: yourmail@example.com'),
          Text('💻 GitHub: github.com/yourusername'),
          Text('🔗 LinkedIn: linkedin.com/in/yourusername'),
        ],
      ),
    );
  }
}
