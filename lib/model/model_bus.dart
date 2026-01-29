// --- ១. MODELS ---
class BusLocation {
  final double lat;
  final double lng;
  final String busId;
  final int occupancy;

  BusLocation({required this.lat, required this.lng, required this.busId, this.occupancy = 0});
}