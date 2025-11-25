import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pine_rever_realty/core/const/app_colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController(
    text: 'Sarah Johnson',
  );
  final TextEditingController _phoneController = TextEditingController(
    text: '(555) 123-4567',
  );
  final TextEditingController _emailController = TextEditingController(
    text: 'sarah.johnson@realestate.com',
  );
  final TextEditingController _locationController = TextEditingController(
    text: 'Springfield, IL',
  );
  final TextEditingController _specializationController = TextEditingController(
    text: 'Residential',
  );
  final TextEditingController _licenseController = TextEditingController(
    text: 'IL-RE-42345',
  );
  final TextEditingController _yearsExpController = TextEditingController(
    text: '10',
  );
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController(
    text:
        'Experienced real estate agent specializing in residential properties with over 10 years in the Springfield market. Dedicated to helping families find their perfect home.',
  );

  String _selectedAvailability = 'Full-time';
  final List<String> _languages = ['English'];
  final List<String> _serviceAreas = ['Downtown', 'Suburban Areas'];
  final List<String> _propertyTypes = ['Single Family', 'Condos'];

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
                              onPressed: () {},
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
                    onPressed: () {
                      // Save changes
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
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
            items: ['Full-time', 'Part-time', 'Project-Based']
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(item, style: GoogleFonts.lora(fontSize: 14.sp)),
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
