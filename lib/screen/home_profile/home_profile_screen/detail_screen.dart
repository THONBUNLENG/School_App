import 'package:flutter/material.dart';
import 'package:school_app/config/app_color.dart'; // ប្រើ AppColor & BrandGradient របស់អ្នក
import 'new.dart'; // ប្រាកដថា News Model របស់អ្នកត្រឹមត្រូវ

class NewsDetailScreen extends StatelessWidget {
  final News news;
  const NewsDetailScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColor.backgroundColor : const Color(0xFFFBFBFB),
      appBar: AppBar(
        // 🔥 ប្រើ Gradient Identity របស់ NJU
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: BrandGradient.luxury),
        ),
        title: const Text(
          "NEWS DETAIL",
          style: TextStyle(
              color: AppColor.lightGold,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 1.2
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColor.lightGold, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- ១. Hero Image Section ---
            Hero(
              tag: 'news_image_${news.title}', // ប្រាកដថា Tag នេះដូចគ្នាជាមួយស្គ្រីនបញ្ជីព័ត៌មាន
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                  child: Image.network(
                    news.image,
                    width: double.infinity,
                    height: 280,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 280,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),

            // --- ២. Content Section ---
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 30, 25, 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge ប្រភេទព័ត៌មាន (ប្រសិនបើមាន)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColor.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "UNIVERSITY UPDATE",
                      style: TextStyle(
                        color: AppColor.primaryColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Title
                  Text(
                    news.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : AppColor.primaryColor,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Metadata (Date & Views)
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 14, color: AppColor.accentGold),
                      const SizedBox(width: 8),
                      Text(
                        news.date,
                        style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      const Icon(Icons.share_outlined, size: 18, color: AppColor.accentGold),
                    ],
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 25),
                    child: Divider(height: 1, thickness: 1, color: Colors.white),
                  ),


                  Text(
                    news.content,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.8,
                      color: isDark ? Colors.white70 : Colors.black87,
                      fontFamily: 'Battambang',
                    ),
                  ),

                  const SizedBox(height: 40),

                  _buildShareButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareButton() {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        gradient: BrandGradient.luxury,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          // Logic សម្រាប់ Share
        },
        icon: const Icon(Icons.share_rounded, color: AppColor.lightGold, size: 20),
        label: const Text(
          "SHARE THIS NEWS",
          style: TextStyle(color: AppColor.lightGold, fontWeight: FontWeight.bold, letterSpacing: 1.1),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}