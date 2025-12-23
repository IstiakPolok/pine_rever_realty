import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import '../../../../core/const/app_colors.dart';
import '../../../../core/network_caller/endpoints.dart';
import '../../../../core/services_class/local_service/shared_preferences_helper.dart';
import 'package:get/get.dart';
import '../models/agent_model.dart';

class PropertiesRequestFormScreen extends StatefulWidget {
  const PropertiesRequestFormScreen({super.key});

  @override
  State<PropertiesRequestFormScreen> createState() =>
      _PropertiesRequestFormScreenState();
}

class _PropertiesRequestFormScreenState
    extends State<PropertiesRequestFormScreen> {
  final _sellingReasonController = TextEditingController();
  final _contactNameController = TextEditingController();
  final _contactEmailController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  final _askingPriceController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;
  List<Agent> _agents = [];
  Agent? _selectedAgent;
  bool _isLoadingAgents = false;

  static const Color _inputBg = Color(0xFFE0F2F1);

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? (_startDate ?? DateTime.now()),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  Future<void> _fetchAgents() async {
    setState(() {
      _isLoadingAgents = true;
    });

    try {
      String? token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        Get.snackbar('Error', 'No access token found');
        setState(() {
          _isLoadingAgents = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse(Urls.sellerAgents),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> results = data['results'];
        setState(() {
          _agents = results.map((json) => Agent.fromJson(json)).toList();
        });
      } else {
        Get.snackbar('Error', 'Failed to load agents');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while loading agents: $e');
    } finally {
      setState(() {
        _isLoadingAgents = false;
      });
    }
  }

  Future<void> _submitRequest() async {
    if (_sellingReasonController.text.isEmpty ||
        _contactNameController.text.isEmpty ||
        _contactEmailController.text.isEmpty ||
        _contactPhoneController.text.isEmpty ||
        _askingPriceController.text.isEmpty ||
        _startDate == null ||
        _endDate == null ||
        _selectedAgent == null) {
      Get.snackbar('Error', 'Please fill all fields and select an agent');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String? token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        Get.snackbar('Error', 'No access token found');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final body = {
        "selling_reason": _sellingReasonController.text,
        "contact_name": _contactNameController.text,
        "contact_email": _contactEmailController.text,
        "contact_phone": _contactPhoneController.text,
        "asking_price": _askingPriceController.text,
        "start_date": DateFormat('yyyy-MM-dd').format(_startDate!),
        "end_date": DateFormat('yyyy-MM-dd').format(_endDate!),
        "agent": _selectedAgent!.id,
      };

      final response = await http.post(
        Uri.parse(Urls.sellerSellingpostRequests),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        Get.snackbar('Success', 'Selling request submitted successfully');
        Navigator.of(context).pop();
      } else {
        Get.snackbar('Error', 'Failed to submit request');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAgents();
  }

  @override
  void dispose() {
    _sellingReasonController.dispose();
    _contactNameController.dispose();
    _contactEmailController.dispose();
    _contactPhoneController.dispose();
    _askingPriceController.dispose();
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
          'Selling Request',
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
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Properties Request Form',
              style: GoogleFonts.lora(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: primaryText,
              ),
            ),
            const SizedBox(height: 24),

            // --- Description Section ---
            _buildFormSection(
              children: [
                Text(
                  'Description',
                  style: GoogleFonts.lora(fontSize: 16, color: primaryText),
                ),
                const SizedBox(height: 16),
                _buildLabel('Selling Reason'),
                _buildTextField(
                  controller: _sellingReasonController,
                  hint: 'Describe your reason',
                  maxLines: 3,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // --- Contact Section ---
            _buildFormSection(
              children: [
                Text(
                  'Contact',
                  style: GoogleFonts.lora(fontSize: 16, color: primaryText),
                ),
                const SizedBox(height: 16),
                _buildLabel('Name'),
                _buildTextField(
                  controller: _contactNameController,
                  hint: 'Name here',
                ),
                const SizedBox(height: 12),
                _buildLabel('Email'),
                _buildTextField(
                  controller: _contactEmailController,
                  hint: 'Type email here',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                _buildLabel('Phone Number'),
                _buildTextField(
                  controller: _contactPhoneController,
                  hint: 'Number',
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // --- Agent Selection Section ---
            _buildFormSection(
              children: [
                Text(
                  'Select Agent',
                  style: GoogleFonts.lora(fontSize: 16, color: primaryText),
                ),
                const SizedBox(height: 16),
                _buildLabel('Choose Agent'),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _inputBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _isLoadingAgents
                        ? const Center(child: CircularProgressIndicator())
                        : DropdownButtonFormField<Agent>(
                            value: _selectedAgent,
                            hint: Text(
                              'Select an agent',
                              style: GoogleFonts.poppins(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            items: _agents.map((agent) {
                              return DropdownMenuItem<Agent>(
                                value: agent,
                                child: Container(
                                  constraints: const BoxConstraints(
                                    maxWidth: 200,
                                  ),
                                  child: Text(
                                    agent.displayName,
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (Agent? newValue) {
                              setState(() {
                                _selectedAgent = newValue;
                              });
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey,
                            ),
                            isExpanded: true,
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // --- Price Section ---
            _buildFormSection(
              children: [
                Text(
                  'Set Your Price',
                  style: GoogleFonts.lora(fontSize: 16, color: primaryText),
                ),
                const SizedBox(height: 16),
                _buildLabel('Asking Price'),
                _buildTextField(
                  controller: _askingPriceController,
                  hint: '\$ 450,000',
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // --- Time Frame Section ---
            _buildFormSection(
              children: [
                Text(
                  'Time Frame',
                  style: GoogleFonts.lora(fontSize: 16, color: primaryText),
                ),
                const SizedBox(height: 16),
                _buildLabel('Start Date'),
                GestureDetector(
                  onTap: () => _selectStartDate(context),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _inputBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _startDate != null
                              ? DateFormat('dd MMM, yyyy').format(_startDate!)
                              : 'Select Start Date',
                          style: GoogleFonts.poppins(
                            color: _startDate != null
                                ? Colors.black
                                : Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const Icon(Icons.calendar_today, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildLabel('End Date'),
                GestureDetector(
                  onTap: () => _selectEndDate(context),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _inputBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _endDate != null
                              ? DateFormat('dd MMM, yyyy').format(_endDate!)
                              : 'Select End Date',
                          style: GoogleFonts.poppins(
                            color: _endDate != null
                                ? Colors.black
                                : Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const Icon(Icons.calendar_today, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // --- Submit Button ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Send Request',
                        style: GoogleFonts.lora(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildFormSection({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: GoogleFonts.lora(fontSize: 14, color: primaryText),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(color: primaryText),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 14),
        filled: true,
        fillColor: _inputBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}
