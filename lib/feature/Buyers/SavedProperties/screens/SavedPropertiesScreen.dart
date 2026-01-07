import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/const/app_colors.dart';
import '../../PropertyDetailsScreen /screens/PropertyDetailsScreen.dart';
import '../services/saved_properties_service.dart';

class SavedPropertiesScreen extends StatefulWidget {
  const SavedPropertiesScreen({super.key});

  @override
  State<SavedPropertiesScreen> createState() => _SavedPropertiesScreenState();
}

class _SavedPropertiesScreenState extends State<SavedPropertiesScreen> {
  static const Color _redIcon = Color(0xFFE53935);

  late Future<List<Map<String, dynamic>>> _futureSavedProperties;

  @override
  void initState() {
    super.initState();
    _futureSavedProperties = SavedPropertiesService.fetchSavedProperties();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
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
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _futureSavedProperties,
            builder: (context, snapshot) {
              final count = snapshot.hasData ? snapshot.data!.length : 0;
              return Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  bottom: 12.0,
                  right: 16.0,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '$count properties saved',
                    style: TextStyle(color: secondaryText, fontSize: 14),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureSavedProperties,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load saved properties'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No saved properties found'));
          }
          final properties = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: properties.length,
            itemBuilder: (context, index) {
              return _buildSavedPropertyCard(context, properties[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildSavedPropertyCard(
    BuildContext context,
    Map<String, dynamic> property,
  ) {
    final details = property['listing_details'] ?? {};
    final photoUrl = (details['photos'] != null && details['photos'].isNotEmpty)
        ? details['photos'][0]['photo']
        : null;
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
                  child: photoUrl != null
                      ? Image.network(
                          photoUrl,
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 220,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.image,
                            size: 60,
                            color: Colors.grey,
                          ),
                        ),
                ),
                // For Sale Tag
                if (details['status'] != null)
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
                        (details['status'] as String?)
                                ?.replaceAll('_', ' ')
                                .capitalizeFirst ??
                            '',
                        style: const TextStyle(
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
                      onPressed: () async {
                        final id = property['id'];
                        try {
                          await SavedPropertiesService.deleteSavedProperty(id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Property removed from saved'),
                            ),
                          );
                          setState(() {
                            _futureSavedProperties =
                                SavedPropertiesService.fetchSavedProperties();
                          });
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to remove property'),
                            ),
                          );
                        }
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
                    details['price'] != null ? ' 24${details['price']}' : '',
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
                          details['address'] ?? '',
                          style: TextStyle(fontSize: 14, color: secondaryText),
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
                      _buildStat(
                        Icons.bed_outlined,
                        '${details['bedrooms'] ?? '-'}',
                      ),
                      const SizedBox(width: 24),
                      _buildStat(
                        Icons.bathtub_outlined,
                        '${details['bathrooms'] ?? '-'}',
                      ),
                      const SizedBox(width: 24),
                      _buildStat(
                        Icons.square_foot,
                        '${details['square_feet'] ?? '-'} sqft',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Saved Time
                  Text(
                    property['created_at'] != null
                        ? 'Saved ${_formatSavedTime(property['created_at'])}'
                        : '',
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

  String _formatSavedTime(String isoDate) {
    try {
      final date = DateTime.parse(isoDate).toLocal();
      final now = DateTime.now();
      final diff = now.difference(date);
      if (diff.inDays >= 7) {
        final weeks = (diff.inDays / 7).floor();
        return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
      } else if (diff.inDays > 0) {
        return diff.inDays == 1 ? '1 day ago' : '${diff.inDays} days ago';
      } else if (diff.inHours > 0) {
        return diff.inHours == 1 ? '1 hour ago' : '${diff.inHours} hours ago';
      } else if (diff.inMinutes > 0) {
        return diff.inMinutes == 1
            ? '1 minute ago'
            : '${diff.inMinutes} minutes ago';
      } else {
        return 'just now';
      }
    } catch (_) {
      return '';
    }
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
