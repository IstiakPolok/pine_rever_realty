import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/showings_service.dart';

class ScheduleListScreen extends StatefulWidget {
  const ScheduleListScreen({super.key});

  @override
  State<ScheduleListScreen> createState() => _ScheduleListScreenState();
}

class _ScheduleListScreenState extends State<ScheduleListScreen> {
  // Colors
  static const Color _textDark = Color(0xFF212121);
  static const Color _textGrey = Color(0xFF616161);
  static const Color _cardBg = Color(0xFFF5F9FF); // Very light blue background
  static const Color _cardBorder = Color(0xFFE1EAF5); // Light border

  bool _isLoading = true;
  String _error = '';
  List<Map<String, dynamic>> _showings = [];

  @override
  void initState() {
    super.initState();
    _fetchShowings();
  }

  Future<void> _fetchShowings() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      final results = await ShowingsService.fetchShowings();
      setState(() {
        _showings = results;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load showings';
      });
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Schedule List',
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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              'Your Upcoming Showings',
              style: GoogleFonts.lora(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: _textDark,
              ),
            ),
            const SizedBox(height: 16),

            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_error.isNotEmpty)
              Center(child: Text(_error))
            else if (_showings.isEmpty)
              const Center(child: Text('No showings found'))
            else
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _fetchShowings,
                  child: ListView.separated(
                    itemCount: _showings.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final s = _showings[index];
                      final property = s['property_listing'] ?? {};
                      final title = property['title'] ?? 'No title';
                      final address = property['address'] ?? '';
                      final date = s['requested_date'] ?? '';
                      final time = s['preferred_time'] ?? '';
                      return _buildScheduleCard(
                        title: title,
                        address: address,
                        date: date,
                        time: time,
                        status: s['status'] ?? '',
                        hasAgreement: s['has_agreement'] ?? false,
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleCard({
    required String title,
    required String address,
    required String date,
    required String time,
    bool isGrey = false,
    String status = '',
    bool hasAgreement = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isGrey ? const Color(0xFFFAFAFA) : _cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isGrey ? Colors.grey[200]! : _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.lora(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: _textDark,
                  ),
                ),
              ),
              if (status.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status[0].toUpperCase() + status.substring(1),
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            address,
            style: GoogleFonts.poppins(fontSize: 13, color: _textGrey),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 16, color: _textGrey),
              const SizedBox(width: 6),
              Text(
                date,
                style: GoogleFonts.poppins(fontSize: 13, color: _textGrey),
              ),
              const SizedBox(width: 16),
              Icon(Icons.access_time, size: 16, color: _textGrey),
              const SizedBox(width: 6),
              Text(
                time,
                style: GoogleFonts.poppins(fontSize: 13, color: _textGrey),
              ),
            ],
          ),
          if (hasAgreement) ...[
            const SizedBox(height: 12),
            Text(
              'Agreement available',
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.green),
            ),
          ],
        ],
      ),
    );
  }
}
