import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pine_rever_realty/core/services_class/profile_service.dart';

class EditMortgageLetterScreen extends StatefulWidget {
  const EditMortgageLetterScreen({super.key});

  @override
  State<EditMortgageLetterScreen> createState() =>
      _EditMortgageLetterScreenState();
}

class _EditMortgageLetterScreenState extends State<EditMortgageLetterScreen> {
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

  PlatformFile? _pickedFile;
  bool _isUploading = false;

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
        allowMultiple: false,
        withData: false,
      );
      if (result == null || result.files.isEmpty) return;
      setState(() {
        _pickedFile = result.files.first;
      });
    } catch (e) {
      print('Error picking file: $e');
      Get.snackbar('Error', 'Failed to pick file');
    }
  }

  Future<void> _uploadFile() async {
    if (_pickedFile == null) {
      Get.snackbar('No file', 'Please pick a file to upload');
      return;
    }

    setState(() => _isUploading = true);

    try {
      final updated = await ProfileService.updateBuyerProfileMultipart(
        mortgageLetterPath: _pickedFile!.path,
        mortgageLetterFilename: _pickedFile!.name,
      );

      if (updated != null) {
        Get.snackbar('Success', 'Mortgage letter updated');
        setState(() {
          _pickedFile = null;
        });
      } else {
        Get.snackbar('Error', 'Upload failed');
      }
    } catch (e) {
      print('Upload error: $e');
      Get.snackbar('Error', 'An error occurred');
    } finally {
      setState(() => _isUploading = false);
    }
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

                        // Picked File Name or Placeholder
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: null, // Disabled
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _disabledBtnColor,
                              disabledBackgroundColor: _disabledBtnColor,
                              foregroundColor: _textDark,
                              disabledForegroundColor: _textDark,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              _pickedFile?.name ?? 'Mortgage Letter',
                              style: GoogleFonts.lora(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Replace Button (picks file) and Upload Button
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _isUploading ? null : _pickFile,
                                icon: const Icon(
                                  Icons.attach_file,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  'Choose File',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _darkGreen,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _isUploading ? null : _uploadFile,
                                icon: _isUploading
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.file_upload_outlined,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                label: Text(
                                  _isUploading ? 'Uploading...' : 'Upload',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _darkGreen,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                            ),
                          ],
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
