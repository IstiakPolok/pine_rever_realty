import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:photo_view/photo_view.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class AgentDocumentViewer extends StatefulWidget {
  final String url;
  final String? title;
  const AgentDocumentViewer({super.key, required this.url, this.title});

  @override
  State<AgentDocumentViewer> createState() => _AgentDocumentViewerState();
}

class _AgentDocumentViewerState extends State<AgentDocumentViewer> {
  bool _loading = true;
  String? _error;
  Uint8List? _bytes;
  PdfControllerPinch? _pdfController;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final uri = Uri.parse(widget.url);
      final resp = await http.get(uri);
      if (resp.statusCode != 200) {
        setState(
          () => _error = 'Failed to download document (${resp.statusCode})',
        );
        return;
      }

      _bytes = resp.bodyBytes;

      // if pdf, prepare controller
      if (_isPdf(widget.url)) {
        // pdfx PdfControllerPinch expects a Future<PdfDocument>
        _pdfController = PdfControllerPinch(
          document: PdfDocument.openData(_bytes!),
        );
      }
    } catch (e) {
      setState(() => _error = 'Error: $e');
      return;
    } finally {
      setState(() => _loading = false);
    }
  }

  bool _isPdf(String url) => url.toLowerCase().endsWith('.pdf');
  bool _isImage(String url) {
    final u = url.toLowerCase();
    return u.endsWith('.jpg') ||
        u.endsWith('.jpeg') ||
        u.endsWith('.png') ||
        u.endsWith('.gif');
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Document', style: GoogleFonts.lora()),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!))
          : _isPdf(widget.url)
          ? PdfViewPinch(controller: _pdfController!)
          : _isImage(widget.url)
          ? PhotoView.customChild(
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 3,
              child: Image.memory(_bytes!),
            )
          : Center(child: Text('Unsupported file format')),
    );
  }
}
