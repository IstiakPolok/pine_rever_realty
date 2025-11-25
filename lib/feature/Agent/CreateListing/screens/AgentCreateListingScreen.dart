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
  final TextEditingController _squareFeetController = TextEditingController();
  String _selectedPropertyType = 'Select type';
  String _selectedBedrooms = 'Select';
  String _selectedBathrooms = 'Select';

  @override
  void dispose() {
    _titleController.dispose();
    _addressController.dispose();
    _zipController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _squareFeetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor.withOpacity(0.09),

      body: SafeArea(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  'Create Listing',
                  style: GoogleFonts.lora(
                    color: Colors.black,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Step ${_currentStep + 1} of 5',
                  style: GoogleFonts.lora(
                    color: Colors.grey[600],
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            _buildStepper(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  children: [_buildCurrentStep(), _buildNavigationButtons()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepper() {
    final steps = [
      {'icon': Icons.home, 'label': 'Basic Info'},
      {'icon': Icons.location_on_outlined, 'label': 'Details'},
      {'icon': Icons.photo_outlined, 'label': 'Photos'},
      {'icon': Icons.attach_money, 'label': 'Pricing'},
      {'icon': Icons.check_circle_outline, 'label': 'Review'},
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: List.generate(9, (index) {
          // Odd indices are icons, even indices are lines
          if (index.isEven) {
            int stepIndex = index ~/ 2;
            bool isActive = stepIndex == _currentStep;
            bool isCompleted = stepIndex < _currentStep;
            final step = steps[stepIndex];

            return Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                          ? primaryColor
                          : (isCompleted
                                ? primaryColor.withOpacity(0.1)
                                : Colors.grey[100]),
                      border: Border.all(
                        color: isActive || isCompleted
                            ? primaryColor
                            : Colors.grey[300]!,
                        width: isActive ? 2 : 1,
                      ),
                    ),
                    child: Icon(
                      step['icon'] as IconData,
                      color: isActive
                          ? Colors.white
                          : (isCompleted ? primaryColor : Colors.grey[900]),
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    step['label'] as String,
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                    style: GoogleFonts.lora(
                      fontSize: 10.sp,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      color: isActive ? primaryColor : Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else {
            // This is a line between icons
            int stepIndex = index ~/ 2;
            bool lineCompleted = stepIndex < _currentStep;

            return Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(bottom: 24.h),
                child: Container(
                  height: 2.h,
                  color: lineCompleted ? primaryColor : Colors.grey[300],
                ),
              ),
            );
          }
        }),
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
      case 4:
        return _buildStep5Review();
      default:
        return _buildStep1PropertyDetails();
    }
  }

  Widget _buildStep1PropertyDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Property Title'),
        _buildTextField(_titleController, 'Modern Downtown Apartment'),
        SizedBox(height: 20.h),

        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: primaryColor.withOpacity(0.3),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Property Address',
                style: GoogleFonts.lora(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: primaryText,
                ),
              ),
              SizedBox(height: 16.h),

              _buildLabel('Street Address'),
              _buildTextField(_addressController, '123 Main Street'),
              SizedBox(height: 16.h),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('City'),
                        _buildTextField(_cityController, 'Springfield'),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('State'),
                        _buildTextField(_stateController, 'IL'),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              _buildLabel('ZIP Code'),
              _buildTextField(_zipController, '62701'),
              SizedBox(height: 16.h),

              _buildLabel('Property Type'),
              _buildDropdown(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep2PropertyPhotos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: primaryColor.withOpacity(0.3),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Property Details',
                style: GoogleFonts.lora(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: primaryText,
                ),
              ),
              SizedBox(height: 20.h),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Bedrooms'),
                        _buildSelectionDropdown(
                          value: _selectedBedrooms,
                          items: ['Select', '1', '2', '3', '4', '5+'],
                          onChanged: (value) {
                            setState(() {
                              _selectedBedrooms = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Bathrooms'),
                        _buildSelectionDropdown(
                          value: _selectedBathrooms,
                          items: ['Select', '1', '2', '3', '4', '5+'],
                          onChanged: (value) {
                            setState(() {
                              _selectedBathrooms = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              _buildLabel('Square Feet'),
              _buildTextField(_squareFeetController, '2,000'),
              SizedBox(height: 16.h),

              _buildLabel('Description'),
              _buildTextField(
                _descriptionController,
                'Describe your property...',
                maxLines: 4,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep3PropertyDocuments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Property Photos Section
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: primaryColor.withOpacity(0.3),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Property Photos',
                style: GoogleFonts.lora(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: primaryText,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Add high-quality photos to attract more buyers',
                style: GoogleFonts.lora(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 16.h),

              _buildUploadArea(
                'Upload Photos',
                subtitle: 'Supported formats: JPG, PNG (max 10 MB)',
                icon: Icons.image_outlined,
              ),
              SizedBox(height: 16.h),

              Row(
                children: [
                  Expanded(child: _buildSmallUploadArea(Icons.image_outlined)),
                  SizedBox(width: 12.w),
                  Expanded(child: _buildSmallUploadArea(Icons.image_outlined)),
                  SizedBox(width: 12.w),
                  Expanded(child: _buildSmallUploadArea(Icons.image_outlined)),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),

        // Property Documents Section
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: primaryColor.withOpacity(0.3),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Property Documents',
                style: GoogleFonts.lora(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: primaryText,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Add property document to verify property',
                style: GoogleFonts.lora(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 16.h),

              _buildUploadArea(
                'Upload Documents',
                subtitle: 'Supported formats: PDF, JPG, PNG (max 10 MB)',
                icon: Icons.attach_file,
              ),
              SizedBox(height: 16.h),

              Row(
                children: [
                  Expanded(
                    child: _buildSmallUploadArea(Icons.description_outlined),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildSmallUploadArea(Icons.description_outlined),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildSmallUploadArea(Icons.description_outlined),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep4ReviewPublish() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: primaryColor.withOpacity(0.3),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Set Your Price',
                style: GoogleFonts.lora(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: primaryText,
                ),
              ),
              SizedBox(height: 20.h),

              _buildLabel('Listing Price'),
              _buildPriceTextField(_priceController, '\$ 450,000'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep5Review() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Review Your Listing',
          style: GoogleFonts.lora(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: primaryText,
          ),
        ),
        SizedBox(height: 24.h),

        // Address
        _buildReviewLabel('Address'),
        _buildReviewValue(
          _addressController.text.isEmpty
              ? 'Not provided,'
              : _addressController.text,
        ),
        SizedBox(height: 16.h),

        // Property Type and Price
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildReviewLabel('Property Type'),
                  _buildReviewValue(
                    _selectedPropertyType == 'Select type'
                        ? 'Not selected'
                        : _selectedPropertyType,
                  ),
                ],
              ),
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildReviewLabel('Price'),
                  _buildReviewValue(
                    _priceController.text.isEmpty
                        ? '\$0'
                        : _priceController.text,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // Beds, Baths, Sq Ft
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildReviewLabel('Beds'),
                  _buildReviewValue(
                    _selectedBedrooms == 'Select' ? '0' : _selectedBedrooms,
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildReviewLabel('Baths'),
                  _buildReviewValue(
                    _selectedBathrooms == 'Select' ? '0' : _selectedBathrooms,
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildReviewLabel('Sq Ft'),
                  _buildReviewValue(
                    _squareFeetController.text.isEmpty
                        ? '0'
                        : _squareFeetController.text,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // Description
        _buildReviewLabel('Description'),
        _buildReviewValue(
          _descriptionController.text.isEmpty
              ? 'No description provided'
              : _descriptionController.text,
        ),
        SizedBox(height: 24.h),

        // Ready to Publish Card
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(Icons.check, color: Colors.white, size: 28.sp),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ready to Publish?',
                      style: GoogleFonts.lora(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Your listing will be visible to thousands of potential buyers',
                      style: GoogleFonts.lora(
                        fontSize: 13.sp,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Text(
        text,
        style: GoogleFonts.lora(
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildReviewValue(String text) {
    return Text(
      text,
      style: GoogleFonts.lora(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: primaryText,
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
          fontWeight: FontWeight.w500,
          color: primaryText,
        ),
      ),
    );
  }

  Widget _buildPriceTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.lora(fontSize: 15.sp, color: Colors.grey[500]),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
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
        hintStyle: GoogleFonts.lora(fontSize: 13.sp, color: Colors.grey[500]),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
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
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: DropdownButton<String>(
        value: _selectedPropertyType,
        isExpanded: true,
        underline: const SizedBox(),
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        items: ['Select type', 'House', 'Apartment', 'Condo', 'Villa']
            .map(
              (type) => DropdownMenuItem(
                value: type,
                child: Text(
                  type,
                  style: GoogleFonts.lora(
                    fontSize: 13.sp,
                    color: type == 'Select type'
                        ? Colors.grey[500]
                        : Colors.black,
                  ),
                ),
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

  Widget _buildSelectionDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        items: items
            .map(
              (item) => DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: GoogleFonts.lora(
                    fontSize: 13.sp,
                    color: item == 'Select' ? Colors.grey[500] : Colors.black,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildUploadArea(String label, {String? subtitle, IconData? icon}) {
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
            child: Icon(
              icon ?? Icons.upload_file,
              color: primaryColor,
              size: 32.sp,
            ),
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
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Choose Files',
              style: GoogleFonts.lora(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallUploadArea(IconData icon) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Center(
        child: Icon(icon, color: Colors.grey[400], size: 24.sp),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
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
                } else if (_currentStep == 4) {
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
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _currentStep == 4 ? 'Create' : 'Next',
                    style: GoogleFonts.lora(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (_currentStep < 4) SizedBox(width: 8.w),
                  if (_currentStep < 4) Icon(Icons.arrow_forward, size: 18.sp),
                ],
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
