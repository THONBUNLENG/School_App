import 'package:flutter/material.dart';
import 'package:school_app/config/app_color.dart';


class LifeItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final VoidCallback onTap;

  const LifeItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      // Adding splash color to match our brand gold
      splashColor: AppColor.accentGold.withOpacity(0.1),
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              // Using a deeper opacity for dark mode to create depth
              color: isDark
                  ? AppColor.primaryColor.withOpacity(0.15)
                  : AppColor.primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(18),
              // Sublte border makes it look like a high-end interface
              border: Border.all(
                color: AppColor.accentGold.withOpacity(isDark ? 0.1 : 0.05),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              // FIXED: Changed from Primary Purple to Gold for better brand contrast
              color: AppColor.accentGold,
              size: 28,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600, // Slightly bolder for readability
              color: isDark ? Colors.white70 : Colors.black87,
              letterSpacing: 0.3,
            ),
          ),
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
        border: Border.all(color: important ? AppColor.primaryColor.withOpacity(0.5) : Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (important) const Icon(Icons.info, color:AppColor.primaryColor, size: 16),
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