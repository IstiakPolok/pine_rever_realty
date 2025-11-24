import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/const/app_colors.dart';

class ShowingAgreementScreen extends StatefulWidget {
  const ShowingAgreementScreen({super.key});

  @override
  State<ShowingAgreementScreen> createState() => _ShowingAgreementScreenState();
}

class _ShowingAgreementScreenState extends State<ShowingAgreementScreen> {
  // Colors

  // Form State
  bool _is7Days = false;
  bool _isOneProperty = false;
  bool _agreedToTerms = false;

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
          'Showing Agreement',
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
            // Title
            Text(
              'Showing Agreement',
              style: GoogleFonts.lora(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryText,
              ),
            ),
            const SizedBox(height: 16),

            // Purpose
            RichText(
              text: TextSpan(
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: primaryText,
                  height: 1.5,
                ),
                children: [
                  TextSpan(
                    text: 'Purpose: ',
                    style: GoogleFonts.lora(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(
                    text:
                        'Allows buyers to tour or view one or more properties without full representation',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Buyer Information
            _buildSectionTitle('Buyer Information'),
            _buildUnderlinedField(
              label: 'Buyer Name',
              initialValue: 'John Doe',
            ),
            _buildUnderlinedField(
              label: 'Contact Number',
              initialValue: '+1 555 0123',
            ),
            _buildUnderlinedField(
              label: 'Email',
              initialValue: 'johndoe@example.com',
            ),
            const SizedBox(height: 24),

            // Agent Information
            _buildSectionTitle('Agent Information'),
            _buildUnderlinedField(
              label: 'Agent Name',
              initialValue: 'Sarah Johnson',
            ),
            _buildUnderlinedField(
              label: 'License Number',
              initialValue: 'RE-12345678',
            ),
            _buildUnderlinedField(
              label: 'Agency Name',
              initialValue: 'Premium Real Estate',
            ),
            const SizedBox(height: 24),

            // Agreement Details
            _buildSectionTitle('Agreement Details'),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Duration: ',
                  style: GoogleFonts.poppins(fontSize: 14, color: primaryText),
                ),
                const SizedBox(width: 8),
                _buildCheckboxLabel(
                  '7 Days',
                  _is7Days,
                  (val) => setState(() => _is7Days = val!),
                ),
                const SizedBox(width: 16),
                _buildCheckboxLabel(
                  'One Property Only',
                  _isOneProperty,
                  (val) => setState(() => _isOneProperty = val!),
                ),
              ],
            ),
            _buildUnderlinedField(
              label: 'Property Address (if applicable)',
              initialValue: '123 Oak Street, Springfield',
            ),
            _buildUnderlinedField(
              label: 'Showing Date',
              initialValue: 'Nov 15, 2025',
            ),
            const SizedBox(height: 24),

            // Terms & Conditions
            _buildSectionTitle('Terms & Conditions'),
            const SizedBox(height: 8),
            _buildBulletPoint(
              'This agreement is solely for property tours or showings and does not establish an exclusive relationship between the Agent and the Buyer.',
            ),
            _buildBulletPoint(
              'The Agent will coordinate and accompany the Buyer during property tours.',
            ),
            _buildBulletPoint(
              'Confidentiality and data protection policies apply to all shared information.',
            ),
            _buildBulletPoint(
              'No commission or representation fee is due under this agreement.',
            ),
            _buildBulletPoint(
              'All electronic signatures collected through the app are securely encrypted and stored.',
            ),
            const SizedBox(height: 24),

            // Checkbox Agreement
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    value: _agreedToTerms,
                    activeColor: primaryColor,
                    onChanged: (val) => setState(() => _agreedToTerms = val!),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: secondaryText,
                      ),
                      children: [
                        const TextSpan(
                          text: 'I have read and agree to the terms of this ',
                        ),
                        TextSpan(
                          text: 'Showing Agreement.',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Signature
            Text(
              'Signature',
              style: GoogleFonts.lora(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryText,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              // In a real app, you would use a Signature Pad widget here
              // For UI purposes, keep it empty or add a placeholder
            ),
            const SizedBox(height: 16),
            _buildUnderlinedField(label: 'Date', initialValue: 'Nov 12, 2025'),
            const SizedBox(height: 32),

            // Finish Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _agreedToTerms
                    ? () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Agreement Signed Successfully!'),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  disabledBackgroundColor: primaryColor.withOpacity(0.5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.edit_outlined, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Finish & Sign',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: GoogleFonts.lora(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: primaryText,
        ),
      ),
    );
  }

  Widget _buildUnderlinedField({required String label, String? initialValue}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Bullet point for list style items
          Container(
            margin: const EdgeInsets.only(right: 8, bottom: 4),
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
          Text(
            '$label: ',
            style: GoogleFonts.poppins(fontSize: 14, color: primaryText),
          ),
          Expanded(
            child: SizedBox(
              height: 24,
              child: TextFormField(
                initialValue: initialValue,
                style: GoogleFonts.poppins(fontSize: 14, color: primaryText),
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.only(bottom: 4),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxLabel(
    String label,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return Row(
      children: [
        SizedBox(
          height: 20,
          width: 20,
          child: Checkbox(
            value: value,
            activeColor: primaryColor,
            onChanged: onChanged,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 14, color: primaryText),
        ),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6.0, right: 8.0),
            child: Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: primaryText,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
