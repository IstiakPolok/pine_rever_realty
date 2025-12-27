import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pine_rever_realty/core/const/app_colors.dart';
import 'package:pine_rever_realty/feature/Agent/CreateListing/controller/agent_create_listing_controller.dart';

class AgentCreateListingScreen extends StatefulWidget {
  const AgentCreateListingScreen({super.key});

  @override
  State<AgentCreateListingScreen> createState() =>
      _AgentCreateListingScreenState();
}

class _AgentCreateListingScreenState extends State<AgentCreateListingScreen> {
  final AgentCreateListingController _controller = Get.put(
    AgentCreateListingController(),
  );
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor.withOpacity(0.09),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Icon(Icons.arrow_back, size: 24.sp),
                      ),
                      SizedBox(width: 12.w),
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
                    ],
                  ),
                ],
              ),
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
        // Added Agreement ID as requested
        _buildLabel('Agreement ID'),
        _buildTextField(
          _controller.agreementIdController,
          'Enter Agreement ID',
        ),
        SizedBox(height: 16.h),

        _buildLabel('Property Title'),
        _buildTextField(
          _controller.titleController,
          'Modern Downtown Apartment',
        ),
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
              _buildTextField(_controller.addressController, '123 Main Street'),
              SizedBox(height: 16.h),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('City'),
                        _buildTextField(
                          _controller.cityController,
                          'Springfield',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('State'),
                        _buildTextField(_controller.stateController, 'IL'),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              _buildLabel('ZIP Code'),
              _buildTextField(_controller.zipController, '62701'),
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
                        Obx(
                          () => _buildSelectionDropdown(
                            value: _controller.selectedBedrooms.value,
                            items: ['Select', '1', '2', '3', '4', '5+'],
                            onChanged: (value) {
                              _controller.selectedBedrooms.value = value!;
                            },
                          ),
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
                        Obx(
                          () => _buildSelectionDropdown(
                            value: _controller.selectedBathrooms.value,
                            items: ['Select', '1', '2', '3', '4', '5+'],
                            onChanged: (value) {
                              _controller.selectedBathrooms.value = value!;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              _buildLabel('Square Feet'),
              _buildTextField(_controller.squareFeetController, '2,000'),
              SizedBox(height: 16.h),

              _buildLabel('Description'),
              _buildTextField(
                _controller.descriptionController,
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
              SizedBox(height: 16.h),

              _buildUploadArea(
                'Upload Photos',
                subtitle: 'Supported formats: JPG, PNG (max 10 MB)',
                icon: Icons.image_outlined,
                isImage: true,
              ),
              SizedBox(height: 10.h),
              // Display picked photos count or list
              Obx(
                () => _controller.pickedPhotos.isNotEmpty
                    ? Wrap(
                        spacing: 8,
                        children: _controller.pickedPhotos
                            .map(
                              (e) => Chip(
                                label: Text(
                                  e.name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onDeleted: () =>
                                    _controller.removeFile(e, isImage: true),
                              ),
                            )
                            .toList(),
                      )
                    : SizedBox(),
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
              SizedBox(height: 16.h),

              _buildUploadArea(
                'Upload Documents',
                subtitle: 'Supported formats: PDF, JPG, PNG (max 10 MB)',
                icon: Icons.attach_file,
                isImage: false,
              ),
              SizedBox(height: 10.h),
              // Display picked photos count or list
              Obx(
                () => _controller.pickedDocuments.isNotEmpty
                    ? Wrap(
                        spacing: 8,
                        children: _controller.pickedDocuments
                            .map(
                              (e) => Chip(
                                label: Text(
                                  e.name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onDeleted: () =>
                                    _controller.removeFile(e, isImage: false),
                              ),
                            )
                            .toList(),
                      )
                    : SizedBox(),
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
              _buildPriceTextField(_controller.priceController, '\$ 450,000'),
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
          _controller.addressController.text.isEmpty
              ? 'Not provided,'
              : _controller.addressController.text,
        ),
        SizedBox(height: 16.h),

        // Agreement ID
        _buildReviewLabel('Agreement ID'),
        _buildReviewValue(
          _controller.agreementIdController.text.isEmpty
              ? 'Not provided'
              : _controller.agreementIdController.text,
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
                  Obx(
                    () => _buildReviewValue(
                      _controller.selectedPropertyType.value == 'Select type'
                          ? 'Not selected'
                          : _controller.selectedPropertyType.value,
                    ),
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
                    _controller.priceController.text.isEmpty
                        ? '\$0'
                        : _controller.priceController.text,
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
                  Obx(
                    () => _buildReviewValue(
                      _controller.selectedBedrooms.value == 'Select'
                          ? '0'
                          : _controller.selectedBedrooms.value,
                    ),
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
                  Obx(
                    () => _buildReviewValue(
                      _controller.selectedBathrooms.value == 'Select'
                          ? '0'
                          : _controller.selectedBathrooms.value,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildReviewLabel('Sq Ft'),
                  _buildReviewValue(
                    _controller.squareFeetController.text.isEmpty
                        ? '0'
                        : _controller.squareFeetController.text,
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
          _controller.descriptionController.text.isEmpty
              ? 'No description provided'
              : _controller.descriptionController.text,
        ),
        SizedBox(height: 24.h),

        // Ready to Publish Card
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: InkWell(
            onTap: () {
              _controller.submitListing();
            },
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Obx(
                    () => _controller.isLoading.value
                        ? SizedBox(
                            width: 28.sp,
                            height: 28.sp,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Icon(Icons.check, color: Colors.white, size: 28.sp),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Publish Listing',
                        style: GoogleFonts.lora(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Click here to publish your listing',
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
      child: Obx(
        () => DropdownButton<String>(
          value: _controller.selectedPropertyType.value,
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
            _controller.selectedPropertyType.value = value!;
          },
        ),
      ),
    );
  }

  Widget _buildSelectionDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
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

  Widget _buildUploadArea(
    String title, {
    required String subtitle,
    required IconData icon,
    required bool isImage,
  }) {
    return GestureDetector(
      onTap: () {
        _controller.pickFiles(isImage: isImage);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 24.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey[300]!, style: BorderStyle.none),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40.sp, color: Colors.grey[400]),
            SizedBox(height: 12.h),
            Text(
              title,
              style: GoogleFonts.lora(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: GoogleFonts.lora(fontSize: 12.sp, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: EdgeInsets.only(top: 24.h),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _currentStep--;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: primaryColor),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: Text(
                      'Previous',
                      style: GoogleFonts.lora(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (_currentStep > 0) SizedBox(width: 16.w),
          if (_currentStep < 4)
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _currentStep++;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: Text(
                      'Next Step',
                      style: GoogleFonts.lora(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
