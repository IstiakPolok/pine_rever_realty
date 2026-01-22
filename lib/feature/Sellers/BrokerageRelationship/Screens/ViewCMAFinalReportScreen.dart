import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:pine_rever_realty/feature/Agent/notification/screens/agent_document_viewer.dart';
import '../../../../core/const/app_colors.dart';
import '../../../../core/network_caller/endpoints.dart';
import '../../../../core/services_class/local_service/shared_preferences_helper.dart';

class ViewCMAFinalReportScreen extends StatefulWidget {
  final int? cmaId;
  const ViewCMAFinalReportScreen({super.key, this.cmaId});

  @override
  State<ViewCMAFinalReportScreen> createState() =>
      _ViewCMAFinalReportScreenState();
}

class _ViewCMAFinalReportScreenState extends State<ViewCMAFinalReportScreen> {
  bool _isLoading = true;
  String _error = '';
  Map<String, dynamic>? _cma;
  bool _isProcessing = false; // for accept/reject actions

  @override
  void initState() {
    super.initState();
    if (widget.cmaId != null) {
      _fetchCMA();
    } else {
      _isLoading = false;
    }
  }

  Future<void> _fetchCMA() async {
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

      final url = '${Urls.baseUrl}/seller/cma/${widget.cmaId}/';
      print('ViewCMA: GET $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('ViewCMA: status=${response.statusCode} body=${response.body}');

      if (response.statusCode == 200) {
        // Ensure a Map<String, dynamic> type by copying from the decoded map
        _cma = Map<String, dynamic>.from(json.decode(response.body) as Map);
      } else {
        setState(() {
          _error = 'Failed to load CMA: ${response.statusCode}';
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

  String? _getPrimaryFileUrl() {
    if (_cma == null) return null;
    if (_cma!['file_url'] != null) return _cma!['file_url'] as String;
    if (_cma!['files'] is List && (_cma!['files'] as List).isNotEmpty) {
      final f = (_cma!['files'] as List).first;
      if (f is Map && f['file_url'] != null) return f['file_url'] as String;
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
          'View CMA Report',
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
    final fileUrl = _getPrimaryFileUrl();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _cma?['title'] ?? 'CMA Report',
            style: GoogleFonts.lora(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: primaryText,
            ),
          ),
          const SizedBox(height: 16),
          if (fileUrl == null)
            _emptyPlaceholder()
          else
            SizedBox(
              height: 400,
              width: double.infinity,
              child: GestureDetector(
                onTap: () {
                  // Open full viewer
                  Get.to(
                    () => AgentDocumentViewer(
                      url: fileUrl,
                      title: _cma?['title'],
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAEAEA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      'Tap to view document',
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 40),
          _buildButton(
            text: 'Ready to Move Forward',
            onPressed: _isProcessing ? null : _acceptCMA,
            backgroundColor: primaryColor,
            textColor: Colors.white,
            loading: _isProcessing,
          ),
          const SizedBox(height: 16),
          _buildButton(
            text: "Let's Discuss More",
            onPressed: () {
              _showDiscussMoreDialog(context);
            },
            backgroundColor: Colors.white,
            textColor: primaryColor,
            borderColor: primaryColor,
          ),
          const SizedBox(height: 16),
          _buildButton(
            text: 'Not Ready Yet',
            onPressed: _isProcessing
                ? null
                : () => _showNotReadyDialog(context),
            backgroundColor: Colors.white,
            textColor: const Color(0xFFB71C1C), // Dark red
            borderColor: const Color(0xFFB71C1C),
            loading: _isProcessing,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _emptyPlaceholder() {
    return Container(
      height: 400,
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
    required VoidCallback? onPressed,
    required Color backgroundColor,
    required Color textColor,
    Color? borderColor,
    bool loading = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: borderColor != null
                ? BorderSide(color: borderColor)
                : BorderSide.none,
          ),
        ),
        child: loading
            ? SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  color: textColor,
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                style: GoogleFonts.lora(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
    );
  }

  void _showDiscussMoreDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Absolutely. Selling a home is a big decision, and it’s important to feel confident before moving forward. I’ll review your questions and reach out so we can talk through everything at a pace that feels comfortable for you.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lora(
                    fontSize: 16,
                    color: primaryText,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Close dialog and navigate to final report (optional)
                      Navigator.of(context).pop();
                      Get.to(
                        () => ViewCMAFinalReportScreen(cmaId: widget.cmaId),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Let's Discuss More",
                      style: GoogleFonts.lora(
                        fontSize: 16,
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

  void _showNotReadyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () async {
                      Navigator.of(context).pop();
                      await _rejectCMA();
                    },
                    child: const Icon(Icons.close, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 16),
                // Placeholder for the image
                Image.asset(
                  'assets/image/NotreadyImage.png',
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 24),
                Text(
                  "No problem at all. You're welcome to return to your CMA anytime, and I'm here if questions come up.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lora(
                    fontSize: 16,
                    color: primaryText,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _acceptCMA() async {
    if (widget.cmaId == null) {
      Get.snackbar('Error', 'CMA id not available');
      return;
    }
    setState(() => _isProcessing = true);

    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        Get.snackbar('Error', 'No access token');
        return;
      }

      final url = '${Urls.baseUrl}/seller/cma/${widget.cmaId}/accept/';
      print('ViewCMA: POST $url');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print(
        'ViewCMA: accept status=${response.statusCode} body=${response.body}',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final jsonBody = json.decode(response.body);
          final message = jsonBody['message'] ?? 'CMA accepted';
          if (jsonBody is Map && jsonBody['id'] != null) {
            setState(() => _cma = Map<String, dynamic>.from(jsonBody));
          } else if (_cma != null) {
            setState(() => _cma!['cma_status'] = 'accepted');
          }
          Get.snackbar('Success', message);
        } catch (e) {
          Get.snackbar('Success', 'CMA accepted');
        }
      } else {
        Get.snackbar('Error', 'Failed to accept CMA: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error accepting CMA: $e');
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _rejectCMA() async {
    if (widget.cmaId == null) {
      Get.snackbar('Error', 'CMA id not available');
      return;
    }
    setState(() => _isProcessing = true);

    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        Get.snackbar('Error', 'No access token');
        return;
      }

      final url = '${Urls.baseUrl}/seller/cma/${widget.cmaId}/reject/';
      print('ViewCMA: POST $url');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print(
        'ViewCMA: reject status=${response.statusCode} body=${response.body}',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final jsonBody = json.decode(response.body);
          final message = jsonBody['message'] ?? 'CMA rejected';
          if (jsonBody is Map && jsonBody['id'] != null) {
            setState(() => _cma = Map<String, dynamic>.from(jsonBody));
          } else if (_cma != null) {
            setState(() => _cma!['cma_status'] = 'rejected');
          }
          Get.snackbar('Success', message);
        } catch (e) {
          Get.snackbar('Success', 'CMA rejected');
        }
      } else {
        Get.snackbar('Error', 'Failed to reject CMA: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error rejecting CMA: $e');
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
            'Are you sure you are not ready to move forward?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                await _rejectCMA();
              },
              child: const Text('Yes, not ready'),
            ),
          ],
        );
      },
    );
  }
}
