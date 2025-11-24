import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/const/app_colors.dart';
import '../../BrokerageRelationship/Screens/brokerageRelationshipScreen.dart';

class ScheduleShowingScreen extends StatefulWidget {
  const ScheduleShowingScreen({super.key});

  @override
  State<ScheduleShowingScreen> createState() => _ScheduleShowingScreenState();
}

class _ScheduleShowingScreenState extends State<ScheduleShowingScreen> {
  TimeOfDay? _selectedTime;
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
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime ?? TimeOfDay.now(),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        dialogBackgroundColor: Colors.white,
                        timePickerTheme: TimePickerThemeData(
                          backgroundColor: Colors.white,
                          dialBackgroundColor: primaryColor.withOpacity(0.1),
                          dialHandColor: primaryColor,
                          hourMinuteTextColor: secondaryColor,
                          hourMinuteColor: secondaryColor.withOpacity(0.1),
                          dayPeriodTextColor: primaryText,
                          entryModeIconColor: primaryText,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  setState(() {
                    _selectedTime = picked;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: _inputBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedTime == null
                          ? 'Select a time'
                          : _selectedTime!.format(context),
                      style: TextStyle(color: secondaryText),
                    ),
                    const Icon(Icons.access_time, color: secondaryText),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Additional Notes
            Text(
              'Additional Notes (Optional)',
              style: TextStyle(fontSize: 16, color: primaryText),
            ),
            const SizedBox(height: 8),
            TextField(
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
                onPressed: () {
                  Get.off(BrokerageRelationshipScreen());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Showing Scheduled!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor, // Using primary Color
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Schedule Showing',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

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
