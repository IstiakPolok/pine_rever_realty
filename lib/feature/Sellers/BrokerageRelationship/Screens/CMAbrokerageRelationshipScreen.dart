import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';

import '../../../../core/const/app_colors.dart';
import 'ViewCMAFinalReportScreen.dart';

class CMABrokerageRelationshipScreen extends StatefulWidget {
  final int? cmaId;
  const CMABrokerageRelationshipScreen({super.key, this.cmaId});

  @override
  State<CMABrokerageRelationshipScreen> createState() =>
      _CMABrokerageRelationshipScreenState();
}

class _CMABrokerageRelationshipScreenState
    extends State<CMABrokerageRelationshipScreen> {
  // Colors
  static const Color _placeholderColor = Color(0xFFEAEAEA);

  // Checkbox state
  bool _isAcknowledged = false;

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
          'Brokerage Relationship Form',
          style: TextStyle(
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
            // 1. Header Text
            Text(
              'Brokerage Relationship Form',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: primaryText,
              ),
            ),
            const SizedBox(height: 24),

            // 2. Sub-header
            Text(
              'Before We Schedule Your Tour',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: primaryText,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Before discussion about CMA',
              style: TextStyle(fontSize: 14, color: primaryText, height: 1.5),
            ),
            const SizedBox(height: 12),

            // 3. Body Description
            Text(
              'Just a quick, required real-estate disclosure before we talk pricing not a contract, just transparency.',
              style: TextStyle(fontSize: 14, color: primaryText, height: 1.5),
            ),
            const SizedBox(height: 32),

            // 4. Document Placeholders
            _buildDocumentPlaceholder(),
            const SizedBox(height: 16),
            _buildDocumentPlaceholder(),
            const SizedBox(height: 32),

            // 5. Checkbox
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    value: _isAcknowledged,
                    activeColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    side: const BorderSide(color: Colors.grey),
                    onChanged: (value) {
                      setState(() {
                        _isAcknowledged = value ?? false;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'I acknowledge that I received this disclosure',
                    style: TextStyle(fontSize: 14, color: primaryText),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // 6. "Okay" Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isAcknowledged
                    ? () {
                        // Navigate to the final CMA report and pass cmaId if available
                        Get.to(
                          () => ViewCMAFinalReportScreen(cmaId: widget.cmaId),
                        );
                      }
                    : null, // Disable button if not acknowledged
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  disabledBackgroundColor: primaryText.withOpacity(0.5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Okay',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentPlaceholder() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: _placeholderColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Container(
          height: 60,
          width: 80,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.image_outlined, color: Colors.grey, size: 30),
        ),
      ),
    );
  }
}
