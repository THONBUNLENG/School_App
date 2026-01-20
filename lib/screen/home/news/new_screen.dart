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
          title: const Text('News', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
          actions: [
            IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {}),
          ],
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Color(0xFF00AEEF),
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: const [
              Tab(text: 'Khmer News'),
              Tab(text: 'English News'),
              Tab(text: 'News in Chinese'),
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
                  _buildNewsList(cardColor, textColor, isDark),
                  _buildNewsList(cardColor, textColor, isDark),
                  _buildNewsList(cardColor, textColor, isDark),
                  _buildNewsList(cardColor, textColor, isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
                height: 100, width: 70, color: Colors.grey[300],
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: txtCol),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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

  Widget _buildNewsList(Color cardBg, Color txtCol, bool isDark) {
    return FutureBuilder<List<NewsModel>>(
      future: NewsService().fetchNews(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_off, size: 40, color: Colors.grey),
                const SizedBox(height: 10),
                Text("Error: ពិនិត្យការតភ្ជាប់ Internet", style: TextStyle(color: txtCol)),
                TextButton(
                  onPressed: () => (context as Element).markNeedsBuild(),
                  child: const Text("ព្យាយាមម្តងទៀត"),
                )
              ],
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("មិនមានទិន្នន័យ"));
        }

        final newsData = snapshot.data!;
        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: newsData.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = newsData[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsDetailScreen(newsItem: item),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
                  ],
                ),
                child: Row(
                  children: [
                    Hero(
                      tag: 'news_${item.id}',
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                        child: Image.network(
                          item.imageUrl,
                          width: 120, height: 90, fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 120, height: 90, color: Colors.grey[200],
                            child: const Icon(Icons.image_not_supported, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: txtCol),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 12, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(item.date, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                const Spacer(),
                                const Icon(Icons.remove_red_eye_outlined, size: 12, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text('${item.views} views', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}