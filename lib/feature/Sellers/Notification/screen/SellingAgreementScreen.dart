import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/const/app_colors.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../../../core/const/app_colors.dart';
import '../../../../core/network_caller/endpoints.dart';
import '../../../../core/services_class/local_service/shared_preferences_helper.dart';
import '../../../Agent/notification/screens/agent_document_viewer.dart';
import '../controller/notification_controller.dart';

class SellingAgreementScreen extends StatefulWidget {
  final int? agreementId;
  const SellingAgreementScreen({super.key, this.agreementId});

  @override
  State<SellingAgreementScreen> createState() => _SellingAgreementScreenState();
}

class _SellingAgreementScreenState extends State<SellingAgreementScreen> {
  bool _isLoading = true;
  String _error = '';
  Map<String, dynamic>? _agreement;
  bool _isProcessing = false; // for accept/reject actions

  @override
  void initState() {
    super.initState();
    print('SellingAgreementScreen: agreementId=${widget.agreementId}');
    if (widget.agreementId != null) {
      _fetchAgreement();
    } else {
      _isLoading = false;
    }
  }

  Future<void> _fetchAgreement() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        setState(() {
          _error = 'No access token';
          _isLoading = false;
        });
        return;
      }

      final url = '${Urls.baseUrl}/seller/agreements/${widget.agreementId}/';
      print('SellingAgreement: GET $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print(
        'SellingAgreement: status=${response.statusCode} body=${response.body}',
      );

      if (response.statusCode == 200) {
        _agreement = Map<String, dynamic>.from(
          json.decode(response.body) as Map,
        );
      } else {
        setState(() {
          _error = 'Failed to load agreement: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String? _getFileUrl() {
    if (_agreement == null) return null;
    if (_agreement!['selling_agreement_file'] != null) {
      return _agreement!['selling_agreement_file'] as String;
    }
    return null;
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
          'Selling Agreement',
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
          ? Center(child: Text(_error))
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    final url = _getFileUrl();
    final String? agreementStatus = _agreement?['agreement_status']
        ?.toString()
        .toLowerCase();
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _agreement?['title'] ?? 'Selling Agreement',
            style: GoogleFonts.lora(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: primaryText,
            ),
          ),
          const SizedBox(height: 16),
          if (url == null)
            Expanded(child: _placeholder())
          else
            Expanded(
              child: GestureDetector(
                onTap: () => Get.to(
                  () => AgentDocumentViewer(
                    url: url,
                    title: _agreement?['title'],
                  ),
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAEAEA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      'Tap to view agreement',
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                ),
              ),
            ),

          const SizedBox(height: 24),

          // Accept / Reject actions (hidden if already accepted/rejected)
          if (agreementStatus == 'accepted' ||
              agreementStatus == 'rejected') ...[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: agreementStatus == 'accepted'
                    ? const Color(0xFFE8F5E9)
                    : const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: agreementStatus == 'accepted'
                      ? const Color(0xFF2E7D32)
                      : const Color(0xFFD32F2F),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    agreementStatus == 'accepted'
                        ? Icons.check_circle
                        : Icons.cancel,
                    size: 18,
                    color: agreementStatus == 'accepted'
                        ? const Color(0xFF2E7D32)
                        : const Color(0xFFD32F2F),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    agreementStatus == 'accepted'
                        ? 'Agreement accepted'
                        : 'Agreement declined',
                    style: GoogleFonts.lora(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isProcessing || widget.agreementId == null
                        ? null
                        : _acceptAgreement,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: _isProcessing
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text('Accept', style: GoogleFonts.lora(fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isProcessing || widget.agreementId == null
                        ? null
                        : _confirmReject,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFD32F2F),
                      side: const BorderSide(color: Color(0xFFD32F2F)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Decline',
                      style: GoogleFonts.lora(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFEAEAEA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.image_outlined, color: Colors.grey, size: 40),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    required Color textColor,
    required Color borderColor,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor,
          side: BorderSide(color: borderColor),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.lora(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Future<void> _acceptAgreement() async {
    if (widget.agreementId == null) {
      Get.snackbar('Error', 'Agreement id not available');
      return;
    }

    setState(() => _isProcessing = true);
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        Get.snackbar('Error', 'No access token');
        return;
      }
      final url =
          '${Urls.baseUrl}/seller/agreements/${widget.agreementId}/accept/';
      print('SellingAgreement: POST $url');
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      print(
        'SellingAgreement: accept status=${response.statusCode} body=${response.body}',
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final jsonBody = json.decode(response.body);
          final message = jsonBody['message'] ?? 'Agreement accepted';
          if (jsonBody is Map && jsonBody['id'] != null) {
            setState(
              () => _agreement = Map<String, dynamic>.from(jsonBody),
            );
          } else if (_agreement != null) {
            setState(() => _agreement!['agreement_status'] = 'accepted');
          }
          Get.snackbar('Success', message);

          // Refresh notifications if controller is available, then close screen
          try {
            if (Get.isRegistered<NotificationController>()) {
              await Get.find<NotificationController>().fetchNotifications();
            }
          } catch (e) {
            print('Error refreshing notifications: $e');
          }
          Get.back();
        } catch (e) {
          Get.snackbar('Success', 'Agreement accepted');
          try {
            if (Get.isRegistered<NotificationController>()) {
              await Get.find<NotificationController>().fetchNotifications();
            }
          } catch (e) {
            print('Error refreshing notifications: $e');
          }
          Get.back();
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to accept agreement: ${response.statusCode}',
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Error accepting agreement: $e');
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _rejectAgreement() async {
    if (widget.agreementId == null) {
      Get.snackbar('Error', 'Agreement id not available');
      return;
    }

    setState(() => _isProcessing = true);
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        Get.snackbar('Error', 'No access token');
        return;
      }
      final url =
          '${Urls.baseUrl}/seller/agreements/${widget.agreementId}/reject/';
      print('SellingAgreement: POST $url');
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      print(
        'SellingAgreement: reject status=${response.statusCode} body=${response.body}',
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final jsonBody = json.decode(response.body);
          final message = jsonBody['message'] ?? 'Agreement rejected';
          if (jsonBody is Map && jsonBody['id'] != null) {
            setState(
              () => _agreement = Map<String, dynamic>.from(jsonBody),
            );
          } else if (_agreement != null) {
            setState(() => _agreement!['agreement_status'] = 'rejected');
          }
          Get.snackbar('Success', message);

          // Refresh notifications if controller is available, then close screen
          try {
            if (Get.isRegistered<NotificationController>()) {
              await Get.find<NotificationController>().fetchNotifications();
            }
          } catch (e) {
            print('Error refreshing notifications: $e');
          }
          Get.back();
        } catch (e) {
          Get.snackbar('Success', 'Agreement rejected');
          try {
            if (Get.isRegistered<NotificationController>()) {
              await Get.find<NotificationController>().fetchNotifications();
            }
          } catch (e) {
            print('Error refreshing notifications: $e');
          }
          Get.back();
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to reject agreement: ${response.statusCode}',
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Error rejecting agreement: $e');
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  void _confirmReject() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const Text(
            'Are you sure you want to decline the agreement?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                await _rejectAgreement();
              },
              child: const Text('Yes, decline'),
            ),
          ],
        );
      },
    );
  }
}
