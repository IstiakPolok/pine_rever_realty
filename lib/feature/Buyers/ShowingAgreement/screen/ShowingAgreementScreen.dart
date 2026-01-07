import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../../../../core/const/app_colors.dart';
import '../../../../core/models/notification_model.dart';
import '../../../../core/network_caller/endpoints.dart';
import '../../../../core/services_class/local_service/shared_preferences_helper.dart';

class ShowingAgreementScreen extends StatefulWidget {
  final NotificationItem? notification;
  const ShowingAgreementScreen({super.key, this.notification});

  @override
  State<ShowingAgreementScreen> createState() => _ShowingAgreementScreenState();
}

class _ShowingAgreementScreenState extends State<ShowingAgreementScreen> {
  // Colors

  // Form State
  bool _is7Days = false;
  bool _isOneProperty = false;
  bool _agreedToTerms = false;
  bool _isSubmitting = false;

  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

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
              initialValue:
                  widget.notification?.buyerDetails?.fullName ?? 'John Doe',
            ),
            _buildUnderlinedField(
              label: 'Contact Number',
              initialValue:
                  widget.notification?.buyerDetails?.phoneNumber ??
                  '+1 555 0123',
            ),
            _buildUnderlinedField(
              label: 'Email',
              initialValue:
                  widget.notification?.buyerDetails?.email ??
                  'johndoe@example.com',
            ),
            const SizedBox(height: 24),

            // Agent Information
            _buildSectionTitle('Agent Information'),
            _buildUnderlinedField(
              label: 'Agent Name',
              initialValue:
                  widget.notification?.agentDetails?.fullName ??
                  'Sarah Johnson',
            ),
            _buildUnderlinedField(
              label: 'License Number',
              initialValue:
                  widget.notification?.agentDetails?.licenseNumber ??
                  'RE-12345678',
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
              initialValue:
                  widget.notification?.propertyDetails?.address ??
                  '123 Oak Street, Springfield',
            ),
            _buildUnderlinedField(
              label: 'Showing Date',
              initialValue:
                  widget.notification?.showingDetails?.requestedDate ??
                  DateFormat('MMM dd, yyyy').format(DateTime.now()),
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
            Stack(
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Signature(
                    controller: _signatureController,
                    height: 150,
                    backgroundColor: Colors.white,
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: IconButton(
                    icon: const Icon(Icons.clear, color: Colors.red, size: 20),
                    onPressed: () {
                      _signatureController.clear();
                    },
                    tooltip: 'Clear Signature',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildUnderlinedField(
              label: 'Date',
              initialValue: DateFormat('MMM dd, yyyy').format(DateTime.now()),
            ),
            const SizedBox(height: 32),

            // Finish Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_agreedToTerms && !_isSubmitting)
                    ? _submitAgreement
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
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Row(
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

  Future<void> _submitAgreement() async {
    if (widget.notification?.showingScheduleId == null) {
      Get.snackbar(
        'Error',
        'Showing schedule ID not found',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (_signatureController.isEmpty) {
      Get.snackbar(
        'Error',
        'Please provide a signature',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      setState(() => _isSubmitting = true);

      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        Get.snackbar(
          'Error',
          'Authentication token not found',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final signatureBytes = await _signatureController.toPngBytes();
      if (signatureBytes == null) {
        Get.snackbar(
          'Error',
          'Failed to capture signature',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final url = Urls.signShowingAgreement(
        widget.notification!.showingScheduleId!,
      );

      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      request.files.add(
        http.MultipartFile.fromBytes(
          'signature',
          signatureBytes,
          filename: 'signature.png',
        ),
      );

      request.fields['agreement_accepted'] = 'yes';

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print('Sign Agreement Response Status: ${response.statusCode}');
      print('Sign Agreement Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        Get.snackbar(
          'Success',
          'Agreement Signed Successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to submit agreement: ${response.statusCode}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error submitting agreement: $e');
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
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
