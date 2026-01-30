import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_color.dart'; // ប្រើ AppColor & BrandGradient របស់អ្នក
import '../../extension/change_notifier.dart';
import '../../extension/string_extension.dart'; // សម្រាប់ check isDarkMode

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
    final isDark = Provider.of<ThemeManager>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColor.backgroundColor : const Color(0xFFFBFBFB),
      body: Column(
        children: [
          _buildRouteHeader(context, isDark),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 30),
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
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20, bottom: 35),
      decoration: BoxDecoration(
        // 🔥 ប្រើ Gradient ពណ៌ស្វាយដិត Identity របស់ NJU
        gradient: BrandGradient.luxury,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            "Line 1: Campus Loop".tr,
            style: const TextStyle(
              color: AppColor.lightGold,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Direction: West to East",
            style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteStep(int index, int total, Map<String, dynamic> point, bool isDark) {
    bool isPassed = point['isPassed'];
    bool hasBus = point['hasBus'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // --- Timeline Indicator ---
            Column(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: isPassed ? AppColor.accentGold : (isDark ? Colors.white12 : Colors.grey[300]),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: isPassed ? AppColor.lightGold : (isDark ? Colors.white24 : Colors.white),
                        width: 3
                    ),
                    boxShadow: [
                      if (isPassed)
                        BoxShadow(color: AppColor.accentGold.withOpacity(0.4), blurRadius: 8, spreadRadius: 2)
                    ],
                  ),
                ),
                if (index != total - 1)
                  Expanded(
                    child: Container(
                      width: 3,
                      decoration: BoxDecoration(
                        color: isPassed ? AppColor.accentGold.withOpacity(0.5) : (isDark ? Colors.white12 : Colors.grey[200]),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 25),

            // --- Station Content ---
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(bottom: 35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        point['name'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isPassed ? FontWeight.bold : FontWeight.w500,
                          color: isPassed
                              ? (isDark ? Colors.white : AppColor.primaryColor)
                              : (isDark ? Colors.white38 : Colors.grey.shade400),
                        ),
                      ),
                    ),
                    if (hasBus)
                      _buildBusIndicator(isDark),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusIndicator(bool isDark) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColor.brandOrange.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.directions_bus_rounded, color: Colors.orange, size: 24),
        ),
        const SizedBox(height: 4),
        const Text(
            "BUS HERE",
            style: TextStyle(color: Colors.orange, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 0.5)
        ),
      ],
    );
  }
}