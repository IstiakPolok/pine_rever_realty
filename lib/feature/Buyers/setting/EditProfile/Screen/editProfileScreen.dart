import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

import '../../../../../core/const/app_colors.dart';
import '../../../../../core/models/profile_response.dart';
import '../../../../../core/network_caller/endpoints.dart';
import '../../../../../core/services_class/local_service/shared_preferences_helper.dart';

class EditProfileScreen extends StatefulWidget {
  final ProfileResponse? profile;
  const EditProfileScreen({super.key, this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  bool _isSaving = false;
  File? _selectedImage;
  Uint8List? _selectedImageBytes;
  String? _selectedImageName;

  @override
  void initState() {
    super.initState();
    final fullName = '${widget.profile?.firstName ?? ''}'.trim();
    _nameController = TextEditingController(
      text: fullName.isNotEmpty
          ? fullName
          : '${widget.profile?.firstName ?? ''} ${widget.profile?.lastName ?? ''}'
                .trim(),
    );
    _emailController = TextEditingController(text: widget.profile?.email ?? '');
    _phoneController = TextEditingController(
      text: widget.profile?.phoneNumber ?? '',
    );
    _locationController = TextEditingController(
      text: widget.profile?.location ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();

    super.dispose();
  }

  Future<void> _pickImage() async {
    print('pickImage: tapped');
    Get.snackbar('Opening', 'Opening image picker...');
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );

      if (result == null) {
        Get.snackbar('Cancelled', 'Image selection cancelled');
        return;
      }

      final pickedFile = result.files.single;
      if (pickedFile.path != null && pickedFile.path!.isNotEmpty) {
        final f = File(pickedFile.path!);
        if (!f.existsSync()) {
          Get.snackbar('Error', 'Selected file does not exist');
          return;
        }
        setState(() {
          _selectedImage = f;
          _selectedImageBytes = null;
          _selectedImageName = f.path.split('/').last;
        });
      } else if (pickedFile.bytes != null) {
        setState(() {
          _selectedImage = null;
          _selectedImageBytes = pickedFile.bytes;
          _selectedImageName = pickedFile.name;
        });
      } else {
        Get.snackbar('Error', 'Could not read selected image');
        return;
      }

      Get.snackbar(
        'Image Selected',
        'Tap Save to upload the new profile image',
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  Future<void> _saveProfile() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        Get.snackbar('Error', 'No access token found');
        setState(() {
          _isSaving = false;
        });
        return;
      }

      final fullName = _nameController.text.trim();
      String firstName = '';
      String lastName = '';
      if (fullName.isNotEmpty) {
        final parts = fullName.split(' ');
        firstName = parts.first;
        lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';
      }

      final fields = <String, String>{
        'first_name': firstName,
        'last_name': lastName,
        'email': _emailController.text.trim(),
        'phone_number': _phoneController.text.trim(),
        'location': _locationController.text.trim(),
      };

      // Prepare multipart PATCH request
      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse(Urls.buyerProfileUpdate),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.fields.addAll(fields);

      if (_selectedImage != null) {
        final fileName = _selectedImage!.path.split('/').last;
        final mimeType =
            lookupMimeType(_selectedImage!.path) ?? 'application/octet-stream';
        request.files.add(
          await http.MultipartFile.fromPath(
            'profile_image',
            _selectedImage!.path,
            filename: fileName,
            contentType: MediaType.parse(mimeType),
          ),
        );
      } else if (_selectedImageBytes != null && _selectedImageName != null) {
        final mimeType =
            lookupMimeType(_selectedImageName!) ?? 'application/octet-stream';
        final parts = mimeType.split('/');
        request.files.add(
          http.MultipartFile.fromBytes(
            'profile_image',
            _selectedImageBytes!,
            filename: _selectedImageName,
            contentType: MediaType(parts[0], parts[1]),
          ),
        );
      }

      request.headers['Accept'] = 'application/json';
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Profile updated successfully');
        Navigator.pop(context, true);
        return;
      }

      // Fallback POST with _method=PATCH
      var fallback = http.MultipartRequest(
        'POST',
        Uri.parse(Urls.buyerProfileUpdate),
      );
      fallback.headers['Authorization'] = 'Bearer $token';
      fallback.fields.addAll(fields);
      fallback.fields['_method'] = 'PATCH';

      if (_selectedImage != null) {
        final fileName = _selectedImage!.path.split('/').last;
        final mimeType =
            lookupMimeType(_selectedImage!.path) ?? 'application/octet-stream';
        fallback.files.add(
          await http.MultipartFile.fromPath(
            'profile_image',
            _selectedImage!.path,
            filename: fileName,
            contentType: MediaType.parse(mimeType),
          ),
        );
      } else if (_selectedImageBytes != null && _selectedImageName != null) {
        final mimeType =
            lookupMimeType(_selectedImageName!) ?? 'application/octet-stream';
        final parts = mimeType.split('/');
        fallback.files.add(
          http.MultipartFile.fromBytes(
            'profile_image',
            _selectedImageBytes!,
            filename: _selectedImageName,
            contentType: MediaType(parts[0], parts[1]),
          ),
        );
      }

      final fallbackStream = await fallback.send();
      final fallbackResponse = await http.Response.fromStream(fallbackStream);
      if (fallbackResponse.statusCode == 200) {
        Get.snackbar('Success', 'Profile updated (fallback)');
        Navigator.pop(context, true);
        return;
      }

      Get.snackbar(
        'Error',
        'Failed to update profile: ${fallbackResponse.statusCode}\n${fallbackResponse.body}',
      );
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- Header Section ---
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                // ClipPath(
                //   clipper: EditProfileHeaderClipper(),
                //   child: Container(
                //     height: 350.h,
                //     width: 1.sw,
                //     color: secondaryColor,
                //   ),
                // ),
                Positioned(
                  top: -100.h,
                  right: -50.w,
                  child: Container(
                    width: 350.w,
                    height: 350.h,
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                ClipPath(
                  clipper: EditProfileHeaderClipper(),
                  child: Container(
                    height: 240.h,
                    width: 1.sw,
                    color: primaryColor,
                  ),
                ),

                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Edit Profile',
                            style: GoogleFonts.lora(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 4. Profile Picture with Camera Icon
                Positioned(
                  bottom: -60.h,
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(4.r),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 60.r,
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : (_selectedImageBytes != null
                                    ? MemoryImage(_selectedImageBytes!)
                                          as ImageProvider
                                    : (widget.profile?.profileImage != null
                                          ? NetworkImage(
                                              widget.profile!.profileImage!,
                                            )
                                          : const NetworkImage(
                                              'https://media.istockphoto.com/id/2151669184/vector/vector-flat-illustration-in-grayscale-avatar-user-profile-person-icon-gender-neutral.jpg?s=612x612&w=0&k=20&c=UEa7oHoOL30ynvmJzSCIPrwwopJdfqzBs0q69ezQoM8=',
                                            ))),
                        ),
                      ),
                      Positioned(
                        bottom: 0.h,
                        right: 0.w,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              print('camera icon tapped');
                              Get.snackbar(
                                'Opening',
                                'Opening image picker...',
                              );
                              _pickImage();
                            },
                            borderRadius: BorderRadius.circular(8.r),
                            child: Container(
                              padding: EdgeInsets.all(12.r),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2D6A5F),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2.w,
                                ),
                              ),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 80.h), // Space for avatar
            // --- Form Fields ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  _buildLabeledTextField(
                    label: 'Full Name',
                    controller: _nameController,
                    icon: Icons.person_outline,
                  ),
                  SizedBox(height: 20.h),
                  _buildLabeledTextField(
                    label: 'Email',
                    controller: _emailController,
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 20.h),
                  _buildLabeledTextField(
                    label: 'Phone Number',
                    controller: _phoneController,
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 20.h),
                  _buildLabeledTextField(
                    label: 'Location',
                    controller: _locationController,
                    icon: Icons.location_on_outlined,
                  ),

                  SizedBox(height: 40.h),

                  // --- Save Button ---
                  SizedBox(
                    width: 1.sw,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: _isSaving
                          ? SizedBox(
                              height: 20.h,
                              width: 20.h,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Save',
                              style: GoogleFonts.lora(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabeledTextField({
    required String label,
    TextEditingController? controller,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.lora(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: primaryText,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.poppins(fontSize: 14.sp, color: primaryText),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: primaryText, size: 22.sp),
            contentPadding: EdgeInsets.symmetric(
              vertical: 16.h,
              horizontal: 16.w,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: primaryColor, width: 1.5.w),
            ),
            filled: true,
            fillColor: const Color(0xFFFAFAFA), // Very light grey fill
          ),
        ),
      ],
    );
  }
}

// Custom Clipper for the Edit Profile Header (slightly simpler curve)
class EditProfileHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 60);

    var controlPoint = Offset(size.width / 2, size.height + 20);
    var endPoint = Offset(size.width, size.height - 80);

    path.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      endPoint.dx,
      endPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
