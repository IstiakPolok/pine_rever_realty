import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

import '../../../../../core/const/app_colors.dart';
import '../../../../../core/models/profile_response.dart';
import '../../../../../core/network_caller/endpoints.dart';
import '../../../../../core/services_class/local_service/shared_preferences_helper.dart';

class EditProfileScreen extends StatefulWidget {
  final ProfileResponse profile;
  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  File? _selectedImage;
  Uint8List? _selectedImageBytes;
  String? _selectedImageName;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill controllers with existing profile data for better UX
    _firstNameController = TextEditingController(
      text: widget.profile.firstName ?? '',
    );
    _lastNameController = TextEditingController(
      text: widget.profile.lastName ?? '',
    );
    _emailController = TextEditingController(text: widget.profile.email);
    _phoneController = TextEditingController(
      text: widget.profile.phoneNumber ?? '',
    );
    _locationController = TextEditingController(
      text: widget.profile.location ?? '',
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
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
        withData: true, // ensure bytes available across platforms
      );

      if (result == null) {
        // User cancelled the picker
        Get.snackbar('Cancelled', 'Image selection cancelled');
        print('pickImage: user cancelled picker (result == null)');
        return;
      }

      final pickedFile = result.files.single;

      // Prefer path if available, otherwise use the in-memory bytes
      if (pickedFile.path != null && pickedFile.path!.isNotEmpty) {
        final picked = File(pickedFile.path!);
        if (!picked.existsSync()) {
          Get.snackbar('Error', 'Selected file does not exist');
          print('pickImage: picked file does not exist -> ${picked.path}');
          return;
        }

        setState(() {
          _selectedImage = picked;
          _selectedImageBytes = null;
          _selectedImageName = picked.path.split('/').last;
        });

        try {
          final size = picked.lengthSync();
          print('Picked image: ${picked.path} (size: $size bytes)');
        } catch (e) {
          print('Picked image path: ${picked.path} (could not read size: $e)');
        }
      } else if (pickedFile.bytes != null) {
        setState(() {
          _selectedImage = null;
          _selectedImageBytes = pickedFile.bytes;
          _selectedImageName = pickedFile.name;
        });
        print(
          'Picked image bytes: ${pickedFile.name} (size: ${_selectedImageBytes!.lengthInBytes} bytes)',
        );
      } else {
        Get.snackbar('Error', 'Could not read selected image');
        print('pickImage: no path and no bytes available for selected file');
        return;
      }

