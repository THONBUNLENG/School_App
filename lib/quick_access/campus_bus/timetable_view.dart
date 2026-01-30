import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_color.dart'; // ប្រើ AppColor & BrandGradient របស់អ្នក
import '../../extension/change_notifier.dart';
import '../../extension/string_extension.dart'; // សម្រាប់ check isDarkMode

class TimetableView extends StatefulWidget {
  const TimetableView({super.key});

  @override
  State<TimetableView> createState() => _TimetableViewState();
}

class _TimetableViewState extends State<TimetableView> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _allSchedule = const [
    {"time": "08:00", "route": "Xianlin ➔ Gulou", "status": "Departed"},
    {"time": "08:30", "route": "Xianlin ➔ Gulou", "status": "On Time"},
    {"time": "09:00", "route": "Xianlin ➔ Pukou", "status": "On Time"},
    {"time": "09:30", "route": "Xianlin ➔ Gulou", "status": "Delayed"},
  ];

  List<Map<String, String>> _filteredSchedule = [];

  @override
  void initState() {
    super.initState();
    _filteredSchedule = _allSchedule;
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, String>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allSchedule;
    } else {
      results = _allSchedule
          .where((bus) => bus["route"]!
          .toLowerCase()
          .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _filteredSchedule = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeManager>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColor.backgroundColor : const Color(0xFFFBFBFB),
      body: Column(
        children: [
          _buildSearchHeader(context, isDark),
          Expanded(
            child: _filteredSchedule.isNotEmpty
                ? ListView.builder(
              padding: const EdgeInsets.only(top: 20, bottom: 100), // បន្ថែម space សម្រាប់ Bottom Nav
              itemCount: _filteredSchedule.length,
              itemBuilder: (context, index) =>
                  _buildScheduleCard(_filteredSchedule[index], isDark),
            )
                : Center(
              child: Text(
                "No routes found".tr,
                style: TextStyle(color: isDark ? Colors.white54 : Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHeader(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        bottom: 30,
        left: 20,
        right: 20,
      ),
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
            "Campus Timetable".tr,
            style: const TextStyle(
              color: AppColor.lightGold, // ពណ៌មាស Premium
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 20),
          // Search Input Field
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _runFilter(value),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search destination...".tr,
                hintStyle: const TextStyle(color: Colors.white54, fontSize: 14),
                prefixIcon: const Icon(Icons.search_rounded, color: AppColor.lightGold),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: AppColor.glassBorder),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(Map<String, String> item, bool isDark) {
    Color statusColor;
    switch (item['status']?.toLowerCase()) {
      case 'delayed':
        statusColor = Colors.redAccent;
        break;
      case 'departed':
        statusColor = isDark ? Colors.white24 : Colors.grey.shade400;
        break;
      default:
        statusColor = AppColor.brandOrange; // ប្រើពណ៌ទឹកក្រូចសម្រាប់ On Time ឱ្យលេចធ្លោ
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColor.surfaceColor : Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColor.glassBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Row(
        children: [
          // 1. Time Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['time'] ?? "--:--",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: isDark ? AppColor.lightGold : AppColor.primaryColor,
                ),
              ),
              const Text(
                "DEPARTURE",
                style: TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
            ],
          ),
          const SizedBox(width: 20),

          // 2. Vertical Divider
          Container(width: 1.5, height: 45, color: AppColor.glassBorder),
          const SizedBox(width: 20),

          // 3. Route Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['route'] ?? "Unknown Route",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: statusColor.withOpacity(0.2)),
                  ),
                  child: Text(
                    item['status']?.toUpperCase() ?? "UNKNOWN",
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 4. Notification Toggle
          Container(
            decoration: BoxDecoration(
              color: AppColor.primaryColor.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.notifications_active_outlined,
                  color: isDark ? Colors.white38 : Colors.grey.shade400, size: 20),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}