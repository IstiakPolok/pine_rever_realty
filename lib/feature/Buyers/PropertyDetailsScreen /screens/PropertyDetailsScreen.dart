import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../core/const/app_colors.dart';
import '../../../../core/network_caller/endpoints.dart';
import '../../../../core/services_class/local_service/shared_preferences_helper.dart';
import '../../../chat/screen/ChatDetailScreen.dart';
import '../../Schedule/screens/scheduleShowingScreen.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> property;
  const PropertyDetailsScreen({super.key, required this.property});

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  // State to track which tab is selected: 0 for Overview, 1 for Feature
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    // Debug prints for passed IDs
    final id = widget.property['id'];
    final agentId = widget.property['agent_id'];
    print('PropertyDetailsScreen opened with id=$id, agent_id=$agentId');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.snackbar(
        'Debug',
        'id=$id, agent_id=$agentId',
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header Image with Back Button
            Stack(
              children: [
                Image.network(
                  widget.property['image'] ??
                      "https://images.unsplash.com/photo-1564013799919-ab600027ffc6?fit=crop&w=800&q=80",
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Title and Address
                  Row(
                    children: [
                      Container(
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
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'House',
                          style: TextStyle(
                            color: primaryText,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.property['title'] ?? 'Property Details',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.property['address'] ?? 'Unknown address',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.property['price'] ?? '',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: blueColor,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 3. Stats Row
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem(
                          Icons.bed_outlined,
                          '${widget.property['beds'] ?? '-'} Beds',
                        ),
                        _buildStatItem(
                          Icons.bathtub_outlined,
                          '${widget.property['baths'] ?? '-'} Baths',
                        ),
                        _buildStatItem(
                          Icons.square_foot,
                          '${widget.property['sqft'] ?? '-'} sqft',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 4. Tab Selector (Overview vs Feature)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: greyText,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        Expanded(child: _buildTabButton(0, 'Overview')),
                        Expanded(child: _buildTabButton(1, 'Feature')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 5. Dynamic Content Area
                  _selectedTab == 0
                      ? _buildOverviewContent()
                      : _buildFeatureContent(),

                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 24),

                  // 6. Agent Section
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?fit=crop&w=100&q=80',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.property['agent'] ?? 'Agent',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: primaryText,
                            ),
                          ),
                          Text(
                            'Licensed Real Estate Agent',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 7. Contact Buttons
                  Row(
                    children: [
                      Expanded(child: _buildContactButton(Icons.phone, 'Call')),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildContactButton(
                          Icons.email_outlined,
                          'Email',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildContactButton(
                          Icons.chat_bubble_outline,
                          'Chat',
                          onPressed: _startChat,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 8. Schedule Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final propertyId = widget.property['id'];
                        if (propertyId != null) {
                          Get.to(
                            () => ScheduleShowingScreen(propertyId: propertyId),
                          );
                        } else {
                          Get.snackbar('Error', 'Property ID not found');
                        }
                      },
                      icon: const Icon(Icons.calendar_today_outlined, size: 18),
                      label: Text(
                        'Schedule a Showing',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildStatItem(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[600], size: 24),
        const SizedBox(height: 8),
        Text(text, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
      ],
    );
  }

  Widget _buildTabButton(int index, String text) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: primaryText,
            ),
          ),
        ),
      ),
    );
  }

  // Content for "Overview" Tab
  Widget _buildOverviewContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Beautiful house in a prime location. This stunning property features modern amenities, spacious rooms, and excellent natural lighting throughout. Perfect for families or professionals looking for a comfortable living space.',
          style: TextStyle(color: Colors.grey[600], height: 1.6, fontSize: 14),
        ),
        const SizedBox(height: 24),
        _buildDetailRow('Property Type', 'House'),
        _buildDetailRow('Year Built', '2018'),
        _buildDetailRow('Parking', '2 Car Garage'),
        _buildDetailRow('HOA Fees', '\$250/month'),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 15, color: Colors.grey[600])),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: primaryText,
            ),
          ),
        ],
      ),
    );
  }

  // Content for "Feature" Tab
  Widget _buildFeatureContent() {
    final features = [
      'Hardwood Floors',
      'Central AC',
      'Updated Kitchen',
      'Walk-in Closets',
      'Granite Counters',
      'Stainless Appliances',
      'Backyard',
      'Smart Home',
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: features.map((feature) {
        // Calculate roughly 50% width minus spacing to create 2 columns
        return SizedBox(
          width: (MediaQuery.of(context).size.width - 64) / 2,
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: blueColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  feature,
                  style: TextStyle(fontSize: 14, color: primaryText),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildContactButton(
    IconData icon,
    String label, {
    VoidCallback? onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed ?? () {},
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryText,
        side: BorderSide(color: Colors.grey[300]!),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Future<void> _startChat() async {
    final agentId = widget.property['agent_id'];
    if (agentId == null) {
      Get.snackbar('Error', 'Agent ID not found');
      return;
    }

    // Show loading
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        Get.back(); // Close loading
        Get.snackbar('Error', 'Authentication token not found');
        return;
      }

      final Map<String, dynamic> payload = {'other_user_id': agentId};
      print('Create Conversation Payload: ${jsonEncode(payload)}');

      final response = await http.post(
        Uri.parse(Urls.createConversation),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );

      print(
        'Create Conversation Response: ${response.statusCode} - ${response.body}',
      );
      Get.back(); // Close loading

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final conversationId = data['id'];

        if (conversationId != null) {
          Get.to(
            () => ChatDetailScreen(
              conversationId: conversationId,
              otherUserName: widget.property['agent'] ?? 'Agent',
              otherUserStatus: 'Active',
            ),
          );
        } else {
          Get.snackbar('Error', 'Failed to get conversation ID');
        }
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar('Error', errorData['message'] ?? 'Failed to start chat');
      }
    } catch (e) {
      Get.back(); // Close loading
      print('Error starting chat: $e');
      Get.snackbar('Error', 'An error occurred while starting chat');
    }
  }
}
