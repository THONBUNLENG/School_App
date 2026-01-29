import 'package:latlong2/latlong.dart';

class Directions {
  final List<LatLng> polylinePoints;
  final String totalDistance;
  final String totalDuration;

  const Directions({required this.polylinePoints, required this.totalDistance, required this.totalDuration});

  factory Directions.fromJson(Map<String, dynamic> json) {
    if (json['features'] == null || (json['features'] as List).isEmpty) throw Exception("No route");
    final feature = json['features'][0];
    final List<dynamic> coords = feature['geometry']['coordinates'];
    final props = feature['properties']['summary'];

    return Directions(
      polylinePoints: coords.map((c) => LatLng(c[1].toDouble(), c[0].toDouble())).toList(),
      totalDistance: '${(props['distance'] / 1000).toStringAsFixed(2)} km',
      totalDuration: '${(props['duration'] / 60).toStringAsFixed(0)} mins',
    );
  }
}