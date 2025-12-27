import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:pine_rever_realty/core/const/app_colors.dart';
import '../../../../core/network_caller/endpoints.dart';
import '../../../../core/services_class/local_service/shared_preferences_helper.dart';
import '../../bottom_nav_bar/screen/Agent_bottom_nav_bar.dart';

class AgentSellingAgreementScreen extends StatefulWidget {
  final int propertyDocumentId;
  const AgentSellingAgreementScreen({
    super.key,
    required this.propertyDocumentId,
  });

  @override
  State<AgentSellingAgreementScreen> createState() =>
      _AgentSellingAgreementScreenState();
}

class _AgentSellingAgreementScreenState
    extends State<AgentSellingAgreementScreen> {
  PlatformFile? _selectedFile;
  bool _isUploading = false;

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
          'Selling Agreement',
          style: GoogleFonts.lora(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: const Color(0xFF2D6A5F),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Attach Selling Agreement',
                      style: GoogleFonts.lora(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: primaryText,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Upload Selling Agreement',
                      style: GoogleFonts.lora(
                        fontSize: 13.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(32.w),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE0F2F1),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Icon(
                                Icons.image_outlined,
                                color: const Color(0xFF2D6A5F),
                                size: 40.sp,
                              ),
                            ),
                            SizedBox(height: 24.h),
                            Text(
                              'Upload Documents',
                              style: GoogleFonts.lora(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: primaryText,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Supported formats: PDF, JPG, PNG (max 10 MB)',
                              style: GoogleFonts.lora(
                                fontSize: 11.sp,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 24.h),
                            OutlinedButton(
                              onPressed: _pickFile,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: primaryText,
                                side: BorderSide(color: Colors.grey[400]!),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24.w,
                                  vertical: 12.h,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              child: Text(
                                _selectedFile == null
                                    ? 'Upload Agreement'
                                    : 'Change File',
                                style: GoogleFonts.lora(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),
                            if (_selectedFile != null) ...[
                              Text(_selectedFile!.name),
                              const SizedBox(height: 8),
                            ],

                            if (_uploadResultMsg.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                _uploadResultMsg,
                                style: GoogleFonts.poppins(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isUploading ? null : _uploadAgreement,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B4D3E),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  elevation: 0,
                ),
                child: _isUploading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Send',
                        style: GoogleFonts.lora(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _uploadResultMsg = '';

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        withData: true,
      );
      if (result == null) {
        Get.snackbar('Cancelled', 'No file selected');
        return;
      }
      setState(() {
        _selectedFile = result.files.first;
      });
      print(
        'AgentSellingAgreement: selected ${_selectedFile!.name} size=${_selectedFile!.size} path=${_selectedFile!.path}',
      );
    } catch (e) {
      print('Error picking file: $e');
      Get.snackbar('Error', 'Failed to pick file');
    }
  }

  Future<void> _uploadAgreement() async {
    if (_selectedFile == null) {
      Get.snackbar('No file', 'Please choose a file to upload');
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadResultMsg = '';
    });

    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        Get.snackbar('Error', 'No access token found');
        setState(() => _isUploading = false);
        return;
      }

      final url =
          '${Urls.baseUrl}/agent/property-documents/${widget.propertyDocumentId}/selling-agreement/upload/';
      print('AgentSellingAgreement: Uploading to $url');

      // Use PATCH when updating the existing property document's selling agreement
      var request = http.MultipartRequest('PATCH', Uri.parse(url));
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';
      print(
        'AgentSellingAgreement: sending PATCH multipart request with headers: ${request.headers}',
      );

      final name = _selectedFile!.name;
      Uint8List? bytes = _selectedFile!.bytes;
      if (bytes == null && _selectedFile!.path != null) {
        try {
          bytes = await File(_selectedFile!.path!).readAsBytes();
          print(
            'Read bytes from path ${_selectedFile!.path}: ${bytes.lengthInBytes}',
          );
        } catch (e, st) {
          print(
            'Failed to read file bytes from path ${_selectedFile!.path}: $e\n$st',
          );
        }
      }

      if (bytes == null) {
        Get.snackbar('Error', 'No file bytes available');
        setState(() => _isUploading = false);
        return;
      }

      var mimeType = lookupMimeType(_selectedFile!.path ?? name);
      if (mimeType == null) {
        print(
          'AgentSellingAgreement: lookupMimeType returned null, defaulting to application/octet-stream',
        );
        mimeType = 'application/octet-stream';
      }
      final parts = mimeType.split('/');
      final type0 = parts.isNotEmpty ? parts[0] : 'application';
      final type1 = parts.length > 1 ? parts[1] : 'octet-stream';

      try {
        request.files.add(
          http.MultipartFile.fromBytes(
            'selling_agreement_file',
            bytes,
            filename: name,
            contentType: MediaType(type0, type1),
          ),
        );
      } catch (e, st) {
        print('Error adding file part for $name: $e\n$st');
        Get.snackbar('Error', 'Failed to attach file: $e');
        setState(() => _isUploading = false);
        return;
      }

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      print(
        'AgentSellingAgreement: upload response ${response.statusCode} -> ${response.body}',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonBody = jsonDecode(response.body);
        final message = jsonBody['message'] ?? 'Selling agreement uploaded';
        setState(() {
          _uploadResultMsg = message;
          _selectedFile = null;
        });
        Get.snackbar('Success', message);
        _showSuccessDialog(context, message: message, data: jsonBody['data']);
      } else {
        Get.snackbar('Error', 'Upload failed: ${response.statusCode}');
        setState(
          () => _uploadResultMsg = 'Upload failed: ${response.statusCode}',
        );
      }
    } catch (e, st) {
      print('Error uploading agreement: $e\n$st');
      Get.snackbar('Error', 'An error occurred during upload: $e');
      setState(() => _uploadResultMsg = 'Error during upload: $e');
    } finally {
      setState(() => _isUploading = false);
    }
  }

  void _showSuccessDialog(
    BuildContext context, {
    String? message,
    Map<String, dynamic>? data,
  }) {
    final msg = message ?? 'Uploaded Successfully!';
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(32.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/image/prevarify.jpg',
                  height: 200.h,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.check_circle,
                      color: const Color(0xFF2D6A5F),
                      size: 100.sp,
                    );
                  },
                ),
                SizedBox(height: 24.h),
                Text(
                  msg,
                  style: GoogleFonts.lora(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: primaryText,
                  ),
                ),
                if (data != null && data['selling_agreement_file'] != null) ...[
                  SizedBox(height: 12.h),
                  Text(
                    'File: ${data['selling_agreement_file']}',
                    style: GoogleFonts.poppins(fontSize: 12.sp),
                  ),
                ],
                SizedBox(height: 32.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.offAll(() => const AgentBottomNavbar());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B4D3E),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Return to Home',
                      style: GoogleFonts.lora(
                        fontSize: 16.sp,
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
}
