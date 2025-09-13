import 'package:flutter/material.dart';
import 'package:hotel_search_app/models/destination.dart';
import 'package:hotel_search_app/services/api_service.dart';

class DestinationSelectionScreen extends StatefulWidget {
  const DestinationSelectionScreen({Key? key}) : super(key: key);

  @override
  State<DestinationSelectionScreen> createState() => _DestinationSelectionScreenState();
}

class _DestinationSelectionScreenState extends State<DestinationSelectionScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Destination>> _destinationsFuture;
  String _searchQuery = '';
  
  @override
  void initState() {
    super.initState();
    _destinationsFuture = _apiService.getDestinations();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Destination'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Semantics(
              label: 'Search for destination',
              identifier: 'destination_search_field',
              child: TextField(
                key: const ValueKey('destination_search_field'),
                decoration: InputDecoration(
                  labelText: 'Search',
                  hintText: 'Search for city',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Destination>>(
              future: _destinationsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No destinations available'));
                } else {
                  final destinations = snapshot.data!;
                  final filteredDestinations = _searchQuery.isEmpty
                    ? destinations
                    : destinations.where((dest) => dest.city.toLowerCase().contains(_searchQuery)).toList();
                  
                  return ListView.separated(
                    itemCount: filteredDestinations.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final destination = filteredDestinations[index];
                      return Semantics(
                        label: 'Select ${destination.city} as destination',
                        identifier: 'destination_item_${destination.city.toLowerCase().replaceAll(' ', '_')}',
                        child: ListTile(
                          key: ValueKey('destination_${destination.city.toLowerCase().replaceAll(' ', '_')}'),
                          leading: const Icon(Icons.location_city),
                          title: Text(destination.city),
                          onTap: () {
                            Navigator.pop(context, destination.city);
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
