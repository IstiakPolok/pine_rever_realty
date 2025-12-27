import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:pine_rever_realty/core/const/app_colors.dart';
import 'package:pine_rever_realty/core/network_caller/endpoints.dart';
import 'package:pine_rever_realty/core/services_class/local_service/shared_preferences_helper.dart';
import '../../login/screens/loginScreen.dart';

class AgentMakeProfileScreen extends StatefulWidget {
  const AgentMakeProfileScreen({super.key});

  @override
  State<AgentMakeProfileScreen> createState() => _AgentMakeProfileScreenState();
}

class _AgentMakeProfileScreenState extends State<AgentMakeProfileScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();

  PlatformFile? _profilePictureFile;
  PlatformFile? _agentPaperFile;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _licenseController.dispose();
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
          'Make Profile',
          style: GoogleFonts.lora(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey[200], height: 1.0),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _buildSectionCard(
              title: 'Profile Photo',
              child: Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: _profilePictureFile != null
                            ? ClipOval(
                                child: _profilePictureFile!.bytes != null
                                    ? Image.memory(
                                        _profilePictureFile!.bytes!,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File(_profilePictureFile!.path!),
                                        fit: BoxFit.cover,
                                      ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  shape: BoxShape.circle,
                                ),
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: const BoxDecoration(
                            color: Color(0xFF2D6A5F), // Dark teal
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upload a professional photo',
                          style: GoogleFonts.lora(
                            fontSize: 14.sp,
                            color: secondaryText,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        OutlinedButton(
                          onPressed: _pickProfilePicture,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: primaryText,
                            side: BorderSide(color: Colors.grey[300]!),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                          ),
                          child: Text(
                            'Choose Photo',
                            style: GoogleFonts.lora(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (_profilePictureFile != null) ...[
                          SizedBox(height: 6.h),
                          Text(
                            _profilePictureFile!.name,
                            style: GoogleFonts.lora(
                              fontSize: 11.sp,
                              color: secondaryText,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            _buildSectionCard(
              title: 'Basic Information',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Full Name'),
                  _buildTextField(
                    controller: _fullNameController,
                    hint: 'Full Name',
                  ),
                  SizedBox(height: 16.h),
                  _buildLabel('Phone Number'),
                  _buildTextField(
                    controller: _phoneController,
                    hint: 'Phone Number',
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            _buildSectionCard(
              title: 'Professional Information',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('License Number'),
                  _buildTextField(
                    controller: _licenseController,
                    hint: 'IL-RE-12345',
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            _buildSectionCard(
              title: 'Agent Papers',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Attach your agent certificate',
                    style: GoogleFonts.lora(
                      fontSize: 12.sp,
                      color: secondaryText,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 32.h),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F2F1), // Light teal bg
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Icons.attach_file,
                            color: const Color(0xFF2D6A5F),
                            size: 24.sp,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Upload Documents or Photos',
                          style: GoogleFonts.lora(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: primaryText,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Accepted formats: PDF, JPG, PNG. Maximum\nsize per file: 10 MB.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lora(
                            fontSize: 10.sp,
                            color: secondaryText,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: _pickAgentPaper,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2D6A5F),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 10.h,
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Choose Files',
                            style: GoogleFonts.lora(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (_agentPaperFile != null) ...[
                          SizedBox(height: 8.h),
                          Text(
                            _agentPaperFile!.name,
                            style: GoogleFonts.lora(
                              fontSize: 11.sp,
                              color: secondaryText,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _clearForm();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryText,
                      side: BorderSide(color: Colors.grey[400]!),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                    ),
                    child: Text(
                      'Clear',
                      style: GoogleFonts.lora(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B4D3E), // Dark Green
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      elevation: 0,
                    ),
                    child: _isSubmitting
                        ? SizedBox(
                            height: 18.sp,
                            width: 18.sp,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            'Send to verify',
                            style: GoogleFonts.lora(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.lora(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: primaryText,
            ),
          ),
          SizedBox(height: 16.h),
          child,
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: GoogleFonts.lora(
          fontSize: 14.sp,
          color: const Color(0xFF4A5568), // Dark grey/blueish
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEAEAEA), // Light grey background
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.lora(color: primaryText, fontSize: 14.sp),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
        ),
      ),
    );
  }

  Future<void> _pickProfilePicture() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _profilePictureFile = result.files.first;
      });
    }
  }

  Future<void> _pickAgentPaper() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      withData: false,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _agentPaperFile = result.files.first;
      });
    }
  }

  void _clearForm() {
    _fullNameController.clear();
    _phoneController.clear();
    _licenseController.clear();
    setState(() {
      _profilePictureFile = null;
      _agentPaperFile = null;
    });
  }

  Future<void> _submitProfile() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        Get.snackbar('Error', 'No access token found');
        setState(() {
          _isSubmitting = false;
        });
        return;
      }

      // Split full name into first and last
      final name = _fullNameController.text.trim();
      String firstName = '';
      String lastName = '';
      if (name.isNotEmpty) {
        final parts = name.split(' ');
        firstName = parts.first;
        if (parts.length > 1) {
          lastName = parts.sublist(1).join(' ');
        }
      }

      final uri = Uri.parse(Urls.agentProfileUpdate);
      final request = http.MultipartRequest('PATCH', uri);
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      // Add text fields if provided
      if (firstName.isNotEmpty) request.fields['first_name'] = firstName;
      if (lastName.isNotEmpty) request.fields['last_name'] = lastName;
      if (_phoneController.text.trim().isNotEmpty) {
        request.fields['phone_number'] = _phoneController.text.trim();
      }
      if (_licenseController.text.trim().isNotEmpty) {
        request.fields['license_number'] = _licenseController.text.trim();
      }

      // Optional: availability default if desired
      // request.fields['availability'] = 'part-time';

      // Add files
      if (_profilePictureFile != null) {
        if (_profilePictureFile!.path != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'profile_picture',
              _profilePictureFile!.path!,
              filename: _profilePictureFile!.name,
            ),
          );
        } else if (_profilePictureFile!.bytes != null) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'profile_picture',
              _profilePictureFile!.bytes!,
              filename: _profilePictureFile!.name,
            ),
          );
        }
      }

      if (_agentPaperFile != null && _agentPaperFile!.path != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'agent_papers',
            _agentPaperFile!.path!,
            filename: _agentPaperFile!.name,
          ),
        );
      }

      // Debug prints
      print('AgentMakeProfileScreen._submitProfile: PATCH $uri');
      print('AgentMakeProfileScreen._submitProfile: fields ${request.fields}');
      print(
        'AgentMakeProfileScreen._submitProfile: files ${request.files.map((f) => f.filename).toList()}',
      );

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      print(
        'AgentMakeProfileScreen._submitProfile: response ${response.statusCode}',
      );
      print('AgentMakeProfileScreen._submitProfile: body ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Parse and optionally use response
        try {
          jsonDecode(response.body);
        } catch (_) {}
        _showVerifiedDialog(context);
      } else {
        String message = 'Submission failed (${response.statusCode})';
        try {
          final body = jsonDecode(response.body);
          message = body['message']?.toString() ?? message;
        } catch (_) {}
        Get.snackbar('Error', message);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showVerifiedDialog(BuildContext context) {
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
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image
                Image.asset(
                  'assets/image/profileVerify.png', // Ensure this asset exists
                  height: 150.h,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.check_circle,
                      color: secondaryColor,
                      size: 100.sp,
                    );
                  },
                ),
                SizedBox(height: 24.h),
                // Title
                Text(
                  'Profile Verified!',
                  style: GoogleFonts.lora(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: primaryText,
                  ),
                ),
                SizedBox(height: 32.h),
                // Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.offAll(() => const LoginScreen(userRole: 'Agent'));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Go to Login',
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
