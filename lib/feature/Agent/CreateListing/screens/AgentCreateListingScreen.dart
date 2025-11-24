import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pine_rever_realty/core/const/app_colors.dart';
import '../../bottom_nav_bar/screen/Agent_bottom_nav_bar.dart';

class AgentCreateListingScreen extends StatefulWidget {
  const AgentCreateListingScreen({super.key});

  @override
  State<AgentCreateListingScreen> createState() =>
      _AgentCreateListingScreenState();
}

class _AgentCreateListingScreenState extends State<AgentCreateListingScreen> {
  int _currentStep = 0;

  // Form controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String _selectedPropertyType = 'Select type';

  @override
  void dispose() {
    _titleController.dispose();
    _addressController.dispose();
    _zipController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
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
          'Create Listing',
          style: GoogleFonts.lora(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildStepper(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: _buildCurrentStep(),
            ),
          ),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(5, (index) {
          bool isActive = index == _currentStep;
          bool isCompleted = index < _currentStep;

          return Row(
            children: [
              _buildStepCircle(index, isActive, isCompleted),
              if (index < 4)
                Container(
                  width: 40.w,
                  height: 2.h,
                  color: isCompleted ? primaryColor : Colors.grey[300],
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStepCircle(int index, bool isActive, bool isCompleted) {
    return Container(
      width: 32.w,
      height: 32.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted || isActive ? primaryColor : Colors.grey[300],
        border: Border.all(
          color: isActive ? primaryColor : Colors.transparent,
          width: 2,
        ),
      ),
      child: Center(
        child: isCompleted
            ? Icon(Icons.check, color: Colors.white, size: 16.sp)
            : Text(
                '${index + 1}',
                style: GoogleFonts.lora(
                  color: isActive ? Colors.white : Colors.grey[600],
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildStep1PropertyDetails();
      case 1:
        return _buildStep2PropertyPhotos();
      case 2:
        return _buildStep3PropertyDocuments();
      case 3:
        return _buildStep4ReviewPublish();
      default:
        return _buildStep1PropertyDetails();
    }
  }

  Widget _buildStep1PropertyDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Property Title'),
        _buildTextField(_titleController, 'Modern Riverfront Acremain'),
        SizedBox(height: 16.h),

        _buildLabel('Property Address'),
        _buildTextField(_addressController, 'Enter Address'),
        SizedBox(height: 16.h),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('State'),
                  _buildTextField(_stateController, 'Springfield'),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('ZIP Code'),
                  _buildTextField(_zipController, 'Number'),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        _buildLabel('City'),
        _buildTextField(_cityController, 'Springfield'),
        SizedBox(height: 16.h),

        _buildLabel('Property Type'),
        _buildDropdown(),
      ],
    );
  }

  Widget _buildStep2PropertyPhotos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Property Photos'),
        Text(
          'Add top quality photo to make better agent',
          style: GoogleFonts.lora(fontSize: 12.sp, color: Colors.grey[600]),
        ),
        SizedBox(height: 16.h),

        _buildUploadArea('Add Photos'),
        SizedBox(height: 16.h),

        Row(
          children: [
            Expanded(child: _buildSmallUploadArea('Seat Plan')),
            SizedBox(width: 12.w),
            Expanded(child: _buildSmallUploadArea('Elevations')),
            SizedBox(width: 12.w),
            Expanded(child: _buildSmallUploadArea('Stock')),
          ],
        ),
        SizedBox(height: 16.h),

        _buildLabel('Description'),
        _buildTextField(
          _descriptionController,
          'Describe the most properties...',
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildStep3PropertyDocuments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Property Documents'),
        Text(
          'Add property document in every property',
          style: GoogleFonts.lora(fontSize: 12.sp, color: Colors.grey[600]),
        ),
        SizedBox(height: 16.h),

        _buildUploadArea(
          'Upload Documents',
          subtitle: 'Supported Format: PDF JPG, PNG (max10 t/o)',
        ),
        SizedBox(height: 16.h),

        Row(
          children: [
            Expanded(child: _buildSmallUploadArea('')),
            SizedBox(width: 12.w),
            Expanded(child: _buildSmallUploadArea('')),
            SizedBox(width: 12.w),
            Expanded(child: _buildSmallUploadArea('')),
          ],
        ),
      ],
    );
  }

  Widget _buildStep4ReviewPublish() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBF5),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFE4B894)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Review Your Listing',
                style: GoogleFonts.lora(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: primaryText,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Set your property price and details',
                style: GoogleFonts.lora(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),

        _buildLabel('Set Your Price'),
        _buildTextField(_priceController, 'Enter price'),
        SizedBox(height: 16.h),

        _buildLabel('Listing from'),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                TextEditingController(text: '\$50,000'),
                '',
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildTextField(
                TextEditingController(text: '\$100,000'),
                '',
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Beds'),
                  _buildTextField(
                    TextEditingController(text: '2'),
                    'Not selected',
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Baths'),
                  _buildTextField(
                    TextEditingController(text: '1'),
                    'Not selected',
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('sq ft'),
                  _buildTextField(TextEditingController(text: '58'), '58'),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        _buildLabel('Description'),
        Text(
          'Comfortable and private, with a convenient on-site location.',
          style: GoogleFonts.lora(fontSize: 12.sp, color: Colors.grey[700]),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: GoogleFonts.lora(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: primaryText,
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.lora(fontSize: 13.sp, color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: DropdownButton<String>(
        value: _selectedPropertyType,
        isExpanded: true,
        underline: const SizedBox(),
        items: ['Select type', 'House', 'Apartment', 'Condo', 'Villa']
            .map(
              (type) => DropdownMenuItem(
                value: type,
                child: Text(type, style: GoogleFonts.lora(fontSize: 13.sp)),
              ),
            )
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedPropertyType = value!;
          });
        },
      ),
    );
  }

  Widget _buildUploadArea(String label, {String? subtitle}) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.upload_file, color: primaryColor, size: 32.sp),
          ),
          SizedBox(height: 12.h),
          Text(
            label,
            style: GoogleFonts.lora(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: primaryText,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: GoogleFonts.lora(fontSize: 11.sp, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
          SizedBox(height: 12.h),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryText,
              side: BorderSide(color: Colors.grey[400]!),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Choose Files',
              style: GoogleFonts.lora(fontSize: 13.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallUploadArea(String label) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Center(
        child: label.isEmpty
            ? Icon(Icons.add, color: Colors.grey[400], size: 24.sp)
            : Text(
                label,
                style: GoogleFonts.lora(
                  fontSize: 11.sp,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _currentStep--;
                  });
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryText,
                  side: BorderSide(color: Colors.grey[400]!),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Previous',
                  style: GoogleFonts.lora(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          if (_currentStep > 0) SizedBox(width: 16.w),
          Expanded(
            flex: _currentStep == 0 ? 1 : 1,
            child: ElevatedButton(
              onPressed: () {
                if (_currentStep == 2) {
                  // Show success dialog after step 3
                  _showSuccessDialog();
                } else if (_currentStep == 3) {
                  // Final step - create listing
                  _showSuccessDialog(isFinal: true);
                } else {
                  setState(() {
                    _currentStep++;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                elevation: 0,
              ),
              child: Text(
                _currentStep == 3 ? 'Create' : 'Next',
                style: GoogleFonts.lora(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog({bool isFinal = false}) {
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
                  'Uploaded Successfully!',
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
                      if (isFinal) {
                        Get.offAll(() => const AgentBottomNavbar());
                      } else {
                        Navigator.of(context).pop();
                        setState(() {
                          _currentStep++;
                        });
                      }
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
                      isFinal ? 'Return to Home' : 'Continue',
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
