import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../../extension/change_notifier.dart'; // ប្រាកដថា path ត្រឹមត្រូវសម្រាប់ ThemeManager
import '../../config/app_color.dart';      // ប្រើ AppColor & BrandGradient របស់អ្នក
import '../../model/model_bus.dart';

class Station {
  final String name;
  final LatLng location;
  Station(this.name, this.location);
}

class MainBusScreen extends StatefulWidget {
  const MainBusScreen({super.key});
  @override
  State<MainBusScreen> createState() => _MainBusScreenState();
}

class _MainBusScreenState extends State<MainBusScreen> with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  List<BusLocation> _buses = [];
  bool _isLoading = true;
  Timer? _timer;

  final List<Station> _stations = [
    Station("Library", const LatLng(32.115, 118.950)),
    Station("North Gate", const LatLng(32.118, 118.955)),
    Station("Gymnasium", const LatLng(32.112, 118.945)),
    Station("Student Center", const LatLng(32.110, 118.940)),
  ];

  @override
  void initState() {
    super.initState();
    _fetchBuses();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) => _fetchBuses());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _fetchBuses() async {
    // Simulated movement
    final double move = (DateTime.now().second % 10) * 0.0003;
    final newBuses = [
      BusLocation(lat: 32.115 + move, lng: 118.950 + move, busId: "BUS-01", occupancy: 42),
      BusLocation(lat: 32.118 - move, lng: 118.955, busId: "BUS-02", occupancy: 78),
    ];
    if (mounted) setState(() { _buses = newBuses; _isLoading = false; });
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    final latTween = Tween<double>(begin: _mapController.camera.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(begin: _mapController.camera.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: _mapController.camera.zoom, end: destZoom);

    final controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    final animation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      _mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });
    controller.forward().then((_) => controller.dispose());
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeManager>(context).isDarkMode;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: isDark ? AppColor.backgroundColor : Colors.white,
      body: Stack(
        children: [
          // MAP LAYER
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(initialCenter: LatLng(32.115, 118.950), initialZoom: 15.0),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.nju.shuttle.app',
                tileBuilder: isDark ? (context, tileWidget, tile) => ColorFiltered(
                  colorFilter: const ColorFilter.matrix([
                    -1, 0, 0, 0, 255, 0, -1, 0, 0, 255, 0, 0, -1, 0, 255, 0, 0, 0, 1, 0,
                  ]),
                  child: tileWidget,
                ) : null,
              ),
              MarkerLayer(
                markers: [
                  // Bus Markers (Gold Color)
                  ..._buses.map((bus) => Marker(
                    point: LatLng(bus.lat, bus.lng),
                    width: 60, height: 60,
                    child: GestureDetector(
                      onTap: () => _animatedMapMove(LatLng(bus.lat, bus.lng), 17.0),
                      child: const Icon(Icons.directions_bus_rounded, color: AppColor.accentGold, size: 35),
                    ),
                  )),
                  // Station Markers (Purple Color)
                  ..._stations.map((station) => Marker(
                    point: station.location,
                    width: 40, height: 40,
                    child: Icon(Icons.location_on, color: AppColor.primaryColor.withOpacity(0.8), size: 25),
                  )),
                ],
              ),
            ],
          ),

          // HEADER (Luxury Purple Gradient)
          Positioned(top: 0, left: 0, right: 0, child: _buildHeader(isDark)),

          // BOTTOM SHEET
          _buildDraggableSheet(isDark),

          if (_isLoading) _buildLoadingOverlay(isDark),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 10,
          bottom: 25, left: 10, right: 20
      ),
      decoration: BoxDecoration(
        gradient: BrandGradient.luxury,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(35)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(Icons.arrow_back_ios_new, color: AppColor.lightGold, size: 20),
              ),
              Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        "南京大学 校车",
                        style: TextStyle(color: AppColor.lightGold, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "NJU Campus Shuttle",
                        style: TextStyle(color: Colors.white70, fontSize: 10, letterSpacing: 1.2),
                      ),
                    ],
                  )
              ),
              const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white12,
                backgroundImage: NetworkImage("https://scontent.fpnh19-1.fna.fbcdn.net/v/t39.30808-6/..."), // Shortened for brevity
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Search Bar
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AppColor.glassBorder, width: 0.5),
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              decoration: InputDecoration(
                hintText: "Search for stations...",
                hintStyle: const TextStyle(color: Colors.white54, fontSize: 14),
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search, color: AppColor.lightGold, size: 22),
              ),
              onSubmitted: (value) => _handleSearch(value),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSearch(String query) {
    if (query.isEmpty) return;
    try {
      final found = _stations.firstWhere((s) => s.name.toLowerCase().contains(query.toLowerCase()));
      _animatedMapMove(found.location, 17.0);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Station not found!")));
    }
  }

  Widget _buildDraggableSheet(bool isDark) {
    return DraggableScrollableSheet(
      initialChildSize: 0.25,
      minChildSize: 0.15,
      maxChildSize: 0.6,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColor.surfaceColor : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          child: Column(
            children: [
              Container(margin: const EdgeInsets.symmetric(vertical: 12), width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(10))),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.zero,
                  itemCount: _stations.length,
                  itemBuilder: (context, index) {
                    final station = _stations[index];
                    return ListTile(
                      leading: const Icon(Icons.location_on, color: AppColor.accentGold),
                      title: Text(station.name, style: TextStyle(color: isDark ? Colors.white : AppColor.primaryColor, fontWeight: FontWeight.bold)),
                      subtitle: const Text("Station Available", style: TextStyle(fontSize: 11, color: Colors.grey)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                      onTap: () => _animatedMapMove(station.location, 16.5),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingOverlay(bool isDark) {
    return Container(
      color: isDark ? Colors.black54 : Colors.white70,
      child: const Center(child: CircularProgressIndicator(color: AppColor.accentGold)),
    );
  }
}