import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../../../core/const/app_colors.dart';
import '../../../../core/network_caller/endpoints.dart';
import '../../../../core/services_class/local_service/shared_preferences_helper.dart';

class ViewCMAReportScreen extends StatefulWidget {
  final int sellingRequestId;
  const ViewCMAReportScreen({super.key, required this.sellingRequestId});

  @override
  State<ViewCMAReportScreen> createState() => _ViewCMAReportScreenState();
}

class _ViewCMAReportScreenState extends State<ViewCMAReportScreen> {
  List<PlatformFile> _selectedFiles = [];
  bool _isUploading = false;
  String _uploadResult = '';

  late TextEditingController _titleController;

  // Colors
  // Dark green for button
  static const Color _borderGreen = Color(0xFF2D6A5F); // Border color

  static const Color _iconBg = Color(0xFFE0F2F1); // Light teal bg for main icon
  static const Color _docBg = Color(
    0xFFEAEAEA,
  ); // Light grey for doc placeholders

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
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
                          'Upload Documents or Photos to Get CMA Report',
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
                          onPressed: _pickFiles,
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
                        const SizedBox(height: 12),

                        // Document title (required)
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: 'Document title (required)',
                            hintText: 'Enter document title',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Selected files list
                        if (_selectedFiles.isNotEmpty) ...[
                          SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Selected files:',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: secondaryText,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          ..._selectedFiles.map(
                            (f) => Padding(
                              padding: const EdgeInsets.only(bottom: 6.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.insert_drive_file,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      f.name,
                                      style: GoogleFonts.poppins(fontSize: 13),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _selectedFiles.remove(f);
                                      });
                                    },
                                    icon: const Icon(Icons.close, size: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isUploading ? null : _uploadFiles,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
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
                                      'Upload Files',
                                      style: GoogleFonts.poppins(fontSize: 14),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                        if (_uploadResult.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            _uploadResult,
                            style: GoogleFonts.poppins(color: primaryText),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Document Placeholders Row
                  // Row(
                  //   children: [
                  //     _buildDocPlaceholder(),
                  //     const SizedBox(width: 16),
                  //     _buildDocPlaceholder(),
                  //     const SizedBox(width: 16),
                  //     _buildDocPlaceholder(),
                  //   ],
                  // ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // --- View CMA Report Button ---
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     onPressed: () {
            //       // Handle View Report
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         const SnackBar(content: Text('Opening Report...')),
            //       );
            //     },
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: primaryColor,
            //       foregroundColor: Colors.white,
            //       padding: const EdgeInsets.symmetric(vertical: 16),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(12),
            //       ),
            //     ),
            //     child: Text(
            //       'View CMA Report',
            //       style: GoogleFonts.lora(
            //         fontSize: 16,
            //         fontWeight: FontWeight.w500,
            //       ),
            //     ),
            //   ),
            // ),
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

      print('Selected ${_selectedFiles.length} file(s)');
      for (var f in _selectedFiles) {
        print(' - ${f.name} (size=${f.size} bytes, path=${f.path})');
      }
    } catch (e) {
      print('Error picking files: $e');
      Get.snackbar('Error', 'Failed to pick files');
    }
  }

  Future<void> _uploadFiles() async {
    if (_selectedFiles.isEmpty) {
      Get.snackbar('No files', 'Please select files to upload');
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadResult = '';
    });

    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        Get.snackbar('Error', 'No access token found');
        setState(() => _isUploading = false);
        return;
      }

      final url =
          '${Urls.baseUrl}/seller/selling-requests/${widget.sellingRequestId}/documents/upload/';
      print('Uploading ${_selectedFiles.length} files to $url');

      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      // Validate title (required by API)
      final title = _titleController.text.trim();
      if (title.isEmpty) {
        Get.snackbar('Validation', 'Title is required');
        setState(() => _isUploading = false);
        return;
      }

      request.fields['title'] = title;
      request.fields['document_type'] = 'other';
      print('Upload fields: title=$title, document_type=other');

      for (var f in _selectedFiles) {
        final name = f.name;
        Uint8List? bytes = f.bytes;
        print(
          'Preparing file: name=$name sizeField=${f.size} path=${f.path} bytesPresent=${bytes != null}',
        );

        if (bytes == null && f.path != null) {
          try {
            bytes = await File(f.path!).readAsBytes();
            print(
              'Read bytes from path ${f.path}: ${bytes.lengthInBytes} bytes',
            );
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
          print(
            'Error adding file part for $name: $e (bytes runtimeType=${bytes.runtimeType})',
          );
        }
      }

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      print('Upload response: ${response.statusCode} body=${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonBody = jsonDecode(response.body);
        setState(() {
          _uploadResult = jsonBody['message'] ?? 'Uploaded successfully';
          _selectedFiles = [];
          _titleController.clear();
        });
        Get.snackbar('Success', _uploadResult);
        print('Upload succeeded: $_uploadResult');
      } else {
        Get.snackbar('Error', 'Upload failed: ${response.statusCode}');
        print('Upload failed: ${response.statusCode} -> ${response.body}');
      }
    } catch (e) {
      print('Error uploading files: $e');
      Get.snackbar('Error', 'An error occurred during upload');
    } finally {
      setState(() => _isUploading = false);
    }
  }
}
