import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hotel_search_app/models/destination.dart';
import 'package:hotel_search_app/models/hotel.dart';

class ApiService {
  static const String baseUrl = 'https://samplehotelsearchapp-brnsoo0jo-sagarvs-projects.vercel.app/api';

  Future<List<Destination>> getDestinations() async {
    final response = await http.get(Uri.parse('$baseUrl/destination'));
    
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Destination.fromString(item.toString())).toList();
    } else {
      throw Exception('Failed to load destinations');
    }
  }

  Future<List<Hotel>> searchHotels({
    required String city,
    required String fromDate,
    required String toDate,
  }) async {
    final encodedCity = Uri.encodeComponent(city);
    final url = '$baseUrl/searchResults?city=$encodedCity&from_date=$fromDate&to_date=$toDate';
    
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Hotel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to search hotels');
    }
  }
}
