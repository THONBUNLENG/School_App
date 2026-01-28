import 'package:flutter/material.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      body: Column(
        children: [
          _buildSearchHeader(context, isDark),
          Expanded(
            child: _filteredSchedule.isNotEmpty
                ? ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: _filteredSchedule.length,
              itemBuilder: (context, index) =>
                  _buildScheduleCard(_filteredSchedule[index], isDark),
            )
                : const Center(child: Text("No routes found")),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHeader(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        bottom: 25,
        left: 20,
        right: 20,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1A237E), const Color(0xFF0D1B2A)]
              : [const Color(0xFF3476E1), const Color(0xFF67B0F5)],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        children: [
          const Text(
            "Campus Timetable",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          // Search Input Field
          TextField(
            controller: _searchController,
            onChanged: (value) => _runFilter(value),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Search destination...",
              hintStyle: const TextStyle(color: Colors.white54),
              prefixIcon: const Icon(Icons.search, color: Colors.white70),
              filled: true,
              fillColor: Colors.white.withOpacity(0.2),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(Map<String, String> item, bool isDark) {
    // Logic to determine color based on status text
    Color statusColor;
    switch (item['status']?.toLowerCase()) {
      case 'delayed':
        statusColor = Colors.redAccent;
        break;
      case 'departed':
        statusColor = Colors.grey;
        break;
      default:
        statusColor = const Color(0xFF3476E1); // NJU Blue for 'On Time'
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF3476E1),
                ),
              ),
              const Text(
                "Scheduled",
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(width: 20),

          // 2. Vertical Divider
          Container(width: 1, height: 40, color: Colors.grey.withOpacity(0.3)),
          const SizedBox(width: 20),

          // 3. Route Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['route'] ?? "Unknown Route",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 6),
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item['status']?.toUpperCase() ?? "UNKNOWN",
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 4. Notification Toggle
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.grey),
            onPressed: () {
              // Logic for "Remind me 5 minutes before"
            },
          ),
        ],
      ),
    );
  }
}