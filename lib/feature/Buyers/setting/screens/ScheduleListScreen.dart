import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScheduleListScreen extends StatelessWidget {
  const ScheduleListScreen({super.key});

  // Colors
  static const Color _textDark = Color(0xFF212121);
  static const Color _textGrey = Color(0xFF616161);
  static const Color _cardBg = Color(0xFFF5F9FF); // Very light blue background
  static const Color _cardBorder = Color(0xFFE1EAF5); // Light border

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
          'Schedule List',
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
          Text(
            'Your Upcoming Showings',
            style: GoogleFonts.lora(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 16),

          _buildScheduleCard(
            title: 'Modern Family Home',
            address: '123 Oak Street, Springfield',
            date: 'Nov 12, 2025',
            time: '2:00 PM',
          ),

          const SizedBox(height: 16),

          _buildScheduleCard(
            title: 'Luxury Downtown Condo',
            address: '456 Main Avenue, Downtown',
            date: 'Nov 15, 2025',
            time: '10:00 AM',
            // The second card in image looks slightly grey/white compared to top one or just distinct
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard({
    required String title,
    required String address,
    required String date,
    required String time,
    bool isGrey = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isGrey ? const Color(0xFFFAFAFA) : _cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isGrey ? Colors.grey[200]! : _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.lora(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            address,
            style: GoogleFonts.poppins(fontSize: 13, color: _textGrey),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 16, color: _textGrey),
              const SizedBox(width: 6),
              Text(
                date,
                style: GoogleFonts.poppins(fontSize: 13, color: _textGrey),
              ),
              const SizedBox(width: 16),
              Icon(Icons.access_time, size: 16, color: _textGrey),
              const SizedBox(width: 6),
              Text(
                time,
                style: GoogleFonts.poppins(fontSize: 13, color: _textGrey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
