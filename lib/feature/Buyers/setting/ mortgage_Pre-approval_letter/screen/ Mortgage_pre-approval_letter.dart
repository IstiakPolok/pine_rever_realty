import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditMortgageLetterScreen extends StatelessWidget {
  const EditMortgageLetterScreen({super.key});

  // Colors
  static const Color _darkGreen = Color(0xFF2D6A5F);
  static const Color _borderGreen = Color(
    0xFF5F9EA0,
  ); // Outline of the main card
  static const Color _textDark = Color(0xFF212121);
  static const Color _textGrey = Color(0xFF616161);
  static const Color _disabledBtnColor = Color(
    0xFFE0E0E0,
  ); // Light grey for disabled button

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
          'Mortgage Letter Verify',
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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // --- Main Card ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _borderGreen, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card Title
                  Center(
                    child: Text(
                      'Mortgage pre-approval letter',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lora(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: _textDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Card Subtitle
                  Center(
                    child: Text(
                      'Already verified mortgage pre-approval letter',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: _textGrey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Inner Container
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Already Uploaded',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: _textGrey,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Disabled Button (File Name Placeholder)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: null, // Disabled
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _disabledBtnColor,
                              disabledBackgroundColor:
                                  _disabledBtnColor, // Explicitly set disabled color
                              foregroundColor: _textDark,
                              disabledForegroundColor: _textDark,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Mortage Letter', // Intentionally matching image typo if needed, or use Mortgage
                              style: GoogleFonts.lora(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Replace Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Handle replace action
                            },
                            icon: const Icon(
                              Icons.file_upload_outlined,
                              size: 18,
                              color: Colors.white,
                            ),
                            label: Text(
                              'Replace',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _darkGreen,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
