import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_color.dart';
import '../../extension/change_notifier.dart';
import '../../extension/string_extension.dart';
import 'booking.dart';


class TimetableView extends StatefulWidget {
  const TimetableView({super.key});

  @override
  State<TimetableView> createState() => _TimetableViewState();
}

class _TimetableViewState extends State<TimetableView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  final List<Map<String, dynamic>> _schedules = const [
    {"time": "08:00", "route": "Xianlin ➔ Gulou", "status": "Departed", "seats": 0, "type": "Morning"},
    {"time": "08:30", "route": "Xianlin ➔ Gulou", "status": "On Time", "seats": 12, "type": "Morning"},
    {"time": "09:00", "route": "Xianlin ➔ Pukou", "status": "On Time", "seats": 5, "type": "Morning"},
    {"time": "14:30", "route": "Gulou ➔ Xianlin", "status": "On Time", "seats": 20, "type": "Evening"},
    {"time": "17:00", "route": "Pukou ➔ Xianlin", "status": "Delayed", "seats": 8, "type": "Evening"},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeManager>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColor.backgroundColor : const Color(0xFFF8F9FA),
      body: Column(
        children: [
          _buildTopHeader(context, isDark),
          _buildTabSwitcher(isDark),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildScheduleList("Morning", isDark),
                _buildScheduleList("Evening", isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10, bottom: 20, left: 20, right: 20),
      decoration: BoxDecoration(
        gradient: BrandGradient.luxury,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(35)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text("Bus Timetable".tr, style: const TextStyle(color: AppColor.lightGold, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(width: 40),
            ],
          ),
          const SizedBox(height: 15),
          _buildSearchBar(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(15)),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
        decoration: InputDecoration(
          hintText: "Search the goal ...".tr,
          hintStyle: const TextStyle(color: Colors.white54, fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: AppColor.lightGold),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(icon: const Icon(Icons.clear, color: Colors.white54), onPressed: () {
            _searchController.clear();
            setState(() => _searchQuery = "");
          })
              : null,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildTabSwitcher(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 45,
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppColor.primaryColor,
        labelColor: isDark ? AppColor.lightGold : AppColor.primaryColor,
        unselectedLabelColor: Colors.grey,
        indicatorSize: TabBarIndicatorSize.label,
        tabs: [Tab(text: "Morning".tr), Tab(text: "Evening".tr)],
      ),
    );
  }

  Widget _buildScheduleList(String type, bool isDark) {
    final list = _schedules.where((item) {
      final matchesType = item['type'] == type;
      final matchesSearch = item['route'].toLowerCase().contains(_searchQuery);
      return matchesType && matchesSearch;
    }).toList();

    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_bus_filled_outlined, size: 80, color: Colors.grey.withOpacity(0.3)),
            const SizedBox(height: 10),
            Text("No results found".tr, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        return InkWell( // ប្រើ InkWell ដើម្បីឱ្យមាន Ripple Effect ពេលចុច
          onTap: item['seats'] > 0
              ? () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SeatBookingView(busInfo: item))
          )
              : null,
          child: _buildScheduleCard(item, isDark),
        );
      },
    );
  }

  Widget _buildScheduleCard(Map<String, dynamic> item, bool isDark) {
    bool isFull = item['seats'] == 0;
    Color statusColor = item['status'] == "Delayed" ? Colors.red : (isFull ? Colors.grey : AppColor.brandOrange);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColor.surfaceColor : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          _buildTimeColumn(item, isDark),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['route'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildBadge(item['status'], statusColor),
                    const SizedBox(width: 8),
                    _buildBadge("${item['seats']} Seats Left", isFull ? Colors.grey : Colors.green),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
        ],
      ),
    );
  }

  Widget _buildTimeColumn(Map<String, dynamic> item, bool isDark) {
    return Column(
      children: [
        Text(item['time'], style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColor.primaryColor)),
        const Text("DEPART", style: TextStyle(fontSize: 9, color: Colors.grey, letterSpacing: 1)),
      ],
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(text.toUpperCase(), style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }
}