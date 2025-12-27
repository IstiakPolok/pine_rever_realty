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

class AgentCMAScreen extends StatefulWidget {
  final int sellingRequestId;
  const AgentCMAScreen({super.key, required this.sellingRequestId});

  @override
  State<AgentCMAScreen> createState() => _AgentCMAScreenState();
}

class _AgentCMAScreenState extends State<AgentCMAScreen> {
  List<PlatformFile> _selectedFiles = [];
  bool _isUploading = false;
  // Use a fixed, non-editable title for CMA uploads
  final String _staticTitle = 'CMA Report';

  @override
  void dispose() {
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
          'CMA',
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
                      'Attach CMA',
                      style: GoogleFonts.lora(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: primaryText,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Upload CMA report',
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
                        // Make the content scrollable so it won't overflow when keyboard opens
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                              SizedBox(height: 12.h),

                              // Document title (static)
                              Row(
                                children: [
                                  Text(
                                    'Title:',
                                    style: GoogleFonts.lora(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Text(
                                      _staticTitle,
                                      style: GoogleFonts.poppins(),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Choose Files Button
                              OutlinedButton(
                                onPressed: _pickFiles,
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
                                  'Choose Files',
                                  style: GoogleFonts.lora(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8),
                              if (_selectedFiles.isNotEmpty) ...[
                                SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${_selectedFiles.length} file(s) selected',
                                    style: GoogleFonts.poppins(),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                ..._selectedFiles.map(
                                  (f) => Row(
                                    children: [
                                      const Icon(
                                        Icons.insert_drive_file,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(child: Text(f.name)),
                                      IconButton(
                                        onPressed: () => setState(
                                          () => _selectedFiles.remove(f),
                                        ),
                                        icon: const Icon(Icons.close, size: 16),
                                      ),
                                    ],
                                  ),
                                ),

                                // debug print area for selected files
                                if (_selectedFiles.isNotEmpty) ...[
                                  SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Tip: files will be uploaded as CMA documents',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _isUploading ? null : _uploadCMA,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1B4D3E),
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12.h,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
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
                                            'Upload CMA',
                                            style: GoogleFonts.lora(
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                  ),
                                ),

                                // debug upload result
                                if (_uploadResultMsg.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    _uploadResultMsg,
                                    style: GoogleFonts.poppins(
                                      color: primaryText,
                                    ),
                                  ),
                                ],
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     onPressed: () {
            //       _showSuccessDialog(context);
            //     },
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: const Color(0xFF1B4D3E),
            //       foregroundColor: Colors.white,
            //       padding: EdgeInsets.symmetric(vertical: 16.h),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(8.r),
            //       ),
            //       elevation: 0,
            //     ),
            //     child: Text(
            //       'Send',
            //       style: GoogleFonts.lora(
            //         fontSize: 16.sp,
            //         fontWeight: FontWeight.w600,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  String _uploadResultMsg = '';

  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        withData: true,
      );

      if (result == null) {
        Get.snackbar('Cancelled', 'No files selected');
        return;
      }

      setState(() {
        _selectedFiles = result.files;
      });

      print('AgentCMAScreen: selected ${_selectedFiles.length} files');
      for (var f in _selectedFiles) {
        print(' - ${f.name} size=${f.size} path=${f.path}');
      }
    } catch (e) {
      print('Error picking files: $e');
      Get.snackbar('Error', 'Failed to pick files');
    }
  }

  Future<void> _uploadCMA() async {
    if (_selectedFiles.isEmpty) {
      Get.snackbar('No files', 'Please choose files to upload');
      return;
    }

    final title = _staticTitle;
    print('AgentCMAScreen: using static title: $title');

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
          '${Urls.baseUrl}/agent/selling-requests/${widget.sellingRequestId}/cma/upload/';
      print('AgentCMAScreen: Uploading to $url with title=$title');

      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      request.fields['title'] = title;
      request.fields['document_type'] = 'cma';

      // Debug: print request summary before attaching files
      print('AgentCMAScreen: request headers: ${request.headers}');
      print('AgentCMAScreen: request fields: ${request.fields}');
      print('AgentCMAScreen: attaching ${_selectedFiles.length} file(s)');

      for (var f in _selectedFiles) {
        final name = f.name;
        Uint8List? bytes = f.bytes;
        if (bytes == null && f.path != null) {
          try {
            bytes = await File(f.path!).readAsBytes();
            print('Read bytes from path ${f.path}: ${bytes.lengthInBytes}');
          } catch (e) {
            print('Failed to read file bytes from path ${f.path}: $e');
          }
        }

        if (bytes == null) {
          print('Skipping $name: no bytes available');
          continue;
        }

        final mimeType =
            lookupMimeType(f.path ?? name) ?? 'application/octet-stream';
        final parts = mimeType.split('/');

        try {
          request.files.add(
            http.MultipartFile.fromBytes(
              'files',
              bytes,
              filename: name,
              contentType: MediaType(parts[0], parts[1]),
            ),
          );
          print(
            'Added file part: $name ($mimeType) size=${bytes.lengthInBytes}',
          );
        } catch (e) {
          print('Error adding file part for $name: $e');
        }
      }

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      print(
        'AgentCMAScreen: upload response ${response.statusCode} -> ${response.body}',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonBody = jsonDecode(response.body);
        final message = jsonBody['message'] ?? 'CMA uploaded';
        _showSuccessDialog(context, message: message);
        setState(() {
          _uploadResultMsg = message;
          _selectedFiles = [];
        });
        Get.snackbar('Success', message);
        // If server returned the created document, return it to the caller
        final createdDocument = jsonBody['document'] ?? jsonBody['data'];
        if (createdDocument != null) {
          print('AgentCMAScreen: returning created document to caller');
          try {
            print(
              'AgentCMAScreen: createdDocument: ${jsonEncode(createdDocument)}',
            );
          } catch (e) {
            print('AgentCMAScreen: failed to jsonEncode createdDocument: $e');
          }
          Get.back(result: createdDocument);
        } else {
          // Fallback: show success dialog
          _showSuccessDialog(context, message: message);
        }
      } else {
        Get.snackbar('Error', 'Upload failed: ${response.statusCode}');
        setState(
          () => _uploadResultMsg = 'Upload failed: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error uploading CMA: $e');
      Get.snackbar('Error', 'An error occurred during upload');
      setState(() => _uploadResultMsg = 'Error during upload');
    } finally {
      setState(() => _isUploading = false);
    }
  }

  void _showSuccessDialog(BuildContext context, {String? message}) {
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
