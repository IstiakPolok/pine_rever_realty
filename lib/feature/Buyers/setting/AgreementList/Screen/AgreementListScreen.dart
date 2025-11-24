import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AgreementListScreen extends StatefulWidget {
  const AgreementListScreen({super.key});

  @override
  State<AgreementListScreen> createState() => _AgreementListScreenState();
}

class _AgreementListScreenState extends State<AgreementListScreen> {
  // Colors
  static const Color _textDark = Color(0xFF212121);
  static const Color _textGrey = Color(0xFF616161);
  static const Color _greenBtn = Color(0xFF2D6A5F);
  static const Color _orangeBtn = Color(0xFFE8772E);

  // Card Backgrounds
  static const Color _bgBeige = Color(
    0xFFFAEBD7,
  ); // Light beige for Partnership Agreements
  static const Color _bgMint = Color(
    0xFFE0F2F1,
  ); // Light mint for Showing Agreements

  // Pending Agreements Data
  final List<Map<String, dynamic>> _pendingAgreements = [
    {
      'title': 'Buyer Partnership Agreement',
      'subtitle': 'Luxury Downtown Condo',
      'address': '456 Main Avenue, Downtown',
      'agent': 'Agent: Michael Chen',
      'backgroundColor': _bgBeige,
      'buttonLabel': 'Accept',
      'buttonColor': _greenBtn,
      'buttonIcon': Icons.edit_outlined,
    },
  ];

  // Signed Agreements Data
  final List<Map<String, dynamic>> _signedAgreements = [
    {
      'title': 'Showing Agreement',
      'subtitle': 'Modern Home',
      'address': '123 Oak Street, Springfield',
      'agent': 'Agent: Sarah',
      'dateLabel': 'Sign: 12 Nov,2025 - 19 Nov, 2025',
      'backgroundColor': _bgMint,
      'buttonLabel': 'View',
      'buttonColor': _orangeBtn,
      'buttonIcon': Icons.remove_red_eye_outlined,
    },
    {
      'title': 'Buyer Partnership Agreement',
      'subtitle': 'Modern Home',
      'address': '123 Oak Street, Springfield',
      'agent': 'Agent: Sarah',
      'dateLabel': 'Sign: 12 Nov,2025 - 15 Jan, 2026',
      'backgroundColor': _bgBeige,
      'buttonLabel': 'View',
      'buttonColor': _orangeBtn,
      'buttonIcon': Icons.remove_red_eye_outlined,
    },
  ];

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
          'Agreement List',
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
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          // --- Pending Section ---
          if (_pendingAgreements.isNotEmpty) ...[
            Text(
              'Pending Agreement',
              style: GoogleFonts.lora(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: _textDark,
              ),
            ),
            const SizedBox(height: 16),

            ..._pendingAgreements.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildAgreementCard(
                  title: item['title'],
                  subtitle: item['subtitle'],
                  address: item['address'],
                  agent: item['agent'],
                  dateLabel: item['dateLabel'],
                  backgroundColor: item['backgroundColor'],
                  buttonLabel: item['buttonLabel'],
                  buttonColor: item['buttonColor'],
                  buttonIcon: item['buttonIcon'],
                  onPressed: () {
                    // Handle button press based on type
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],

          // --- Signed Section ---
          if (_signedAgreements.isNotEmpty) ...[
            Text(
              'Signed Agreement',
              style: GoogleFonts.lora(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: _textDark,
              ),
            ),
            const SizedBox(height: 16),

            ..._signedAgreements.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildAgreementCard(
                  title: item['title'],
                  subtitle: item['subtitle'],
                  address: item['address'],
                  agent: item['agent'],
                  dateLabel: item['dateLabel'],
                  backgroundColor: item['backgroundColor'],
                  buttonLabel: item['buttonLabel'],
                  buttonColor: item['buttonColor'],
                  buttonIcon: item['buttonIcon'],
                  onPressed: () {
                    // Handle button press based on type
                  },
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAgreementCard({
    required String title,
    required String subtitle,
    required String address,
    required String agent,
    String? dateLabel,
    required Color backgroundColor,
    required String buttonLabel,
    required Color buttonColor,
    required IconData buttonIcon,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: GoogleFonts.lora(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 8),

          // Subtitle (Property Name)
          Text(
            subtitle,
            style: GoogleFonts.lora(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 8),

          // Details
          Text(
            address,
            style: GoogleFonts.poppins(fontSize: 13, color: _textGrey),
          ),
          const SizedBox(height: 4),
          Text(
            agent,
            style: GoogleFonts.poppins(fontSize: 13, color: _textGrey),
          ),

          // Optional Date
          if (dateLabel != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined, size: 14, color: _textGrey),
                const SizedBox(width: 6),
                Text(
                  dateLabel,
                  style: GoogleFonts.poppins(fontSize: 12, color: _textGrey),
                ),
              ],
            ),
          ],

          const SizedBox(height: 20),

          // Action Button
          SizedBox(
            width: 120, // Fixed width for the button as per image
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(buttonIcon, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    buttonLabel,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
