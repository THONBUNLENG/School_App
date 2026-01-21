// news_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_app/model/model.dart';
import 'package:school_app/model/sever_url_model/sever_url_model.dart';
import '../home_screen/change_notifier.dart';
import 'news_detail_screen.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final bool isDark = themeManager.isDarkMode;

    final Color bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5);
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    const Color primaryBlue = Color(0xFF005696);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: primaryBlue,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'News',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Color(0xFF00AEEF),
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'ALL'),
              Tab(text: 'Daily New'),
              Tab(text: 'Announcement'),
              Tab(text: 'Videos'),
            ],
          ),
        ),
        body: Column(
          children: [
            _buildTopBanner(cardColor, textColor),
            const Divider(height: 1, thickness: 1),
            Expanded(
              child: TabBarView(
                children: [
                  _buildNewsListFiltered(cardColor, textColor, 'ALL'),
                  _buildNewsListFiltered(cardColor, textColor, 'Daily New'),
                  _buildNewsListFiltered(cardColor, textColor, 'Announcement'),
                  _buildNewsListFiltered(cardColor, textColor, 'Videos'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Top Banner ---
  Widget _buildTopBanner(Color cardBg, Color txtCol) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: cardBg,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.asset(
              'assets/image/beltil_bok.png',
              height: 100,
              width: 70,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 100,
                width: 70,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BELTEI INTERNATIONAL SCHOOL',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14, color: txtCol),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                const Text('BOOKLET', style: TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomRight,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text('Read More', style: TextStyle(fontSize: 11, color: txtCol)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Filtered News List per Tab ---
  Widget _buildNewsListFiltered(Color cardBg, Color txtCol, String category) {
    return FutureBuilder<List<NewsModel>>(
      future: NewsService().fetchNews(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("មិនមានទិន្នន័យ"));
        }

        final allNews = snapshot.data!;
        final filteredNews = category == 'ALL'
            ? allNews
            : allNews.where((item) => item.category == category).toList();

        if (filteredNews.isEmpty) {
          return const Center(child: Text("មិនមានទិន្នន័យសម្រាប់ប្រភេទនេះ"));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: filteredNews.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = filteredNews[index];
            final isVideo = item.category == 'Videos' && item.link.isNotEmpty;

            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NewsDetailScreen(newsItem: item),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: item.category == 'Videos' && item.link.isNotEmpty
                    ? _buildVideoRow(item, cardBg, txtCol)
                    : _buildNewsRow(item, cardBg, txtCol),

              ),
            );
          },
        );
      },
    );
  }

  // --- Standard News Row ---
  Widget _buildNewsRow(NewsModel item, Color cardBg, Color txtCol) {
    return Row(
      children: [
        Hero(
          tag: 'news_${item.id}',
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Image.network(
              item.images.isNotEmpty ? item.images.first : '',
              width: 130,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(
                    width: 130,
                    height: 100,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.subtitle.isNotEmpty ? item.subtitle : item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13, color: txtCol),
                ),
                const SizedBox(height: 5),
                Text(
                  item.date,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.remove_red_eye_outlined,
                        size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('${item.views} views',
                        style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

// --- Video Row (like standard news row) ---
  Widget _buildVideoRow(NewsModel item, Color cardBg, Color txtCol) {
    return Row(
      children: [
        // Thumbnail with play icon overlay
        Hero(
          tag: 'news_${item.id}',
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: Image.network(
                  item.images.isNotEmpty ? item.images.first : '',
                  width: 130,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 130,
                    height: 100,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black45,
                    ),
                    child: const Icon(
                      Icons.play_circle_outline,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Text info (title, date, views)
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.subtitle.isNotEmpty ? item.subtitle : item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13, color: txtCol),
                ),
                const SizedBox(height: 5),
                Text(
                  item.date,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.remove_red_eye_outlined,
                        size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('${item.views} views',
                        style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

}
