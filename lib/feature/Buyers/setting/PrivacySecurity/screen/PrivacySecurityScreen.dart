import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});

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
          'Privacy & Security',
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
              'We collect basic user information such as your name, email, phone number, and account login details. We also collect property information, agreement documents, and activity logs related to buying, selling, or browsing properties. Some optional information like chat messages, identity verification files, and uploaded documents may also be collected to support platform services and compliance.',
            ),
            const SizedBox(height: 24),
            _buildParagraph(
              'We use your information to provide property search services, connect buyers and sellers, prepare CMA reports, enable digital signatures for agreements, and improve platform security and performance. Your data also helps us send alerts about tours, offers, pricing updates, and other app-related notifications. We do not sell your personal information to anyone.',
            ),
            const SizedBox(height: 24),
            _buildParagraph(
              'We may share your information with trusted service providers who help us operate our platform, such as e-signature vendors, payment processors, valuation and inspection partners, and legal authorities when required by law. These partners are required to protect your data and use it only for authorized purposes.',
            ),
            const SizedBox(height: 24),
            _buildParagraph(
              'We use strong security methods to protect your data, including encrypted communication (HTTPS/SSL), password encryption, secure cloud storage, and access controls. Sensitive actions may require additional verification such as multi-factor authentication. We continuously monitor for unauthorized access and perform security checks to keep your information safe.',
            ),
            const SizedBox(height: 24),
            _buildParagraph(
              'We keep your information only for as long as it is needed for legal, regulatory, security, and operational purposes. This includes transaction records, agreement history, and compliance documentation. You may request data deletion when no longer legally required for retention.',
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
      style: GoogleFonts.poppins(
        fontSize: 14,
        color: _textDark,
        height: 1.6, // Increased line height for better readability
      ),
      textAlign: TextAlign.justify,
    );
  }
}
