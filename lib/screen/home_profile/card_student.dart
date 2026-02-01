import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:school_app/config/app_color.dart';

class CampusCardHeader extends StatelessWidget {
  const CampusCardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
      padding: const EdgeInsets.all(22),
      height: 210,
      decoration: BoxDecoration(
        gradient: BrandGradient.luxury,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryColor.withOpacity(0.35),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
        image: const DecorationImage(
          image: NetworkImage(
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQZNIyvggDhiIM7pCEnNZMFUq9XC5cLjcNehg&s",
          ),
          opacity: 0.08,
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "南京大学",
                    style: TextStyle(
                      color: AppColor.lightGold, // ពណ៌មាស
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                      fontFamily: 'MaoTi',
                    ),
                  ),
                  Text(
                    "NANJING UNIVERSITY",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              // បន្ថែម Icon Chip ឱ្យដូចកាតពិត
              Column(
                children: [
                  Icon(Icons.nfc_rounded, color: AppColor.lightGold.withOpacity(0.5), size: 20),
                  const Text(
                    "CAMPUS CARD",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // --- រូបថតនិស្សិតជាមួយស៊ុមមាស ---
              Container(
                width: 70,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColor.lightGold.withOpacity(0.5), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: "https://scontent.fpnh19-1.fna.fbcdn.net/v/t39.30808-6/565256792_869820712368021_2775110481695495555_n.jpg?stp=dst-jpg_s206x206_tt6&_nc_cat=109&ccb=1-7&_nc_sid=fe5ecc&_nc_ohc=Gw8XA4kWnoYQ7kNvwExYIwu&_nc_oc=AdnOTMQyfWOLB_BheKEu5XTcy7QxFX7ZkZdd8bMbnd1rMSQcCoZp87h02O44LaMDPNs&_nc_zt=23&_nc_ht=scontent.fpnh19-1.fna&_nc_gid=7PJE6NZ8oU9kqXNiHwVOJA&oh=00_AfquH0V8VDa1gz_R6Jf0FZqVxTQDK_aV4b2Grzuwp1TaMQ&oe=697FA6B5",
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppColor.accentGold)),
                    errorWidget: (context, url, error) => const Icon(Icons.person, color: Colors.white30),
                  ),
                ),
              ),
              const SizedBox(width: 18),
              // --- ព័ត៌មាននិស្សិត ---
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "何 文霖 (HE WENLIN)",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 6),
                    _InfoRow(label: "ID", value: "210065"),
                    SizedBox(height: 4),
                    _InfoRow(label: "MAJOR", value: "Computer Science"),
                  ],
                ),
              ),
              // chip icon ពណ៌មាស
              Container(
                width: 35,
                height: 25,
                decoration: BoxDecoration(
                  gradient: BrandGradient.goldMetallic,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "$label : ",
          style: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}