import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'agent_document_viewer.dart';

import '../../../../core/const/app_colors.dart';
import '../../../../core/network_caller/endpoints.dart';
import '../../../../core/services_class/local_service/shared_preferences_helper.dart';
import '../../CMA/screens/AgentCMAScreen.dart';

class AgentDocumentsScreen extends StatefulWidget {
  final int sellingRequestId;
  const AgentDocumentsScreen({super.key, required this.sellingRequestId});

  @override
  State<AgentDocumentsScreen> createState() => _AgentDocumentsScreenState();
}

class _AgentDocumentsScreenState extends State<AgentDocumentsScreen> {
  bool _isLoading = true;
  String _error = '';
  List<DocumentFile> _files = [];

  @override
  void initState() {
    super.initState();
    _fetchDocuments();
  }

  Future<void> _fetchDocuments() async {
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

      final url =
          '${Urls.baseUrl}/agent/selling-requests/${widget.sellingRequestId}/documents/';
      print('AgentDocuments: GET $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print(
        'AgentDocuments: status=${response.statusCode} body=${response.body}',
      );

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);

        // API may return documents in different shapes. Handle both:
        // 1. { "results": [...] }
        // 2. { "documents": [ { ..., "files": [...] }, ... ] }
        // 3. Direct file list
        List<dynamic> docs = [];
        if (jsonBody is List) {
          docs = jsonBody;
        } else if (jsonBody['results'] is List) {
          docs = jsonBody['results'] as List<dynamic>;
        } else if (jsonBody['documents'] is List) {
          docs = jsonBody['documents'] as List<dynamic>;
        }

        List<DocumentFile> files = [];

        for (var item in docs) {
          if (item is Map<String, dynamic>) {
            // If this object contains a 'files' array, flatten it
            if (item['files'] is List) {
              for (var f in (item['files'] as List<dynamic>)) {
                if (f is Map<String, dynamic>) {
                  files.add(DocumentFile.fromJson(f));
                }
              }
            } else if (item['file'] != null || item['file_url'] != null) {
              // This item looks like a file object
              files.add(DocumentFile.fromJson(item));
            }
          }
        }

        _files = files;
        print('AgentDocuments: parsed ${_files.length} files from response');
      } else {
        _error = 'Failed to load documents: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Error: $e';
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Documents', style: GoogleFonts.lora())),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
          ? Center(child: Text(_error))
          : _files.isEmpty
          ? Center(child: Text('No documents found'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _files.length + 1, // extra for action button
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ElevatedButton.icon(
                    onPressed: () async {
                      // Navigate to CMA upload for this selling request and await result
                      final result = await Get.to(
                        () => AgentCMAScreen(
                          sellingRequestId: widget.sellingRequestId,
                        ),
                      );

                      if (result != null) {
                        // Debug: print the full returned result
                        try {
                          print(
                            'AgentDocuments: CMA upload result: ${jsonEncode(result)}',
                          );
                        } catch (e) {
                          print(
                            'AgentDocuments: failed to jsonEncode result: $e',
                          );
                        }

                        // Show a debug dialog with the server response
                        showDialog(
                          context: context,
                          builder: (_) {
                            final bodyText = result is String
                                ? result
                                : jsonEncode(result);
                            return AlertDialog(
                              title: const Text('CMA Upload Response'),
                              content: SingleChildScrollView(
                                child: Text(bodyText),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Close'),
                                ),
                              ],
                            );
                          },
                        );

                        // Refresh list and show user-friendly snackbar
                        await _fetchDocuments();
                        final message =
                            (result is Map && result['message'] != null)
                            ? result['message']
                            : 'CMA uploaded successfully';
                        Get.snackbar('Success', message);
                      }
                    },
                    icon: const Icon(Icons.upload_file, color: Colors.white),
                    label: const Text(
                      'Upload CMA',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                  );
                }

                final file = _files[index - 1];
                return ListTile(
                  leading: const Icon(Icons.insert_drive_file),
                  title: Text(
                    file.originalFilename ?? file.fileUrl ?? 'Document',
                  ),
                  subtitle: Text(
                    '${file.fileExtension ?? ''} • ${file.fileSizeMb ?? ''} MB',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_red_eye_outlined),
                        onPressed: file.fileUrl != null
                            ? () => Get.to(
                                () => AgentDocumentViewer(
                                  url: file.fileUrl!,
                                  title: file.originalFilename,
                                ),
                              )
                            : null,
                      ),
                      // IconButton(
                      //   icon: const Icon(Icons.open_in_new),
                      //   onPressed: file.fileUrl != null
                      //       ? () => _openUrl(file.fileUrl!)
                      //       : null,
                      // ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await canLaunchUrl(uri)) {
      Get.snackbar('Error', 'Cannot open URL');
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class DocumentFile {
  final int? id;
  final String? fileUrl;
  final String? originalFilename;
  final String? fileExtension;
  final double? fileSizeMb;

  DocumentFile({
    this.id,
    this.fileUrl,
    this.originalFilename,
    this.fileExtension,
    this.fileSizeMb,
  });

  factory DocumentFile.fromJson(Map<String, dynamic> json) {
    return DocumentFile(
      id: json['id'],
      fileUrl: json['file_url'] ?? json['file'],
      originalFilename: json['original_filename'],
      fileExtension: json['file_extension'],
      fileSizeMb: (json['file_size_mb'] is num)
          ? (json['file_size_mb'] as num).toDouble()
          : null,
    );
  }
}
