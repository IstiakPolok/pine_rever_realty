import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/const/app_colors.dart';
import '../../../../core/network_caller/endpoints.dart';
import '../../../../core/services_class/local_service/shared_preferences_helper.dart';
import '../../BrokerageRelationship/Screens/brokerageRelationshipScreen.dart';

class ScheduleShowingScreen extends StatefulWidget {
  final int propertyId;
  const ScheduleShowingScreen({super.key, required this.propertyId});

  @override
  State<ScheduleShowingScreen> createState() => _ScheduleShowingScreenState();
}

class _ScheduleShowingScreenState extends State<ScheduleShowingScreen> {
  final TextEditingController _notesController = TextEditingController();
  String _preferredTime = 'morning';
  bool _isLoading = false;

  String _formatDate(DateTime date) {
    return '${_monthName(date.month)} ${date.day}, ${date.year}';
  }

  String _monthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month];
  }

  static final Color _activeCardBg = blueColor.withOpacity(
    0.1,
  ); // Light blue tint
  static const Color _inactiveCardBg = Color(0xFFFAFAFA);
  static const Color _inputBg = Color(0xFFF0F0F0);

  // List of scheduled showings
  final List<Map<String, dynamic>> _showings = [
    {
      'title': 'Modern Family Home',
      'address': '123 Oak Street, Springfield',
      'date': DateTime(2025, 11, 25),
      'time': '2:00 PM',
      'isActive': true,
    },
    {
      'title': 'Luxury Downtown Condo',
      'address': '456 Main Avenue, Downtown',
      'date': DateTime(2025, 12, 15),
      'time': '10:00 AM',
      'isActive': true,
    },
  ];

  // State for calendar
  DateTime _focusedDay = DateTime(2025, 11, 8);
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryText),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Schedule a Showing',
          style: TextStyle(
            color: primaryText,
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
            // 1. Upcoming Showings Section
            Text(
              'Your Upcoming Showings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: primaryText,
              ),
            ),
            const SizedBox(height: 16),

            // Show showing cards from list
            ..._showings.map(
              (showing) => Column(
                children: [
                  _buildShowingCard(
                    title: showing['title'],
                    address: showing['address'],
                    date: _formatDate(showing['date']),
                    time: showing['time'],
                    isActive: showing['isActive'],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 2. Schedule New Showing Section
            Text(
              'Schedule New Showing',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: primaryText,
              ),
            ),
            const SizedBox(height: 16),

            // Select Date Label
            Text(
              'Select Date',
              style: TextStyle(fontSize: 16, color: primaryText),
            ),
            const SizedBox(height: 12),

            // Real Calendar Widget
            TableCalendar(
              headerStyle: const HeaderStyle(titleCentered: true),
              firstDay: DateTime(2020, 1, 1),
              lastDay: DateTime(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) =>
                  _selectedDay != null && isSameDay(day, _selectedDay),
              calendarFormat: CalendarFormat.month,
              availableCalendarFormats: const {CalendarFormat.month: 'Month'},
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  final isScheduled = _showings.any(
                    (showing) => isSameDay(day, showing['date']),
                  );
                  return Container(
                    decoration: BoxDecoration(
                      color: isScheduled
                          ? Colors.grey[300]
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                          color: isScheduled ? Colors.grey[700] : primaryText,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
                selectedBuilder: (context, day, focusedDay) {
                  return Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Preferred Time
            Text(
              'Preferred Time',
              style: TextStyle(fontSize: 16, color: primaryText),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildTimeChip('morning', 'Morning'),
                const SizedBox(width: 8),
                _buildTimeChip('afternoon', 'Afternoon'),
                const SizedBox(width: 8),
                _buildTimeChip('evening', 'Evening'),
              ],
            ),
            const SizedBox(height: 24),

            // Additional Notes
            Text(
              'Additional Notes (Optional)',
              style: TextStyle(fontSize: 16, color: primaryText),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 3,
              style: TextStyle(color: primaryText),
              decoration: InputDecoration(
                hintText: 'Any special requests or questions for the agent?',
                hintStyle: TextStyle(color: greyText, fontSize: 14),
                filled: true,
                fillColor: _inputBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 32),

            // Bottom Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _scheduleShowing,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor, // Using primary Color
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Schedule Showing',
                        style: TextStyle(
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
  }

  // --- Helper Widgets ---

  Widget _buildTimeChip(String value, String label) {
    final isSelected = _preferredTime == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _preferredTime = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : _inputBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : secondaryText,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _scheduleShowing() async {
    if (_selectedDay == null) {
      Get.snackbar('Error', 'Please select a date');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        Get.snackbar('Error', 'Authentication token not found');
        return;
      }

      final String formattedDate = _selectedDay!.toIso8601String().split(
        'T',
      )[0];

      final Map<String, dynamic> payload = {
        'property_listing_id': widget.propertyId,
        'requested_date': formattedDate,
        'preferred_time': _preferredTime,
        'additional_notes': _notesController.text,
      };

      print('Create Showing Payload: ${jsonEncode(payload)}');

      final response = await http.post(
        Uri.parse(Urls.createShowing),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );

      print(
        'Create Showing Response: ${response.statusCode} - ${response.body}',
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.off(() => BrokerageRelationshipScreen());
        Get.snackbar('Success', 'Showing Scheduled Successfully!');
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar(
          'Error',
          errorData['message'] ?? 'Failed to schedule showing',
        );
      }
    } catch (e) {
      print('Error scheduling showing: $e');
      Get.snackbar('Error', 'An error occurred while scheduling');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildShowingCard({
    required String title,
    required String address,
    required String date,
    required String time,
    required bool isActive,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive ? _activeCardBg : _inactiveCardBg,
        borderRadius: BorderRadius.circular(12),
        border: isActive
            ? Border.all(
                color: blueColor.withOpacity(0.5),
              ) // Blue border if active
            : Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: primaryText,
            ),
          ),
          const SizedBox(height: 4),
          Text(address, style: TextStyle(fontSize: 13, color: secondaryText)),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: secondaryText,
              ),
              const SizedBox(width: 6),
              Text(date, style: TextStyle(fontSize: 13, color: secondaryText)),
              const SizedBox(width: 16),
              const Icon(Icons.access_time, size: 16, color: secondaryText),
              const SizedBox(width: 6),
              Text(time, style: TextStyle(fontSize: 13, color: secondaryText)),
            ],
          ),
        ],
      ),
    );
  }
}
