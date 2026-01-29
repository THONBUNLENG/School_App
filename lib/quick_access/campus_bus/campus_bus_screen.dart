import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';

import '../../model/model_bus.dart';


class Station {
  final String name;
  final LatLng location;
  Station(this.name, this.location);
}

// --- ២. MAIN SCREEN ---
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
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
                markers: _buses.map((bus) => Marker(
                  point: LatLng(bus.lat, bus.lng),
                  width: 60, height: 60,
                  child: GestureDetector(
                    onTap: () => _animatedMapMove(LatLng(bus.lat, bus.lng), 17.0),
                    child: const Icon(Icons.directions_bus, color: Color(0xFF3476E1), size: 35),
                  ),
                )).toList(),
              ),
            ],
          ),

          // HEADER WITH SEARCH BAR
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
          bottom: 25,
          left: 10,
          right: 20
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF1B263B), const Color(0xFF0D1B2A)]
              : [const Color(0xFF3476E1), const Color(0xFF67B0F5)],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Row(
            children: [

              IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              ),

              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      "南京大学 校车",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 2), 
                    Text(
                      "NJU Campus Shuttle",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                          letterSpacing: 1.1
                      ),
                    ),
                  ],
                )
              ),

              // Profile Avatar
              const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white24,

                backgroundImage: NetworkImage("https://scontent.fpnh19-1.fna.fbcdn.net/v/t39.30808-6/565256792_869820712368021_2775110481695495555_n.jpg?stp=dst-jpg_s206x206_tt6&_nc_cat=109&ccb=1-7&_nc_sid=fe5ecc&_nc_ohc=Gw8XA4kWnoYQ7kNvwExYIwu&_nc_oc=AdnOTMQyfWOLB_BheKEu5XTcy7QxFX7ZkZdd8bMbnd1rMSQcCoZp87h02O44LaMDPNs&_nc_zt=23&_nc_ht=scontent.fpnh19-1.fna&_nc_gid=7PJE6NZ8oU9kqXNiHwVOJA&oh=00_AfquH0V8VDa1gz_R6Jf0FZqVxTQDK_aV4b2Grzuwp1TaMQ&oe=697FA6B5"),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white24, width: 0.5),
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                hintText: "Search for stations...",
                hintStyle: const TextStyle(color: Colors.white60, fontSize: 14),
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search, color: Colors.white70, size: 22),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.white60, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                )
                    : null,
              ),
              onChanged: (value) => setState(() {}),
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
      final found = _stations.firstWhere(
            (s) => s.name.toLowerCase().contains(query.toLowerCase()),
      );

      _animatedMapMove(found.location, 17.0);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Going to ${found.name}"), duration: const Duration(seconds: 1)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Station not found!")),
      );
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
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: ListView.builder(
            controller: scrollController,
            itemCount: _stations.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) return Center(child: Container(margin: const EdgeInsets.symmetric(vertical: 10), width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(10))));
              final station = _stations[index - 1];
              return ListTile(
                leading: const Icon(Icons.location_on, color: Color(0xFF3476E1)),
                title: Text(station.name, style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                onTap: () => _animatedMapMove(station.location, 16.5),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildLoadingOverlay(bool isDark) {
    return Container(color: isDark ? Colors.black87 : Colors.white70, child: const Center(child: CircularProgressIndicator()));
  }
}