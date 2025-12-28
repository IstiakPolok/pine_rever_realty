import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/const/app_colors.dart';
import '../../PropertyDetailsScreen /screens/PropertyDetailsScreen.dart';

class SavedPropertiesScreen extends StatelessWidget {
  const SavedPropertiesScreen({super.key});

  static const Color _redIcon = Color(0xFFE53935);

  // Mock Data matching the image
  static final List<Map<String, dynamic>> _savedProperties = [
    {
      "id": 1,
      "agent_id": 1,
      "price": "\$450,000",
      "address": "123 Maple Street, Springfield, IL",
      "beds": 3,
      "baths": 2,
      "sqft": "1,850",
      "savedTime": "Saved 2 days ago",
      "image":
          "https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?fit=crop&w=800&q=80", // Modern exterior
    },
    {
      "id": 2,
      "agent_id": 1,
      "price": "\$380,000",
      "address": "456 Oak Avenue, Springfield, IL",
      "beds": 4,
      "baths": 2.5,
      "sqft": "2,100",
      "savedTime": "Saved 1 week ago",
      "image":
          "https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?fit=crop&w=800&q=80", // Modern exterior
    },
    {
      "id": 3,
      "agent_id": 1,
      "price": "\$525,000",
      "address": "789 Pine Road, Springfield, IL",
      "beds": 4,
      "baths": 3,
      "sqft": "2,400",
      "savedTime": "Saved 2 weeks ago",
      "image":
          "https://images.unsplash.com/photo-1600210492493-0946911123ea?fit=crop&w=800&q=80", // Modern Interior
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading:
            false, // Hide default back button to match image style if needed, or keep it

        title: Row(
          children: [
            const Icon(Icons.favorite, color: _redIcon, size: 24),
            const SizedBox(width: 8),
            Text(
              'Saved Properties',
              style: TextStyle(
                color: primaryText,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20.0),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              bottom: 12.0,
              right: 16.0,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${_savedProperties.length} properties saved',
                style: TextStyle(color: secondaryText, fontSize: 14),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _savedProperties.length,
        itemBuilder: (context, index) {
          return _buildSavedPropertyCard(context, _savedProperties[index]);
        },
      ),
    );
  }

  Widget _buildSavedPropertyCard(
    BuildContext context,
    Map<String, dynamic> property,
  ) {
    return InkWell(
      onTap: () {
        Get.to(PropertyDetailsScreen(property: property));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[100]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.network(
                    property['image'],
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // For Sale Tag
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: blueColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'For Sale',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                // Delete Icon
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: _redIcon,
                        size: 20,
                      ),
                      onPressed: () {
                        // Handle Delete
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Property removed from saved'),
                          ),
                        );
                      },
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),

            // Content Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price
                  Text(
                    property['price'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: blueColor,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Address
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          property['address'],
                          style: TextStyle(
                            // Using Lora as per image style for address
                            fontSize: 14,
                            color: secondaryText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Divider
                  Divider(color: Colors.grey[200], height: 1),
                  const SizedBox(height: 16),

                  // Stats
                  Row(
                    children: [
                      _buildStat(Icons.bed_outlined, '${property['beds']}'),
                      const SizedBox(width: 24),
                      _buildStat(
                        Icons.bathtub_outlined,
                        '${property['baths']}',
                      ),
                      const SizedBox(width: 24),
                      _buildStat(Icons.square_foot, '${property['sqft']} sqft'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Saved Time
                  Text(
                    property['savedTime'],
                    style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: secondaryText),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: secondaryText,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
