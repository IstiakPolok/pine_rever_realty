import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/const/app_colors.dart';
import '../../home/screens/PropertiesRequestFormScreen.dart';

class AddSellingRequestScreen extends StatelessWidget {
  const AddSellingRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: Text(
          'Add Selling Request',
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Centered Text
            Text(
              'Ready to sell your property? Provide a few details and we’ll connect you with a Pine River Realty agent to get started.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: primaryText,
                height: 1.5, // Line height for readability
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 40),

            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.to(() => PropertiesRequestFormScreen());
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: Text(
                  'Add Selling Request',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
