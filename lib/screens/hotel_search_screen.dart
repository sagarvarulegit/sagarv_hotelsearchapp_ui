import 'package:flutter/material.dart';
import 'package:hotel_search_app/screens/destination_selection_screen.dart';
import 'package:hotel_search_app/screens/hotel_search_results_screen.dart';
import 'package:hotel_search_app/services/api_service.dart';
import 'package:hotel_search_app/utils/animations.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class HotelSearchScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  const HotelSearchScreen({
    Key? key,
    required this.onThemeChanged,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  State<HotelSearchScreen> createState() => _HotelSearchScreenState();
}

class _HotelSearchScreenState extends State<HotelSearchScreen> {
  final ApiService _apiService = ApiService();
  String _selectedDestination = '';
  DateTime? _fromDate;
  DateTime? _toDate;
  bool _isLoading = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Your Stay'),
        centerTitle: true,
        actions: [
          Semantics(
            label: 'Toggle theme mode',
            identifier: 'theme_toggle_btn',
            child: IconButton(
              key: const ValueKey('theme_toggle_btn'),
              icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: () => widget.onThemeChanged(!widget.isDarkMode),
              tooltip: 'Toggle theme',
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero image with gradient overlay
              Hero(
                tag: 'hotel-banner',
                child: Container(
                  height: 240,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    image: const DecorationImage(
                      image: NetworkImage('https://images.unsplash.com/photo-1566073771259-6a8506099945'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Discover Amazing Hotels',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Find the perfect stay for your next adventure',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              // Search form card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Search Hotels',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Destination field
                      Semantics(
                        label: 'Select destination for hotel search',
                        identifier: 'destination_selector',
                        child: InkWell(
                          key: const ValueKey('destination_selector'),
                          onTap: () async {
                            final selected = await Navigator.push(
                              context,
                              AppAnimations.slideTransition(const DestinationSelectionScreen()),
                            );
                            if (selected != null) {
                              setState(() {
                                _selectedDestination = selected;
                              });
                            }
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Where to?',
                              prefixIcon: const Icon(Icons.location_on_outlined),
                              suffixIcon: const Icon(Icons.chevron_right),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              _selectedDestination.isEmpty ? 'Select destination' : _selectedDestination,
                              style: TextStyle(
                                color: _selectedDestination.isEmpty 
                                    ? Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6)
                                    : Theme.of(context).textTheme.bodyMedium?.color,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Date range field
                      const SizedBox(height: 16),
                      Semantics(
                        label: 'Select check-in and check-out dates',
                        identifier: 'date_range_selector',
                        child: InkWell(
                          key: const ValueKey('date_range_selector'),
                          onTap: () => _showDateRangePicker(context),
                          borderRadius: BorderRadius.circular(12),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'When',
                              prefixIcon: const Icon(Icons.calendar_today_outlined),
                              suffixIcon: const Icon(Icons.chevron_right),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              _fromDate != null && _toDate != null
                                  ? '${DateFormat('MMM d').format(_fromDate!)} - ${DateFormat('MMM d, yyyy').format(_toDate!)}'
                                  : 'Select dates',
                              style: TextStyle(
                                color: _fromDate != null
                                    ? Theme.of(context).textTheme.bodyMedium?.color
                                    : Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Search button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: Semantics(
                          label: 'Search for hotels',
                          identifier: 'search_hotels_btn',
                          child: ElevatedButton.icon(
                            key: const ValueKey('search_hotels_btn'),
                            onPressed: _selectedDestination.isNotEmpty && _fromDate != null && _toDate != null
                                ? _searchHotels
                                : null,
                            icon: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Icon(Icons.search, size: 20),
                            label: _isLoading
                                ? const Text('Searching...')
                                : const Text('Search Hotels'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Popular destinations section
              Text(
                'Popular Destinations',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildDestinationCard('Paris', 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=300'),
                    _buildDestinationCard('Tokyo', 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=300'),
                    _buildDestinationCard('New York', 'https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=300'),
                    _buildDestinationCard('Dubai', 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=300'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDateRangePicker(BuildContext context) {
    DateTime? selectedFromDate = _fromDate;
    DateTime? selectedToDate = _toDate;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Select Dates',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  
                  Expanded(
                    child: SingleChildScrollView(
                      child: TableCalendar(
                        firstDay: DateTime.now(),
                        lastDay: DateTime.now().add(const Duration(days: 365)),
                        focusedDay: selectedFromDate ?? DateTime.now(),
                        selectedDayPredicate: (day) {
                          return (selectedFromDate != null && isSameDay(day, selectedFromDate)) ||
                                 (selectedToDate != null && isSameDay(day, selectedToDate));
                        },
                        rangeStartDay: selectedFromDate,
                        rangeEndDay: selectedToDate,
                        calendarFormat: CalendarFormat.month,
                        rangeSelectionMode: RangeSelectionMode.enforced,
                        onRangeSelected: (start, end, focusedDay) {
                          setState(() {
                            selectedFromDate = start;
                            selectedToDate = end;
                          });
                        },
                        availableCalendarFormats: const {
                          CalendarFormat.month: 'Month'
                        },
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Semantics(
                        label: 'Cancel date selection',
                        identifier: 'date_picker_cancel_btn',
                        child: TextButton(
                          key: const ValueKey('date_picker_cancel_btn'),
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                      ),
                      Semantics(
                        label: 'Save selected dates',
                        identifier: 'date_picker_save_btn',
                        child: ElevatedButton(
                          key: const ValueKey('date_picker_save_btn'),
                          onPressed: selectedFromDate != null && selectedToDate != null
                            ? () {
                                _fromDate = selectedFromDate;
                                _toDate = selectedToDate;
                                Navigator.pop(context);
                                this.setState(() {});
                              }
                            : null,
                          child: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  
  Future<void> _searchHotels() async {
    if (_selectedDestination.isEmpty || _fromDate == null || _toDate == null) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final hotels = await _apiService.searchHotels(
        city: _selectedDestination,
        fromDate: DateFormat('yyyy-MM-dd').format(_fromDate!),
        toDate: DateFormat('yyyy-MM-dd').format(_toDate!),
      );
      
      if (!mounted) return;
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HotelSearchResultsScreen(hotels: hotels),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildDestinationCard(String destination, String imageUrl) {
    return Semantics(
      label: 'Select $destination as destination',
      identifier: 'popular_destination_${destination.toLowerCase().replaceAll(' ', '_')}',
      child: GestureDetector(
        key: ValueKey('popular_destination_${destination.toLowerCase().replaceAll(' ', '_')}'),
        onTap: () {
          setState(() {
            _selectedDestination = destination;
          });
        },
        child: Container(
          width: 200,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Text(
                    destination,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
