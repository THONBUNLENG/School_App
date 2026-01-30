import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

class Directions {
  final List<LatLng> routePoints;
  final double duration; // seconds
  final double distance; // meters

  Directions({
    required this.routePoints,
    required this.duration,
    required this.distance,
  });

  factory Directions.fromJson(Map<String, dynamic> data) {
    final features = data['features'] as List<dynamic>;
    if (features.isEmpty) {
      throw Exception('No features found in directions response.');
    }

    final geometry = features[0]['geometry'];
    final coordinates = geometry['coordinates'] as List<dynamic>;

    final routePoints = coordinates
        .map<LatLng>((c) => LatLng(c[1] as double, c[0] as double))
        .toList();

    final properties = features[0]['properties'];
    final segments = properties['segments'] as List<dynamic>;
    final duration = segments.fold<double>(0, (sum, s) => sum + (s['duration'] as num).toDouble());
    final distance = segments.fold<double>(0, (sum, s) => sum + (s['distance'] as num).toDouble());

    return Directions(
      routePoints: routePoints,
      duration: duration,
      distance: distance,
    );
  }
}

class DirectionsRepository {
  static const String _baseUrl =
      'https://api.openrouteservice.org/v2/directions/driving-car';

  // 🔑 Replace with your ORS API Key
  static const String _apiKey = 'YOUR_API_KEY_HERE';

  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 5),
    sendTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  /// Fetch directions from origin to destination
  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    try {
      // Validate coordinates
      if (!_isValidLatLng(origin) || !_isValidLatLng(destination)) {
        debugPrint('Invalid origin or destination coordinates.');
        return null;
      }

      final queryParameters = {
        'api_key': _apiKey,
        'start': '${origin.longitude},${origin.latitude}', // ORS expects lon,lat
        'end': '${destination.longitude},${destination.latitude}',
      };

      final response = await _dio.get(
        _baseUrl,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['features'] != null && (data['features'] as List).isNotEmpty) {
          return Directions.fromJson(data);
        } else {
          debugPrint('No features found in ORS response.');
        }
      } else {
        debugPrint('Failed to fetch directions: ${response.statusCode}');
      }
    } on DioException catch (de) {
      if (de.type == DioExceptionType.connectionTimeout) {
        debugPrint('Connection timeout while fetching directions.');
      } else if (de.type == DioExceptionType.receiveTimeout) {
        debugPrint('Receive timeout while fetching directions.');
      } else if (de.response != null) {
        debugPrint('Dio Error: ${de.response?.data}');
      } else {
        debugPrint('Dio Error: ${de.message}');
      }
    } catch (e) {
      debugPrint('General Error fetching directions: $e');
    }
    return null;
  }

  /// Validate LatLng coordinates
  bool _isValidLatLng(LatLng point) {
    return point.latitude >= -90 &&
        point.latitude <= 90 &&
        point.longitude >= -180 &&
        point.longitude <= 180;
  }
}
