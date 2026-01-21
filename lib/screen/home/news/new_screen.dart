import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_app/model/model.dart';
// Ensure this path is correct based on your project structure
import 'package:school_app/model/sever_url_model/sever_url_model.dart';
import '../home_screen/change_notifier.dart';
import 'news_detail_screen.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access theme state
    final themeManager = Provider.of<ThemeManager>(context);
    final bool isDark = themeManager.isDarkMode;

    // Define dynamic colors based on theme
    final Color bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5);
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    const Color nandaPurple = Color(0xFF81005B);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: nandaPurple,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'News',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor:Color(0xFF81005B),
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

  // --- Top Banner (Refined Layout) ---
  Widget _buildTopBanner(Color cardBg, Color txtCol) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: cardBg,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/image/nanjing_book.png',
              height: 100,
              width: 75,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 100,
                width: 75,
                color: Colors.grey[300],
                child: const Icon(Icons.menu_book, color: Colors.grey),
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
                const Text('BOOKLET',
                    style: TextStyle(fontSize: 12, color: Colors.grey, letterSpacing: 1.2)),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                    height: 30,
                    child: OutlinedButton(
                      onPressed: () {
                        // Action for booklet
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Text('Read More',
                          style: TextStyle(fontSize: 11, color: txtCol)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Filtered News List (Optimized Fetching) ---
  Widget _buildNewsListFiltered(Color cardBg, Color txtCol, String category) {
    return FutureBuilder<List<NewsModel>>(
      future: NewsService().fetchNews(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF81005B)));
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Error loading data"));
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

            return InkWell(
              borderRadius: BorderRadius.circular(12),
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
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                // Conditional UI based on Category
                child: item.category == 'Videos'
                    ? _buildVideoRow(item, cardBg, txtCol)
                    : _buildNewsRow(item, cardBg, txtCol),
              ),
            );
          },
        );
      },
    );
  }

  // --- Helper: Logic for Thumbnail (Handles your YouTube Link Issue) ---
  String _getValidThumbnail(NewsModel item) {
    if (item.images.isEmpty) return '';
    // If first image is a YouTube link, try to use the second one
    if (item.images.first.contains('youtu.be') || item.images.first.contains('youtube.com')) {
      return item.images.length > 1 ? item.images[1] : '';
    }
    return item.images.first;
  }

  // --- Standard News Row ---
  Widget _buildNewsRow(NewsModel item, Color cardBg, Color txtCol) {
    final thumb = _getValidThumbnail(item);

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
              thumb,
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
        ),
        _buildInfoColumn(item, txtCol),
      ],
    );
  }

  Widget _buildVideoRow(NewsModel item, Color cardBg, Color txtCol) {
    final thumb = _getValidThumbnail(item);

    return Row(
      children: [
        Hero(
          tag: 'news_${item.id}',
          child: Stack(
            alignment: Alignment.center, // ប្រើ Alignment របស់ Flutter ផ្ទាល់
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: Image.network(
                  thumb,
                  width: 130,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 130,
                    height: 100,
                    color: Colors.grey[200],
                    child: const Icon(Icons.videocam_off, color: Colors.grey),
                  ),
                ),
              ),
              Container(
                width: 130,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: const Icon(
                  Icons.play_circle_fill,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ],
          ),
        ),
        _buildInfoColumn(item, txtCol),
      ],
    );
  }
  
  Widget _buildInfoColumn(NewsModel item, Color txtCol) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              item.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 13, color: txtCol),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.calendar_month, size: 12, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  item.date,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.visibility_outlined, size: 12, color: Colors.grey),
                const SizedBox(width: 4),
                Text('${item.views} views',
                    style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}