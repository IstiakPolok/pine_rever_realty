import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/const/app_colors.dart';

class PropertiesRequestFormScreen extends StatelessWidget {
  const PropertiesRequestFormScreen({super.key});

  static const Color _inputBg = Color(
    0xFFE0F2F1,
  ); // Light teal background for inputs

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
          'Selling Request',
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
              'Properties Request Form',
              style: GoogleFonts.lora(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: primaryText,
              ),
            ),
            const SizedBox(height: 24),

            // --- Description Section ---
            _buildFormSection(
              children: [
                Text(
                  'Description',
                  style: GoogleFonts.lora(fontSize: 16, color: primaryText),
                ),
                const SizedBox(height: 16),
                _buildLabel('Selling Reason'),
                _buildTextField(hint: 'Describe your reason', maxLines: 3),
              ],
            ),
            const SizedBox(height: 16),

            // --- Contact Section ---
            _buildFormSection(
              children: [
                Text(
                  'Contact',
                  style: GoogleFonts.lora(fontSize: 16, color: primaryText),
                ),
                const SizedBox(height: 16),
                _buildLabel('Name'),
                _buildTextField(hint: 'Name here'),
                const SizedBox(height: 12),
                _buildLabel('Email'),
                _buildTextField(
                  hint: 'Type email here',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                _buildLabel('Phone Number'),
                _buildTextField(
                  hint: 'Number',
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // --- Price Section ---
            _buildFormSection(
              children: [
                Text(
                  'Set Your Price',
                  style: GoogleFonts.lora(fontSize: 16, color: primaryText),
                ),
                const SizedBox(height: 16),
                _buildLabel('Asking Price'),
                _buildTextField(
                  hint: '\$ 450,000',
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // --- Time Frame Section ---
            _buildFormSection(
              children: [
                Text(
                  'Time Frame',
                  style: GoogleFonts.lora(fontSize: 16, color: primaryText),
                ),
                const SizedBox(height: 16),
                _buildLabel('Set Date'),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: _inputBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: Text(
                        'Select Date Range',
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      value: '11 Nov, 2025 - 12 Dec, 2025', // Mock value
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      items: ['11 Nov, 2025 - 12 Dec, 2025'].map((
                        String value,
                      ) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: GoogleFonts.poppins(
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (_) {},
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // --- Submit Button ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle Submission
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Request Sent!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Send Request',
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

  // --- Helper Widgets ---

  Widget _buildFormSection({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: GoogleFonts.lora(fontSize: 14, color: primaryText),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextField(
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(color: primaryText),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 14),
        filled: true,
        fillColor: _inputBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}
