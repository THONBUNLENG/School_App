import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../config/app_color.dart';
import '../../extension/change_notifier.dart';
import 'booking.dart';

class MainBusScreen extends StatefulWidget {
  const MainBusScreen({super.key});

  @override
  State<MainBusScreen> createState() => _MainBusScreenState();
}

class _MainBusScreenState extends State<MainBusScreen> with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  LatLng? _userLocation;
  LatLng? _destination;
  List<LatLng> _routePoints = [];
  LatLng _busPos = const LatLng(32.120, 118.960);

  bool _isSatellite = false;
  bool _isBusMoving = false;
  bool _hasAlerted = false;
  int _currentStep = 0;
  Timer? _moveTimer;
  String _eta = "Calculating...";

  @override
  void initState() {
    super.initState();
    _initLocationTracking();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _moveTimer?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _initLocationTracking() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    Geolocator.getPositionStream(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high))
        .listen((pos) {
      if (mounted) {
        setState(() => _userLocation = LatLng(pos.latitude, pos.longitude));
        _checkDistanceForAlert();
      }
    });
  }

  void _checkDistanceForAlert() {
    if (_userLocation == null || !_isBusMoving) return;
    double distance = Geolocator.distanceBetween(
      _busPos.latitude, _busPos.longitude,
      _userLocation!.latitude, _userLocation!.longitude,
    );
    if (distance < 100 && !_hasAlerted) {
      HapticFeedback.heavyImpact();
      _showArrivalNotification();
      setState(() => _hasAlerted = true);
    }
  }

  void _showArrivalNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("🚌 The bus is coming! Get ready."),
        backgroundColor: AppColor.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _onSearch() async {
    String query = _searchController.text.trim();
    if (query.isEmpty) return;
    final url = Uri.parse('https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.isNotEmpty) {
          final found = LatLng(double.parse(data[0]['lat']), double.parse(data[0]['lon']));
          setState(() { _destination = found; _eta = "Calculating..."; });
          _mapController.move(found, 16.0);
          _fetchRoute();
          FocusScope.of(context).unfocus();
        }
      }
    } catch (e) { debugPrint("Search Error: $e"); }
  }

  Future<void> _fetchRoute() async {
    if (_destination == null) return;
    final url = Uri.parse(
      'https://router.project-osrm.org/route/v1/driving/'
          '${_busPos.longitude},${_busPos.latitude};'
          '${_destination!.longitude},${_destination!.latitude}'
          '?overview=full&geometries=geojson',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final coords = data['routes'][0]['geometry']['coordinates'] as List;
        final duration = (data['routes'][0]['duration'] as num).toDouble();
        final route = coords.map((c) => LatLng(c[1], c[0])).toList();
        setState(() { _routePoints = route; _currentStep = 0; _eta = "${(duration / 60).round()} min"; _hasAlerted = false; });
        _startBusNavigation(route);
      }
    } catch (e) { debugPrint("Route Error: $e"); }
  }

  void _startBusNavigation(List<LatLng> route) {
    if (route.isEmpty) return;
    _moveTimer?.cancel();
    setState(() => _isBusMoving = true);
    _moveTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (_currentStep < route.length - 1) {
        setState(() { _busPos = route[_currentStep]; _currentStep++; });
        _checkDistanceForAlert();
      } else {
        timer.cancel();
        setState(() { _isBusMoving = false; _eta = "Arrived"; });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeManager>(context).isDarkMode;

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(32.115, 118.950),
              initialZoom: 15.5,
              onTap: (_, latlng) {
                setState(() => _destination = latlng);
                _fetchRoute();
              },
            ),
            children: [
              TileLayer(
                urlTemplate: _isSatellite
                    ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
                    : (isDark
                    ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
                    : 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'),
                subdomains: const ['a', 'b', 'c'],
              ),
              if (_routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [Polyline(points: _routePoints, color: AppColor.accentGold, strokeWidth: 5)],
                ),
              MarkerLayer(
                markers: [
                  if (_userLocation != null)
                    Marker(point: _userLocation!, width: 40, height: 40, child: _buildUserMarker()),
                  if (_destination != null)
                    Marker(point: _destination!, width: 50, height: 50,
                        child: const Icon(Icons.location_on, color: Colors.red, size: 35)),
                  Marker(point: _busPos, width: 80, height: 80, child: _buildBusMarker()),
                ],
              ),
            ],
          ),

          Positioned(top: 50, left: 15, right: 15, child: _buildSearchHeader(isDark)),

          Positioned(right: 15, top: 125, child: _buildSideTools()),

          _buildDraggablePanel(isDark),
        ],
      ),
    );
  }

  Widget _buildSearchHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      height: 55,
      decoration: BoxDecoration(
        color: isDark
            ? AppColor.surfaceColor.withOpacity(0.9)
            : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.black12,
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColor.accentGold,
              size: 20,
            ),
          ),

          // 垂直 Divider
          VerticalDivider(
            indent: 15,
            endIndent: 15,
            thickness: 1,
            width: 8,
            color: isDark ? Colors.white10 : Colors.black12,
          ),

          Expanded(
            child: TextField(
              controller: _searchController,
              onSubmitted: (_) => _onSearch(),
              onChanged: (val) => setState(() {}),
              style: TextStyle(
                color: isDark ? Colors.white : AppColor.primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: "Search a building or gate...",
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                hintStyle: TextStyle(
                  color: isDark ? Colors.white30 : Colors.grey.shade400,
                  fontSize: 14,
                ),
              ),
            ),
          ),

          if (_searchController.text.isNotEmpty)
            IconButton(
              onPressed: () {
                _searchController.clear();
                setState(() {});
              },
              icon: Icon(
                  Icons.close_rounded,
                  color: isDark ? Colors.white54 : Colors.grey.shade400,
                  size: 20
              ),
            ),

          VerticalDivider(
            indent: 15,
            endIndent: 15,
            thickness: 1,
            width: 8,
            color: isDark ? Colors.white10 : Colors.black12,
          ),

          IconButton(
            onPressed: _onSearch,
            icon: const Icon(
                Icons.search_rounded,
                color: AppColor.accentGold,
                size: 24
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSideTools() => Column(
    children: [
      FloatingActionButton.small(
        heroTag: "layer",
        onPressed: () => setState(() => _isSatellite = !_isSatellite),
        backgroundColor: Colors.white, child: Icon(_isSatellite ? Icons.map : Icons.layers, color: Colors.blue),
      ),
      const SizedBox(height: 12),
      FloatingActionButton.small(
        heroTag: "locate",
        onPressed: () => _userLocation != null ? _mapController.move(_userLocation!, 17) : null,
        backgroundColor: Colors.white, child: const Icon(Icons.my_location, color: Colors.blue),
      ),
    ],
  );

  Widget _buildBusMarker() => Column(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: AppColor.primaryColor, borderRadius: BorderRadius.circular(10)),
        child: Text(_eta, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
      ),
      const Icon(Icons.directions_bus, color: AppColor.accentGold, size: 35),
    ],
  );

  Widget _buildUserMarker() => Stack(
    alignment: Alignment.center,
    children: [
      Container(width: 30, height: 30, decoration: BoxDecoration(color: Colors.blue.withOpacity(0.2), shape: BoxShape.circle)),
      Container(width: 14, height: 14, decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.white, blurRadius: 4)])),
    ],
  );

  Widget _buildDraggablePanel(bool isDark) {
    return DraggableScrollableSheet(
      initialChildSize: 0.18,
      minChildSize: 0.12,
      maxChildSize: 0.6,
      snap: true,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColor.surfaceColor : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 15)],
          ),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.zero,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 45, height: 5,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  children: [
                    const CircleAvatar(backgroundColor: AppColor.accentGold, child: Icon(Icons.bus_alert, color: Colors.white)),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("NJU Shuttle NJU-01", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                          Text(_isBusMoving ? "On my way to you": "Waiting for a call...", style: const TextStyle(fontSize: 13, color: Colors.grey)),
                        ],
                      ),
                    ),
                    Text(_eta, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColor.primaryColor)),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const Divider(thickness: 0.5),
              _buildDetailTile("Next stop", "Main Library Gate", Icons.map_outlined),
              _buildDetailTile("Number of seats available", "8 seats", Icons.chair_alt_outlined),
              _buildDetailTile("Current speed", "40 km/h", Icons.speed),
              _buildDetailTile("Driver ", "Mr. Zhang", Icons.person_outline),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SeatBookingView(busInfo: {
                      'route': 'Main Library Gate',
                      'time': '10:30 AM',
                    })));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text("Book a seat now", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailTile(String title, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: AppColor.accentGold, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      dense: true,
    );
  }
}