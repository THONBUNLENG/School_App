import 'package:flutter/material.dart';

const Color nandaPurple = Color(0xFF81005B);

class LifeItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final VoidCallback onTap;

  const LifeItem({super.key, required this.icon, required this.label, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: nandaPurple.withOpacity(0.1), borderRadius: BorderRadius.circular(18)),
            child: Icon(icon, color: nandaPurple, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: isDark ? Colors.white70 : Colors.black87)),
        ],
      ),
    );
  }
}

class AnnouncementCard extends StatelessWidget {
  final String text;
  final bool important;
  final String imageUrl;
  final Color cardColor;
  final Color textColor;

  const AnnouncementCard({super.key, required this.text, required this.important, required this.imageUrl, required this.cardColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: important ? nandaPurple.withOpacity(0.5) : Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (important) const Icon(Icons.info, color: nandaPurple, size: 16),
                Text(text, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textColor)),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(imageUrl, width: 60, height: 60, fit: BoxFit.cover),
          ),
        ],
      ),
    );
  }
}