      Get.snackbar(
        'Image Selected',
        'Tap Save to upload the new profile image',
      );
    } catch (e) {
      print('Error opening image picker: $e');
      Get.snackbar('Error', 'Failed to open image picker');
    }
  }

  Future<void> _updateProfile() async {
    setState(() {
      _isUpdating = true;
    });

    try {
      String? token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        Get.snackbar('Error', 'No access token found');
        setState(() {
          _isUpdating = false;
        });
        return;
      }

      // Prepare fields (use controller text if provided, otherwise use existing profile values)
      final Map<String, String> fields = {
        'first_name': _firstNameController.text.isEmpty
            ? (widget.profile.firstName ?? '')
            : _firstNameController.text,
        'last_name': _lastNameController.text.isEmpty
            ? (widget.profile.lastName ?? '')
            : _lastNameController.text,
        'email': _emailController.text.isEmpty
            ? widget.profile.email
            : _emailController.text,
        'phone_number': _phoneController.text.isEmpty
            ? (widget.profile.phoneNumber ?? '')
            : _phoneController.text,
        'location': _locationController.text.isEmpty
            ? (widget.profile.location ?? '')
            : _locationController.text,
      };

      // Validate selected image exists
      if (_selectedImage != null && !_selectedImage!.existsSync()) {
        Get.snackbar('Error', 'Selected image not found');
        setState(() {
          _isUpdating = false;
        });
        return;
      }

      if (_selectedImage != null) {
        // Debug info
        try {
          final size = _selectedImage!.lengthSync();
          print('Selected image: ${_selectedImage!.path} (size: $size bytes)');
        } catch (e) {
          print('Could not read selected image size: $e');
        }
      }

      // Primary attempt: PATCH multipart
      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse(Urls.sellerProfileUpdate),
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

      // helpful debug info
      request.headers['Accept'] = 'application/json';
      print(
        'Uploading: fields=${request.fields} files=${request.files.length}',
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Profile updated successfully');
        if (!mounted) return;
        Navigator.pop(context, true); // Return true to indicate update
        return;
      }

      // If PATCH failed, log details and attempt a POST fallback with _method=PATCH
      print('PATCH update failed: ${response.statusCode} -> ${response.body}');

      // Fallback: try POST with _method override (some servers don't accept multipart PATCH)
      var fallbackRequest = http.MultipartRequest(
        'POST',
        Uri.parse(Urls.sellerProfileUpdate),
      );
      fallbackRequest.headers['Authorization'] = 'Bearer $token';
      fallbackRequest.fields.addAll(fields);
      fallbackRequest.fields['_method'] = 'PATCH';

      if (_selectedImage != null) {
        final fileName = _selectedImage!.path.split('/').last;
        final mimeType =
            lookupMimeType(_selectedImage!.path) ?? 'application/octet-stream';
        fallbackRequest.files.add(
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
        fallbackRequest.files.add(
          http.MultipartFile.fromBytes(
            'profile_image',
            _selectedImageBytes!,
            filename: _selectedImageName,
            contentType: MediaType(parts[0], parts[1]),
          ),
        );
      }

      // helpful debug info
      fallbackRequest.headers['Accept'] = 'application/json';
      print(
        'Fallback upload: fields=${fallbackRequest.fields} files=${fallbackRequest.files.length}',
      );

      var fallbackStream = await fallbackRequest.send();
      var fallbackResponse = await http.Response.fromStream(fallbackStream);

      if (fallbackResponse.statusCode == 200) {
        Get.snackbar('Success', 'Profile updated (fallback)');
        if (!mounted) return;
        Navigator.pop(context, true);
        return;
      }

      // Both attempts failed — show detailed error
      print(
        'Fallback update failed: ${fallbackResponse.statusCode} -> ${fallbackResponse.body}',
      );
      Get.snackbar(
        'Error',
        'Failed to update profile: ${fallbackResponse.statusCode}\n${fallbackResponse.body}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Error updating profile: $e');
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      setState(() {
        _isUpdating = false;
      });
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
                              : (widget.profile.profileImage != null
                                        ? NetworkImage(
                                            widget.profile.profileImage!,
                                          )
                                        : const NetworkImage(
                                            'https://media.istockphoto.com/id/2151669184/vector/vector-flat-illustration-in-grayscale-avatar-user-profile-person-icon-gender-neutral.jpg?s=612x612&w=0&k=20&c=UEa7oHoOL30ynvmJzSCIPrwwopJdfqzBs0q69ezQoM8=',
                                          ))
                                    as ImageProvider,
                        ),
                      ),
                      Positioned(
                        bottom: 0.h,
                        right: 0.w,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _pickImage,
                            borderRadius: BorderRadius.circular(8.r),
                            child: Container(
                              padding: EdgeInsets.all(8.r),
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
                    label: 'First Name',
                    controller: _firstNameController,
                    hint: widget.profile.firstName ?? 'Enter first name',
                    icon: Icons.person_outline,
                  ),
                  SizedBox(height: 20.h),
                  _buildLabeledTextField(
                    label: 'Last Name',
                    controller: _lastNameController,
                    hint: widget.profile.lastName ?? 'Enter last name',
                    icon: Icons.person_outline,
                  ),
                  SizedBox(height: 20.h),
                  _buildLabeledTextField(
                    label: 'Email',
                    controller: _emailController,
                    hint: widget.profile.email,
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 20.h),
                  _buildLabeledTextField(
                    label: 'Phone Number',
                    controller: _phoneController,
                    hint: widget.profile.phoneNumber ?? 'Enter phone number',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 20.h),
                  _buildLabeledTextField(
                    label: 'Location',
                    controller: _locationController,
                    hint: widget.profile.location ?? 'Enter location',
                    icon: Icons.location_on_outlined,
                  ),

                  SizedBox(height: 40.h),

                  // --- Save Button ---
                  SizedBox(
                    width: 1.sw,
                    child: ElevatedButton(
                      onPressed: _isUpdating ? null : _updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: _isUpdating
                          ? const CircularProgressIndicator(color: Colors.white)
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
    required TextEditingController controller,
    required String hint,
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
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: Colors.grey[400],
            ),
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
