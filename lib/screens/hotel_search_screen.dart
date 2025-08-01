import 'package:flutter/material.dart';
import 'package:hotel_search_app/screens/destination_selection_screen.dart';
import 'package:hotel_search_app/screens/hotel_search_results_screen.dart';
import 'package:hotel_search_app/services/api_service.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class HotelSearchScreen extends StatefulWidget {
  const HotelSearchScreen({Key? key}) : super(key: key);

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
        title: const Text('Hotel Search'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hotel image banner
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1566073771259-6a8506099945'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Where To field
            TextField(
              readOnly: true,
              controller: TextEditingController(text: _selectedDestination),
              decoration: InputDecoration(
                labelText: 'Where To',
                hintText: 'Select destination',
                prefixIcon: const Icon(Icons.location_on),
                suffixIcon: const Icon(Icons.arrow_drop_down),
              ),
              onTap: () async {
                final selected = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DestinationSelectionScreen(),
                  ),
                );
                if (selected != null) {
                  setState(() {
                    _selectedDestination = selected;
                  });
                }
              },
            ),
            
            const SizedBox(height: 16),
            
            // When field
            TextField(
              readOnly: true,
              controller: TextEditingController(
                text: _fromDate != null && _toDate != null
                  ? '${DateFormat('MMM d, yyyy').format(_fromDate!)} - ${DateFormat('MMM d, yyyy').format(_toDate!)}'
                  : '',
              ),
              decoration: InputDecoration(
                labelText: 'When',
                hintText: 'Select dates',
                prefixIcon: const Icon(Icons.calendar_today),
                suffixIcon: const Icon(Icons.arrow_drop_down),
              ),
              onTap: () {
                _showDateRangePicker(context);
              },
            ),
            
            const SizedBox(height: 24),
            
            // Search button
            ElevatedButton(
              onPressed: _selectedDestination.isNotEmpty && _fromDate != null && _toDate != null
                ? _searchHotels
                : null,
              child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : const Text('SEARCH'),
            ),
          ],
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
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
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
}
