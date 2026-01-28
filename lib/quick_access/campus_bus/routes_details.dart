import 'package:flutter/material.dart';

class RoutesDetailsPage extends StatelessWidget {
  const RoutesDetailsPage({super.key});

  final List<Map<String, dynamic>> routePoints = const [
    {"name": "Xianlin Campus North Gate", "isPassed": true, "hasBus": false},
    {"name": "Library & Information Center", "isPassed": true, "hasBus": true},
    {"name": "Teaching Building No. 2", "isPassed": false, "hasBus": false},
    {"name": "Student Dormitory Area", "isPassed": false, "hasBus": false},
    {"name": "Athletic Center", "isPassed": false, "hasBus": false},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Column(
        children: [
          _buildRouteHeader(context, isDark),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 20),
              itemCount: routePoints.length,
              itemBuilder: (context, index) => _buildRouteStep(
                index,
                routePoints.length,
                routePoints[index],
                isDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteHeader(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20, bottom: 25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1B263B), const Color(0xFF0D1B2A)]
              : [const Color(0xFF3476E1), const Color(0xFF67B0F5)],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: const Column(
        children: [
          Text("Line 1: Campus Loop", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text("Direction: West to East", style: TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildRouteStep(int index, int total, Map<String, dynamic> point, bool isDark) {
    bool isPassed = point['isPassed'];
    bool hasBus = point['hasBus'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Timeline Indicator Logic
            Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isPassed ? const Color(0xFF3476E1) : Colors.grey[300],
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [if (isPassed) const BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                ),
                if (index != total - 1)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isPassed ? const Color(0xFF3476E1) : Colors.grey[300],
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 20),
            // Station Content
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      point['name'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isPassed ? FontWeight.bold : FontWeight.normal,
                        color: isPassed ? (isDark ? Colors.white : Colors.black87) : Colors.grey,
                      ),
                    ),
                    if (hasBus)
                      const Column(
                        children: [
                          Icon(Icons.directions_bus, color: Color(0xFF3476E1), size: 28),
                          Text("BUS HERE", style: TextStyle(color: Color(0xFF3476E1), fontSize: 8, fontWeight: FontWeight.bold)),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}