import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pine_rever_realty/core/const/app_colors.dart';
import 'package:get/get.dart';
import 'package:pine_rever_realty/feature/auth/login/model/login_response_model.dart';
import 'package:pine_rever_realty/core/services_class/profile_service.dart';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel? user;

  const EditProfileScreen({super.key, this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _locationController;
  late final TextEditingController _specializationController;
  late final TextEditingController _licenseController;
  late final TextEditingController _yearsExpController;
  late final TextEditingController _idController;
  late final TextEditingController _aboutController;

  // API expects enum values: 'full-time', 'part-time', 'project-based'
  String _selectedAvailability = 'full-time';

  static const Map<String, String> _availabilityLabels = {
    'full-time': 'Full-time',
    'part-time': 'Part-time',
    'project-based': 'Project-based',
  };
  final List<String> _languages = ['English'];
  final List<String> _serviceAreas = ['Downtown', 'Suburban Areas'];
  final List<String> _propertyTypes = ['Single Family', 'Condos'];

  PlatformFile? _profilePictureFile;
  PlatformFile? _agentPapersFile;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Prefill from passed user if available
    final u = widget.user;
    _nameController = TextEditingController(text: u?.fullName ?? '');
    _phoneController = TextEditingController(text: u?.phoneNumber ?? '');
    _emailController = TextEditingController(text: u?.email ?? '');
    _locationController = TextEditingController(text: '');
    _specializationController = TextEditingController(text: '');
    _licenseController = TextEditingController(text: u?.licenseNumber ?? '');
    _yearsExpController = TextEditingController(
      text: u?.createdAt.isNotEmpty == true ? '' : '',
    );
    _idController = TextEditingController();
    _aboutController = TextEditingController(text: '');

    // If passed user has profile_picture or agent_papers urls, don't preload files (user must re-upload), but display name.
    // keep defaults otherwise
    // If user already has availability set by API, use it (assumed to be api enum like 'full-time')
    _selectedAvailability = u?.availability ?? _selectedAvailability;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _specializationController.dispose();
    _licenseController.dispose();
    _yearsExpController.dispose();
    _idController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  Future<void> _pickProfilePicture() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() => _profilePictureFile = result.files.first);
    }
  }

  Future<void> _pickAgentPaper() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() => _agentPapersFile = result.files.first);
    }
  }

  Future<void> _saveChanges() async {
    final parts = _nameController.text.trim().split(' ');
    final firstName = parts.isNotEmpty ? parts.first : '';
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    // Basic validation
    if (_emailController.text.trim().isEmpty ||
        !_emailController.text.contains('@')) {
      Get.snackbar('Error', 'Please enter a valid email');
      return;
    }

    final payload = <String, dynamic>{
      'username': widget.user?.username ?? '',
      'email': _emailController.text.trim(),
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': _phoneController.text.trim(),
      'license_number': _licenseController.text.trim(),
      'company_details': '',
      'years_of_experience': int.tryParse(_yearsExpController.text) ?? null,
      'area_of_expertise': _specializationController.text.trim(),
      'languages': _languages.isNotEmpty ? _languages.join(',') : null,
      'availability': _selectedAvailability,
    }..removeWhere((k, v) => v == null || (v is String && v.isEmpty));

    // Debug prints
    print('EditProfileScreen._saveChanges: payload ${jsonEncode(payload)}');
    print(
      'EditProfileScreen._saveChanges: profile_picture_selected ${_profilePictureFile != null}',
    );
    print(
      'EditProfileScreen._saveChanges: agent_papers_selected ${_agentPapersFile != null}',
    );

    setState(() => _isSaving = true);
    UserModel? updated;
    try {
      // If files selected, use multipart
      if (_profilePictureFile != null || _agentPapersFile != null) {
        updated = await ProfileService.updateAgentProfileMultipart(
          fields: payload.map((k, v) => MapEntry(k, v.toString())),
          profilePicturePath: _profilePictureFile?.path,
          profilePictureBytes: _profilePictureFile?.bytes,
          profilePictureFilename: _profilePictureFile?.name,
          agentPapersPath: _agentPapersFile?.path,
          agentPapersBytes: _agentPapersFile?.bytes,
          agentPapersFilename: _agentPapersFile?.name,
        );
      } else {
        updated = await ProfileService.updateAgentProfile(payload);
      }

      if (updated != null) {
        Get.snackbar('Success', 'Profile updated');
        Navigator.of(context).pop(true);
      } else {
        Get.snackbar('Error', 'Failed to update profile');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Edit Profile',
          style: GoogleFonts.lora(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Photo Section
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile Photo',
                    style: GoogleFonts.lora(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: primaryText,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 35.r,
                        backgroundColor: primaryColor.withOpacity(0.1),
                        child: Icon(
                          Icons.person,
                          size: 40.sp,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Upload a profile photo',
                              style: GoogleFonts.lora(
                                fontSize: 14.sp,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 8.h),
                            ElevatedButton(
                              onPressed: _pickProfilePicture,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[200],
                                foregroundColor: Colors.black,
                                elevation: 0,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 8.h,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                              ),
                              child: Text(
                                'Choose Photo',
                                style: GoogleFonts.lora(fontSize: 13.sp),
                              ),
                            ),
                            if (_profilePictureFile != null) ...[
                              SizedBox(height: 6.h),
                              Text(
                                _profilePictureFile!.name,
                                style: GoogleFonts.lora(
                                  fontSize: 12.sp,
                                  color: Colors.grey[600],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Basic Information
            _buildSection('Basic Information', [
              _buildTextField('Full Name', _nameController),
              _buildTextField('Phone number', _phoneController),
              _buildTextField('Email Address', _emailController),
              _buildTextField('Location', _locationController),
            ]),

            // Professional Information
            _buildSection('Professional Information', [
              _buildTextField('Specialization', _specializationController),
              _buildTextField('License Number', _licenseController),
              _buildTextField('Years of Experience', _yearsExpController),
              _buildTextField('ID', _idController),
              _buildAvailabilityDropdown(),
              _buildTextField('About', _aboutController, maxLines: 4),
              _buildTextField('Certifications', TextEditingController()),
              SizedBox(height: 12.h),
              // Add profile picture preview row
              if (_profilePictureFile != null)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      _profilePictureFile!.bytes != null
                          ? Image.memory(
                              _profilePictureFile!.bytes!,
                              width: 48.w,
                              height: 48.w,
                              fit: BoxFit.cover,
                            )
                          : (_profilePictureFile!.path != null
                                ? Image.file(
                                    File(_profilePictureFile!.path!),
                                    width: 48.w,
                                    height: 48.w,
                                    fit: BoxFit.cover,
                                  )
                                : const SizedBox()),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          _profilePictureFile!.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            setState(() => _profilePictureFile = null),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
            ]),

            // Agent Papers Upload
            _buildSection('Agent Papers', [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Attach your agent certificate',
                    style: GoogleFonts.lora(
                      fontSize: 12.sp,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _pickAgentPaper,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D6A5F),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text('Choose Files', style: GoogleFonts.lora()),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          _agentPapersFile?.name ?? 'No file chosen',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ]),

            // Languages
            _buildChipSection(
              'Languages',
              _languages,
              const Color(0xFFE0F2F1),
              primaryColor,
              (index) {
                setState(() {
                  _languages.removeAt(index);
                });
              },
              (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    _languages.add(value);
                  });
                }
              },
            ),

            // Service Areas
            _buildChipSection(
              'Service Areas',
              _serviceAreas,
              const Color(0xFFFFF3E0),
              Colors.orange,
              (index) {
                setState(() {
                  _serviceAreas.removeAt(index);
                });
              },
              (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    _serviceAreas.add(value);
                  });
                }
              },
            ),

            // Property Types
            _buildChipSection(
              'Property Types',
              _propertyTypes,
              Colors.grey[200]!,
              Colors.grey[600]!,
              (index) {
                setState(() {
                  _propertyTypes.removeAt(index);
                });
              },
              (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    _propertyTypes.add(value);
                  });
                }
              },
            ),

            SizedBox(height: 24.h),

            // Bottom Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: BorderSide(color: Colors.grey[400]!),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.lora(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: _isSaving
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
                            'Save Changes',
                            style: GoogleFonts.lora(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
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
          ...children.map((child) {
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: child,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.lora(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 6.h),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: primaryColor, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvailabilityDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Availability',
          style: GoogleFonts.lora(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: DropdownButton<String>(
            value: _selectedAvailability,
            isExpanded: true,
            underline: const SizedBox(),
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            items: _availabilityLabels.entries
                .map(
                  (entry) => DropdownMenuItem(
                    value: entry.key,
                    child: Text(
                      entry.value,
                      style: GoogleFonts.lora(fontSize: 14.sp),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedAvailability = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChipSection(
    String title,
    List<String> items,
    Color bgColor,
    Color buttonColor,
    Function(int) onRemove,
    Function(String) onAdd,
  ) {
    final TextEditingController addController = TextEditingController();

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
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
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: items.asMap().entries.map((entry) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      entry.value,
                      style: GoogleFonts.lora(
                        fontSize: 13.sp,
                        color: primaryText,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    GestureDetector(
                      onTap: () => onRemove(entry.key),
                      child: Icon(
                        Icons.close,
                        size: 16.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: addController,
                  decoration: InputDecoration(
                    hintText:
                        'Add a ${title.toLowerCase().replaceAll('s', '')}',
                    hintStyle: GoogleFonts.lora(
                      fontSize: 13.sp,
                      color: Colors.grey[400],
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    onAdd(addController.text);
                    addController.clear();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
