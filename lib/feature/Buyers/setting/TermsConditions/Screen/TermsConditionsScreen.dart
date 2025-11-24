import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  // Colors
  static const Color _textDark = Color(0xFF212121);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Terms & Conditions',
          style: GoogleFonts.lora(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey[200], height: 1.0),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildParagraph(
              'By using this app, you agree to follow these Terms & Conditions and our Privacy & Security Policy. If you do not agree, please stop using the app.',
            ),
            const SizedBox(height: 24),
            _buildParagraph(
              'You are responsible for keeping your account details accurate and your login information secure. Any actions taken under your account are your responsibility.',
            ),
            const SizedBox(height: 24),
            _buildParagraph(
              'The app helps users browse properties, communicate with agents, request CMA reports, sign digital agreements, and manage real estate activities. We do not guarantee property accuracy, availability, or transaction outcomes.',
            ),
            const SizedBox(height: 24),
            _buildParagraph(
              'The app may include legally binding digital agreements, such as touring agreements, buyer agreements, and listing agreements. By signing electronically, you confirm that you understand and accept the terms',
            ),
            const SizedBox(height: 24),
            _buildParagraph(
              'If payments apply, all charges will be shown before you pay. Refunds follow each transaction\'s policy. Unauthorized payments or chargebacks may result in account restrictions.',
            ),
            const SizedBox(height: 24),
            _buildParagraph(
              'Do not use the app for fraud, harassment, unauthorized marketing, data scraping, or any illegal activity. Do not upload harmful, abusive, or copyrighted content without permission.',
            ),
            const SizedBox(height: 40), // Bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(fontSize: 14, color: _textDark, height: 1.6),
      textAlign: TextAlign.justify,
    );
  }
}
