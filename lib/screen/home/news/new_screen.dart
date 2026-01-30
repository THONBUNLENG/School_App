import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_app/config/app_color.dart';
import 'package:school_app/model/model.dart';
import '../../../api/sever_url_model/sever_url_model.dart';
import '../../../extension/change_notifier.dart';
import 'news_detail_screen.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final bool isDark = themeManager.isDarkMode;

    final Color bgColor = isDark ? AppColor.backgroundColor : const Color(0xFFFBFBFB);
    final Color cardColor = isDark ? AppColor.surfaceColor : Colors.white;
    final Color textColor = isDark ? Colors.white : AppColor.primaryColor;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          // 🔥 ប្រើ Gradient Identity របស់ NJU
          flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: BrandGradient.luxury),
          ),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColor.lightGold, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'UNIVERSITY NEWS',
            style: TextStyle(color: AppColor.lightGold, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.2),
          ),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: AppColor.lightGold, // ប្តូរមកពណ៌មាស
            indicatorWeight: 3,
            labelColor: AppColor.lightGold,
            unselectedLabelColor: Colors.white60,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            tabs: const [
              Tab(text: 'ALL'),
              Tab(text: 'Daily News'),
              Tab(text: 'Announcement'),
              Tab(text: 'Videos'),
            ],
          ),
        ),
        body: Column(
          children: [
            _buildTopBanner(cardColor, isDark),
            Expanded(
              child: TabBarView(
                children: [
                  _buildNewsListFiltered(cardColor, textColor, 'ALL', isDark),
                  _buildNewsListFiltered(cardColor, textColor, 'Daily New', isDark),
                  _buildNewsListFiltered(cardColor, textColor, 'Announcement', isDark),
                  _buildNewsListFiltered(cardColor, textColor, 'Videos', isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Top Banner (Refined with University Branding) ---
  Widget _buildTopBanner(Color cardBg, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border(bottom: BorderSide(color: AppColor.glassBorder, width: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/image/nanjing_book.png',
                height: 110,
                width: 85,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NANJING UNIVERSITY',
                  style: TextStyle(
                      fontWeight: FontWeight.w900, fontSize: 15, color: isDark ? AppColor.lightGold : AppColor.primaryColor),
                ),
                const SizedBox(height: 5),
                const Text('ADMISSION BOOKLET 2026',
                    style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor.withOpacity(0.1),
                      foregroundColor: AppColor.primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: AppColor.primaryColor, width: 0.5)),
                    ),
                    child: const Text('Read More', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- News List with Enhanced Styling ---
  Widget _buildNewsListFiltered(Color cardBg, Color txtCol, String category, bool isDark) {
    return FutureBuilder<List<NewsModel>>(
      future: NewsService().fetchNews(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: AppColor.accentGold));
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text("Error loading news"));
        }

        final filteredNews = category == 'ALL'
            ? snapshot.data!
            : snapshot.data!.where((item) => item.category == category).toList();

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: filteredNews.length,
          separatorBuilder: (context, index) => const SizedBox(height: 15),
          itemBuilder: (context, index) {
            final item = filteredNews[index];
            return InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => NewsDetailScreen(newsItem: item))),
              child: Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColor.glassBorder),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.05), blurRadius: 15, offset: const Offset(0, 8)),
                  ],
                ),
                child: item.category == 'Videos'
                    ? _buildVideoRow(item, txtCol, isDark)
                    : _buildNewsRow(item, txtCol, isDark),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNewsRow(NewsModel item, Color txtCol, bool isDark) {
    return Row(
      children: [
        _buildThumbnail(item, isVideo: false),
        _buildInfoColumn(item, txtCol, isDark),
      ],
    );
  }

  Widget _buildVideoRow(NewsModel item, Color txtCol, bool isDark) {
    return Row(
      children: [
        _buildThumbnail(item, isVideo: true),
        _buildInfoColumn(item, txtCol, isDark),
      ],
    );
  }

  Widget _buildThumbnail(NewsModel item, {required bool isVideo}) {
    final thumb = item.images.isNotEmpty ? item.images.first : '';
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
          child: Image.network(
            thumb,
            width: 130, height: 110,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(width: 130, height: 110, color: Colors.grey[200]),
          ),
        ),
        if (isVideo)
          Container(
            width: 130, height: 110,
            decoration: const BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16))),
            child: const Icon(Icons.play_circle_fill, color: AppColor.lightGold, size: 40),
          ),
      ],
    );
  }

  Widget _buildInfoColumn(NewsModel item, Color txtCol, bool isDark) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? Colors.white : AppColor.primaryColor),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.calendar_today_rounded, size: 12, color: AppColor.accentGold),
                const SizedBox(width: 6),
                Text(item.date, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                const Spacer(),
                const Icon(Icons.remove_red_eye_outlined, size: 12, color: Colors.grey),
                const SizedBox(width: 4),
                Text('${item.views}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}