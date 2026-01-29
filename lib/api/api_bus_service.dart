import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'directions_bus.dart';

class DirectionsRepository {
  static const String _baseUrl = 'https://api.openrouteservice.org/v2/directions/driving-car';

  static const String _apiKey = 'YOUR_FREE_ORS_API_KEY_HERE';

  Future<Directions?> getDirections({required LatLng origin, required LatLng destination}) async {
    try {
      final response = await Dio().get(_baseUrl, queryParameters: {
        'api_key': _apiKey,
        'start': '${origin.longitude},${origin.latitude}',
        'end': '${destination.longitude},${destination.latitude}',
      });
      if (response.statusCode == 200) return Directions.fromJson(response.data);
    } catch (e) {
      debugPrint("Routing Error: $e");
    }
    return null;
  }
}