import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/const/app_colors.dart';

class ViewCMAReportScreen extends StatelessWidget {
  const ViewCMAReportScreen({super.key});

  // Colors
  // Dark green for button
  static const Color _borderGreen = Color(0xFF2D6A5F); // Border color

  static const Color _iconBg = Color(0xFFE0F2F1); // Light teal bg for main icon
  static const Color _docBg = Color(
    0xFFEAEAEA,
  ); // Light grey for doc placeholders

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
        // Added scroll view for safety on smaller screens
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Properties Document',
              style: GoogleFonts.lora(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: primaryText,
              ),
            ),
            const SizedBox(height: 24),

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
                  Text(
                    'Property Documents',
                    style: GoogleFonts.lora(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: primaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add property doc. to prepare property CMA',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: secondaryText,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Inner Upload Area
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 32,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Icon
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: _iconBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.attach_file,
                            color:
                                _borderGreen, // Using border green for icon color
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // "Upload Documents or Photos" Text
                        Text(
                          'Upload Documents or Photos',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lora(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: primaryText,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Supported formats
                        Text(
                          'Supported formats: PDF, JPG, PNG (max 10 MB)',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // "Choose Files" Button
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _borderGreen, // Dark teal
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Choose Files',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Document Placeholders Row
                  Row(
                    children: [
                      _buildDocPlaceholder(),
                      const SizedBox(width: 16),
                      _buildDocPlaceholder(),
                      const SizedBox(width: 16),
                      _buildDocPlaceholder(),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // --- View CMA Report Button ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle View Report
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening Report...')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'View CMA Report',
                  style: GoogleFonts.lora(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDocPlaceholder() {
    return Expanded(
      child: Container(
        height: 80, // Adjust height as needed
        decoration: BoxDecoration(
          color: _docBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Icon(
            Icons.description_outlined, // Generic document icon
            color: Colors.grey[400],
            size: 30,
          ),
        ),
      ),
    );
  }
}
