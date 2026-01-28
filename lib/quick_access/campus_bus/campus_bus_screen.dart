import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

// ១. កែសម្រួល Model ឱ្យមានទិន្នន័យ Occupancy ត្រឹមត្រូវ
class BusLocation {
  final double lat;
  final double lng;
  final String busId;
  final int occupancy; // ប្តូរពី getter មកជា field

  BusLocation({
    required this.lat,
    required this.lng,
    required this.busId,
    this.occupancy = 0,
  });
}

// ២. Bus Service សម្រាប់ទាញទិន្នន័យ (Mock Data)
class BusService {
  Future<List<BusLocation>> fetchLiveLocations() async {
    // ក្នុងជីវិតពិត អ្នកនឹងហៅ Dio().get(...) នៅទីនេះ
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      BusLocation(lat: 32.115, lng: 118.950, busId: "BUS-01", occupancy: 45),
      BusLocation(lat: 32.118, lng: 118.955, busId: "BUS-02", occupancy: 80),
    ];
  }
}

class MainBusScreen extends StatefulWidget {
  const MainBusScreen({super.key});

  @override
  State<MainBusScreen> createState() => _MainBusScreenState();
}

class _MainBusScreenState extends State<MainBusScreen> {
  GoogleMapController? _mapController;
  final BusService _busService = BusService();
  Set<Marker> _markers = {};
  Timer? _timer;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialLoad();
    _startLiveTracking();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _initialLoad() async {
    try {
      final buses = await _busService.fetchLiveLocations();
      if (mounted) {
        _updateMarkers(buses);
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint("Initial load error: $e");
    }
  }

  void _startLiveTracking() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (!mounted) return;
      final buses = await _busService.fetchLiveLocations();
      _updateMarkers(buses);
    });
  }

  void _updateMarkers(List<BusLocation> buses) {
    if (!mounted) return;
    setState(() {
      _markers = buses.map((bus) {
        return Marker(
          markerId: MarkerId(bus.busId),
          position: LatLng(bus.lat, bus.lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: InfoWindow(
            title: "Bus ID: ${bus.busId}",
            snippet: "Occupancy: ${bus.occupancy}%",
          ),
        );
      }).toSet();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // ផ្នែកផែនទី
          GoogleMap(
            initialCameraPosition: const CameraPosition(
                target: LatLng(32.115, 118.950),
                zoom: 15.0
            ),
            markers: _markers,
            onMapCreated: (controller) {
              _mapController = controller;
              // បន្ថែម Map Style បើមាន (Optional)
            },
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            compassEnabled: false,
            mapToolbarEnabled: false,
          ),

          // Header
          Positioned(top: 0, left: 0, right: 0, child: _buildHeader(isDark)),

          // Draggable Sheet
          _buildDraggableSheet(isDark),

          // Loading Overlay
          if (_isLoading) _buildLoadingOverlay(isDark),
        ],
      ),
    );
  }

  Widget _buildLoadingOverlay(bool isDark) {
    return Container(
      color: isDark ? Colors.black87 : Colors.white70,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(strokeWidth: 3, color: Color(0xFF3476E1)),
            const SizedBox(height: 16),
            Text(
              "Connecting to NJU Shuttle Service...",
              style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Battambang'
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 10,
          bottom: 20, left: 20, right: 20
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF0D1B2A), const Color(0xFF1B263B)]
              : [const Color(0xFF3476E1), const Color(0xFF67B0F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
            onPressed: () => Navigator.maybePop(context),
          ),
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("南京大学 校车", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Text("NJU Campus Shuttle", style: TextStyle(color: Colors.white70, fontSize: 10, letterSpacing: 1.2)),
            ],
          ),
          const CircleAvatar(radius: 18, backgroundColor: Colors.white24, child: Icon(Icons.person, color: Colors.white, size: 20)),
        ],
      ),
    );
  }

  Widget _buildDraggableSheet(bool isDark) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.15,
      maxChildSize: 0.7,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40, height: 4,
                  decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(10)),
                ),
              ),
              _buildStationTile("圖書館停車場", "Xianlin Library", "5m", true, isDark),
              const Divider(indent: 70),
              _buildStationTile("北門站", "North Gate Station", null, false, isDark),
              const Divider(indent: 70),
              _buildStationTile("宿舍區", "Dormitory Area", null, false, isDark),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStationTile(String title, String subtitle, String? time, bool isNext, bool isDark) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: (isNext ? const Color(0xFF3476E1) : Colors.grey),
        child: Icon(Icons.directions_bus, color: isNext ? const Color(0xFF3476E1) : Colors.grey),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      trailing: time != null
          ? Text(time, style: const TextStyle(color: Color(0xFF3476E1), fontWeight: FontWeight.bold, fontSize: 16))
          : const Icon(Icons.chevron_right, color: Colors.grey),
    );
  }
}