import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pine_rever_realty/core/const/app_colors.dart';
import '../../../../core/services_class/agent_listing_service.dart';
import '../../PropertyDetailsScreen /screens/PropertyDetailsScreen.dart';

class PropertyListScreen extends StatefulWidget {
  const PropertyListScreen({super.key});

  @override
  State<PropertyListScreen> createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends State<PropertyListScreen> {
  // Combined Data for the List View
  List<Map<String, dynamic>> _allProperties = [];
  bool _isPropertiesLoading = true;

  // Pagination
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoadingMore = false;
  final ScrollController _scrollController = ScrollController();

  // Filter controllers/state
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  String _selectedBedroomsFilter = 'Any';
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();

  // Last applied filters for paging
  int? _lastMinPrice;
  int? _lastMaxPrice;
  int? _lastBedrooms;
  String? _lastCity;
  String? _lastState;
  String? _lastZip;

  @override
  void initState() {
    super.initState();
    _loadProperties();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoadingMore &&
          _currentPage < _totalPages) {
        _loadMore();
      }
    });
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || _currentPage >= _totalPages) return;
    setState(() {
      _isLoadingMore = true;
    });
    final nextPage = _currentPage + 1;
    print('Loading more properties: nextPage=$nextPage');
    final resp = await AgentListingService.fetchAgentListings(
      page: nextPage,
      perPage: 20,
      minPrice: _lastMinPrice,
      maxPrice: _lastMaxPrice,
      bedrooms: _lastBedrooms,
      city: _lastCity,
      state: _lastState,
      zipCode: _lastZip,
    );
    if (resp != null) {
      final more = resp.results
          .map(
            (e) => {
              'id': e.id,
              'agent_id': e.agentId,
              'title': e.title.isNotEmpty ? e.title : 'No title',
              'address': e.address,
              'price': '\$${e.price.toString()}',
              'beds': e.bedrooms,
              'baths': e.bathrooms,
              'sqft': e.squareFeet.toString(),
              'agent': e.agentName,
              'image':
                  e.photoUrl ??
                  'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?fit=crop&w=800&q=80',
              'isFavorite': false,
            },
          )
          .toList();
      setState(() {
        _allProperties.addAll(more);
        _currentPage = resp.page;
        _totalPages = resp.totalPages;
      });
    }
    setState(() {
      _isLoadingMore = false;
    });
  }

  Future<void> _loadProperties({
    int? minPrice,
    int? maxPrice,
    int? bedrooms,
    String? city,
    String? state,
    String? zipCode,
    int page = 1,
  }) async {
    if (page == 1) {
      setState(() {
        _isPropertiesLoading = true;
      });
    }

    // Save last applied filters so loadMore can reuse them
    _lastMinPrice = minPrice;
    _lastMaxPrice = maxPrice;
    _lastBedrooms = bedrooms;
    _lastCity = city;
    _lastState = state;
    _lastZip = zipCode;

    final resp = await AgentListingService.fetchAgentListings(
      page: page,
      perPage: 20,
      minPrice: minPrice,
      maxPrice: maxPrice,
      bedrooms: bedrooms,
      city: city,
      state: state,
      zipCode: zipCode,
    );

    if (resp != null) {
      final mapped = resp.results
          .map(
            (e) => {
              'id': e.id,
              'agent_id': e.agentId,
              'title': e.title.isNotEmpty ? e.title : 'No title',
              'address': e.address,
              'price': '\$${e.price.toString()}',
              'beds': e.bedrooms,
              'baths': e.bathrooms,
              'sqft': e.squareFeet.toString(),
              'agent': e.agentName,
              'image':
                  e.photoUrl ??
                  'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?fit=crop&w=800&q=80',
              'isFavorite': false,
            },
          )
          .toList();

      setState(() {
        if (page == 1) {
          _allProperties = mapped;
        } else {
          _allProperties.addAll(mapped);
        }
        _currentPage = resp.page;
        _totalPages = resp.totalPages;
      });

      print(
        'Loaded ${mapped.length} properties (page ${resp.page}/${resp.totalPages}). Total now: ${_allProperties.length}',
      );
    }

    if (page == 1) {
      setState(() {
        _isPropertiesLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  // 1. Top Bar (Fixed at top)
                  _buildTopBar(),
                  SizedBox(height: 20.h),

                  // 2. Search Bar (Fixed at top)
                  _buildSearchBar(),
                  SizedBox(height: 20.h),

                  // 3. Scrollable Property List
                  Expanded(
                    child: _isPropertiesLoading
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            controller: _scrollController,
                            itemCount:
                                _allProperties.length +
                                (_isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index >= _allProperties.length) {
                                // Loading indicator item
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              return GestureDetector(
                                onTap: () {
                                  // Debug print when a property is tapped
                                  final prop = _allProperties[index];
                                  print(
                                    'Property tapped: title=${prop["title"]}, address=${prop["address"]}, id=${prop["id"]}, agent_id=${prop["agent_id"]}',
                                  );
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PropertyDetailsScreen(
                                            property: _allProperties[index],
                                          ),
                                    ),
                                  );
                                },
                                child: _buildPropertyCard(
                                  _allProperties[index],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 24.r,
              backgroundImage: const NetworkImage(
                'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?fit=crop&w=100&q=80',
              ),
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello',
                  style: GoogleFonts.lora(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                Text(
                  'Find your dream home',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.notifications_outlined, size: 28.sp),
              onPressed: () {},
              color: primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.refresh, size: 28.sp),
              onPressed: () => _loadProperties(),
              color: primaryColor,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50.h,
            decoration: BoxDecoration(
              color: const Color(
                0xFFFFF3E0,
              ).withOpacity(0.5), // Light orange bg
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: TextField(
              onSubmitted: (val) {
                // Quick search by city or title
                _loadProperties(
                  city: val.trim().isNotEmpty ? val.trim() : null,
                );
              },
              decoration: InputDecoration(
                hintText: 'Search properties (city or title)',
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14.sp),
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14.h),
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Container(
          height: 50.h,
          width: 50.w,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: IconButton(
            icon: const Icon(Icons.tune, color: primaryText),
            onPressed: () {
              _showFilterDialog(context); // Trigger the filter dialog
            },
          ),
        ),
      ],
    );
  }

  // --- FILTER DIALOG LOGIC ---

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          insetPadding: const EdgeInsets.all(20),
          backgroundColor: Colors.white,
          child: Container(
            padding: const EdgeInsets.all(24.0),
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filters',
                        style: GoogleFonts.lora(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primaryText,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Price Range
                  _buildFilterLabel('Price Range'),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFilterTextField(
                          controller: _minPriceController,
                          hint: 'Min Price',
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildFilterTextField(
                          controller: _maxPriceController,
                          hint: 'Max Price',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Minimum Bedroom
                  _buildFilterLabel('Minimum Bedroom'),
                  _buildFilterDropdown(
                    hint: _selectedBedroomsFilter,
                    items: ['Any', '1', '2', '3', '4+'],
                    onChanged: (val) {
                      setState(() {
                        _selectedBedroomsFilter = val ?? 'Any';
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Location
                  _buildFilterLabel('Location (City, State, ZIP)'),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFilterTextField(
                          controller: _cityController,
                          hint: 'City',
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildFilterTextField(
                          controller: _stateController,
                          hint: 'State',
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildFilterTextField(
                          controller: _zipController,
                          hint: 'ZIP',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Clear all filters
                            _minPriceController.clear();
                            _maxPriceController.clear();
                            _selectedBedroomsFilter = 'Any';
                            _cityController.clear();
                            _stateController.clear();
                            _zipController.clear();
                            // Reload unfiltered
                            _loadProperties();
                            Navigator.of(context).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: Colors.grey[400]!),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Clear All',
                            style: TextStyle(
                              color: primaryText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Apply filters
                            final int? minPrice =
                                _minPriceController.text.isNotEmpty
                                ? int.tryParse(_minPriceController.text)
                                : null;
                            final int? maxPrice =
                                _maxPriceController.text.isNotEmpty
                                ? int.tryParse(_maxPriceController.text)
                                : null;
                            final int? bedrooms =
                                _selectedBedroomsFilter != 'Any'
                                ? int.tryParse(
                                    _selectedBedroomsFilter.replaceAll('+', ''),
                                  )
                                : null;
                            final city = _cityController.text.trim().isNotEmpty
                                ? _cityController.text.trim()
                                : null;
                            final state =
                                _stateController.text.trim().isNotEmpty
                                ? _stateController.text.trim()
                                : null;
                            final zip = _zipController.text.trim().isNotEmpty
                                ? _zipController.text.trim()
                                : null;

                            _loadProperties(
                              minPrice: minPrice,
                              maxPrice: maxPrice,
                              bedrooms: bedrooms,
                              city: city,
                              state: state,
                              zipCode: zip,
                            );

                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: secondaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Apply Filters',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper for the Filter Dialog Labels
  Widget _buildFilterLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: GoogleFonts.lora(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: primaryText,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Helper for Input Fields in Filter Dialog (with controller)
  Widget _buildFilterTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEAEAEA), // Light grey from image
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14.sp),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  // Helper for Dropdowns in Filter Dialog (with onChanged)
  Widget _buildFilterDropdown({
    required String hint,
    required List<String> items,
    ValueChanged<String?>? onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAEAEA), // Light grey from image
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
            hint,
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[500]),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item, style: TextStyle(color: primaryText)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // --- END FILTER DIALOG LOGIC ---

  Widget _buildPropertyCard(Map<String, dynamic> property) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
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
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                child: Image.network(
                  property['image'],
                  height: 200.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // For Sale Tag
              Positioned(
                top: 16.h,
                left: 16.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: blueColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'For Sale',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              // Heart Icon
              Positioned(
                top: 16.h,
                right: 16.w,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    property['isFavorite']
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: property['isFavorite'] ? Colors.red : Colors.grey,
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          ),

          // Details Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property['title'],
                  style: GoogleFonts.lora(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      property['address'],
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Stats Row
                Row(
                  children: [
                    _buildStat(Icons.bed_outlined, '${property['beds']} beds'),
                    const SizedBox(width: 16),
                    _buildStat(
                      Icons.bathtub_outlined,
                      '${property['baths']} baths',
                    ),
                    const SizedBox(width: 16),
                    _buildStat(Icons.square_foot, '${property['sqft']} sqft'),
                  ],
                ),
                const SizedBox(height: 16),

                // Price and Agent
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      property['price'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: blueColor,
                      ),
                    ),
                    Text(
                      'Agent: ${property['agent']}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: Colors.grey[600]),
        SizedBox(width: 4.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
