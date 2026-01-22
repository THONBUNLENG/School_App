import 'package:flutter/material.dart';

const Color nandaPurple = Color(0xFF81005B);

class ManScreenUser extends StatelessWidget {
  const ManScreenUser({super.key});

  bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 140),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              _buildOrientationBanner(),
              _section("Campus Life"),
              _campusLife(context),
              _section("Quick Access"),
              _quickAccess(),
              _section("Announcements"),
              _announcements(context),
            ],
          ),
        ),
      ),
    );
  }

  /* ================= HEADER ================= */

  Widget _buildHeader(BuildContext context) {
    return AppBar(
      backgroundColor: nandaPurple,
      toolbarHeight: 80,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: Hero(
        tag: 'back_button',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () => Navigator.pop(context),
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Icon(Icons.arrow_back_ios_new, color: Colors.white),
            ),
          ),
        ),
      ),
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/image/logo.png',
            height: 50,
            errorBuilder: (_, __, ___) =>
            const Icon(Icons.school, color: Colors.white),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '南京大學',
                style: TextStyle(
                  fontFamily: 'MaoTi',
                  fontSize: 22,
                  color: Colors.white,
                  letterSpacing: 4,
                ),
              ),
              Text(
                'NANJING UNIVERSITY',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /* ================= BANNER ================= */

  Widget _buildOrientationBanner() {
    return Container(
      margin: const EdgeInsets.all(20),
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 12),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/image/background.png',
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(.15),
                    Colors.black.withOpacity(.6),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Orientation Week",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Digital Resources",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* ================= SECTIONS ================= */

  Widget _section(String title) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
    child: Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );

  /* ================= CAMPUS LIFE ================= */

  Widget _campusLife(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _LifeItem(icon: Icons.access_time_filled, label: "Timetable", onTap: () {}),
          _LifeItem(icon: Icons.restaurant, label: "Canteen", onTap: () {}),
          _LifeItem(icon: Icons.menu_book, label: "Library", onTap: () {}),
          _LifeItem(icon: Icons.wifi, label: "Campus WiFi", onTap: () {}),
        ],
      ),
    );
  }

  /* ================= QUICK ACCESS ================= */

  Widget _quickAccess() {
    final icons = [
      Icons.assignment,
      Icons.payments,
      Icons.description,
      Icons.account_balance_wallet,
      Icons.image,
      Icons.location_on,
    ];

    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: icons.length,
        itemBuilder: (_, i) => Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CircleAvatar(
            radius: 24,
            backgroundColor: nandaPurple.withOpacity(.9),
            child: Icon(icons[i], color: Colors.white),
          ),
        ),
      ),
    );
  }

  /* ================= ANNOUNCEMENTS ================= */

  Widget _announcements(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: const [
          Expanded(
            child: _AnnouncementCard(
              text: "System Maintenance\non Oct 26th",
              important: true,
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: _AnnouncementCard(
              text: "Sports Meet\nRegistration Now!",
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= SUPPORT WIDGETS ================= */

class _LifeItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _LifeItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  nandaPurple.withOpacity(0.85),
                  nandaPurple,
                ],
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 6),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  final String text;
  final bool important;

  const _AnnouncementCard({
    required this.text,
    this.important = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 130,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: important
            ? nandaPurple.withOpacity(isDark ? 0.25 : 0.08)
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black45 : Colors.black12,
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (important)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: nandaPurple,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                "IMPORTANT NOTICE",
                style: TextStyle(color: Colors.white, fontSize: 8),
              ),
            ),
          const SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }
}
