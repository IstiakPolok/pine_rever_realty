import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:pine_rever_realty/core/network_caller/endpoints.dart';
import 'package:pine_rever_realty/core/services_class/local_service/shared_preferences_helper.dart';

class AgentCreateListingController extends GetxController {
  // Form Controllers
  final titleController = TextEditingController();
  final addressController = TextEditingController();
  final zipController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final squareFeetController = TextEditingController();
  final agreementIdController =
      TextEditingController(); // Added for agreement_id

  // Dropdown Values
  var selectedPropertyType = 'Select type'.obs;
  var selectedBedrooms = 'Select'.obs;
  var selectedBathrooms = 'Select'.obs;

  // Files
  var pickedPhotos = <PlatformFile>[].obs;
  var pickedDocuments = <PlatformFile>[].obs;
  var isLoading = false.obs;

  Future<void> pickFiles({required bool isImage}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: isImage ? FileType.image : FileType.custom,
        allowedExtensions: isImage ? null : ['pdf', 'jpg', 'png'],
      );

      if (result != null) {
        if (isImage) {
          pickedPhotos.addAll(result.files);
        } else {
          pickedDocuments.addAll(result.files);
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick files: $e');
    }
  }

  void removeFile(PlatformFile file, {required bool isImage}) {
    if (isImage) {
      pickedPhotos.remove(file);
    } else {
      pickedDocuments.remove(file);
    }
  }

  Future<void> submitListing() async {
    if (agreementIdController.text.isEmpty) {
      Get.snackbar('Error', 'Agreement ID is required');
      return;
    }

    isLoading.value = true;
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        Get.snackbar('Error', 'Authentication token not found');
        return;
      }

      final url = Urls.getCreateListingUrl(agreementIdController.text.trim());
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Headers
      request.headers['Authorization'] = 'Bearer $token';

      // Fields
      request.fields['title'] = titleController.text;
      request.fields['street_address'] = addressController.text;
      request.fields['city'] = cityController.text;
      request.fields['state'] = stateController.text;
      request.fields['zip_code'] = zipController.text;
      // Pass property_type in lower-case to API (House -> house, Apartment -> apartment, etc.)
      final propertyType = selectedPropertyType.value == 'Select type'
          ? ''
          : selectedPropertyType.value.trim().toLowerCase();
      request.fields['property_type'] = propertyType;
      request.fields['bedrooms'] = selectedBedrooms.value == 'Select'
          ? '0'
          : selectedBedrooms.value;
      request.fields['bathrooms'] = selectedBathrooms.value == 'Select'
          ? '0'
          : selectedBathrooms.value;
      request.fields['price'] = priceController.text
          .replaceAll(',', '')
          .replaceAll('\$', '')
          .trim();
      request.fields['square_feet'] = squareFeetController.text
          .replaceAll(',', '')
          .trim();
      request.fields['description'] = descriptionController.text;

      // Add Photos
      for (var file in pickedPhotos) {
        if (file.path != null) {
          final mimeType = lookupMimeType(file.path!);
          request.files.add(
            await http.MultipartFile.fromPath(
              'photos',
              file.path!,
              contentType: mimeType != null ? MediaType.parse(mimeType) : null,
            ),
          );
        }
      }

      // Add Documents
      for (var file in pickedDocuments) {
        if (file.path != null) {
          final mimeType = lookupMimeType(file.path!);
          request.files.add(
            await http.MultipartFile.fromPath(
              'documents',
              file.path!,
              contentType: mimeType != null ? MediaType.parse(mimeType) : null,
            ),
          );
        }
      }

      print('Submitting to $url');
      print('Fields: ${request.fields}');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Property listing created successfully');
        // Clear form or navigate
        _clearForm();
      } else {
        Get.snackbar('Error', 'Failed to create listing: ${response.body}');
      }
    } catch (e) {
      print('Error submitting listing: $e');
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _clearForm() {
    titleController.clear();
    addressController.clear();
    zipController.clear();
    stateController.clear();
    cityController.clear();
    descriptionController.clear();
    priceController.clear();
    squareFeetController.clear();
    agreementIdController.clear(); // Keep this? Or maybe user wants to reuse?
    selectedPropertyType.value = 'Select type';
    selectedBedrooms.value = 'Select';
    selectedBathrooms.value = 'Select';
    pickedPhotos.clear();
    pickedDocuments.clear();
  }

  @override
  void onClose() {
    titleController.dispose();
    addressController.dispose();
    zipController.dispose();
    stateController.dispose();
    cityController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    squareFeetController.dispose();
    agreementIdController.dispose();
    super.onClose();
  }
}
