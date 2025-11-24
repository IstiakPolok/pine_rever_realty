import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import '../../../../core/const/app_colors.dart';

class ViewCMAReportScreen extends StatelessWidget {
  const ViewCMAReportScreen({super.key});

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
          'View CMA Report',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CMA Report',
              style: GoogleFonts.lora(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: primaryText,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 400, // Adjust height as needed to match aspect ratio
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFEAEAEA),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[400]!),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.image_outlined,
                    color: Colors.grey,
                    size: 40,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            _buildButton(
              text: 'Ready to Move Forward',
              onPressed: () {
                // TODO: Handle Ready to Move Forward
              },
              backgroundColor: primaryColor,
              textColor: Colors.white,
            ),
            const SizedBox(height: 16),
            _buildButton(
              text: "Let's Discuss More",
              onPressed: () {
                _showDiscussMoreDialog(context);
              },
              backgroundColor: Colors.white,
              textColor: primaryColor,
              borderColor: primaryColor,
            ),
            const SizedBox(height: 16),
            _buildButton(
              text: 'Not Ready Yet',
              onPressed: () {
                _showNotReadyDialog(context);
              },
              backgroundColor: Colors.white,
              textColor: const Color(0xFFB71C1C), // Dark red
              borderColor: const Color(0xFFB71C1C),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color textColor,
    Color? borderColor,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: borderColor != null
                ? BorderSide(color: borderColor)
                : BorderSide.none,
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.lora(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  void _showDiscussMoreDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Absolutely. Selling a home is a big decision, and it’s important to feel confident before moving forward. I’ll review your questions and reach out so we can talk through everything at a pace that feels comfortable for you.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lora(
                    fontSize: 16,
                    color: primaryText,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Perform action or close dialog
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Let's Discuss More",
                      style: GoogleFonts.lora(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showNotReadyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 16),
                // Placeholder for the image
                Image.asset(
                  'assets/image/NotreadyImage.png',
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 24),
                Text(
                  "No problem at all. You're welcome to return to your CMA anytime, and I'm here if questions come up.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lora(
                    fontSize: 16,
                    color: primaryText,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
