import 'package:flutter/material.dart';
import 'package:school_app/config/app_color.dart'; // ប្រើ AppColor & BrandGradient របស់អ្នក
import 'package:school_app/model/model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NewsDetailScreen extends StatefulWidget {
  final NewsModel newsItem;

  const NewsDetailScreen({super.key, required this.newsItem});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  int _currentPage = 0;
  late PageController _pageController;
  YoutubePlayerController? _youtubeController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);

    if (widget.newsItem.category == 'Videos' && widget.newsItem.link.isNotEmpty) {
      final videoId = YoutubePlayer.convertUrlToId(widget.newsItem.link);
      if (videoId != null) {
        _youtubeController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
        );
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _youtubeController?.dispose();
    super.dispose();
  }

  Future<void> _launchURL() async {
    final Uri url = Uri.parse(widget.newsItem.link);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint("Could not launch $url");
    }
  }

  void _openImageZoom(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierColor: Colors.black,
      builder: (_) => GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: Image.network(imageUrl, fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final item = widget.newsItem;

    return Scaffold(
      backgroundColor: isDark ? AppColor.backgroundColor : const Color(0xFFFBFBFB),
      appBar: AppBar(
        // 🔥 ប្រើ Gradient Identity របស់ NJU
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: BrandGradient.luxury),
        ),
        title: const Text(
            'NEWS DETAIL',
            style: TextStyle(color: AppColor.lightGold, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.2)
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColor.lightGold, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildMainMedia(item),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      item.title,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : AppColor.primaryColor,
                          height: 1.3
                      )
                  ),
                  const SizedBox(height: 15),
                  _buildMetadata(item),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Divider(height: 1, thickness: 1, color: Colors.white),
                  ),
                  Text(
                      item.description,
                      style: TextStyle(
                          fontSize: 15,
                          height: 1.8,
                          color: isDark ? Colors.white70 : Colors.black87,
                          fontFamily: 'Battambang'
                      )
                  ),
                  const SizedBox(height: 35),
                  _buildSwipeGallery(context, item, isDark),
                  const SizedBox(height: 40),
                  _buildActionButton(_launchURL),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadata(NewsModel item) {
    return Row(
      children: [
        const Icon(Icons.calendar_today_rounded, size: 14, color: AppColor.accentGold),
        const SizedBox(width: 6),
        Text(item.date, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(width: 20),
        const Icon(Icons.remove_red_eye_rounded, size: 16, color: Colors.grey),
        const SizedBox(width: 6),
        Text('${item.views} views', style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildMainMedia(NewsModel item) {
    if (item.category == 'Videos' && _youtubeController != null) {
      return Hero(
        tag: 'news_${item.id}',
        child: YoutubePlayer(
          controller: _youtubeController!,
          showVideoProgressIndicator: true,
          progressIndicatorColor: AppColor.accentGold,
        ),
      );
    }

    String mainImageUrl = '';
    if (item.images.isNotEmpty) {
      bool isFirstItemVideo = item.images.first.contains('youtu.be') || item.images.first.contains('youtube.com');
      mainImageUrl = (isFirstItemVideo && item.images.length > 1) ? item.images[1] : item.images.first;
    }

    return Hero(
      tag: 'news_${item.id}',
      child: Container(
        decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 5))]
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
          child: Image.network(
            mainImageUrl,
            width: double.infinity,
            height: 260,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 260, color: Colors.grey[200],
              child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeGallery(BuildContext context, NewsModel item, bool isDark) {
    final List<String> onlyImages = item.images.where((url) {
      return !url.toLowerCase().contains('youtube.com') && !url.toLowerCase().contains('youtu.be');
    }).toList();

    if (onlyImages.length <= 1) return const SizedBox.shrink();
    final galleryList = onlyImages.skip(1).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.photo_library_rounded, color: AppColor.accentGold, size: 20),
            const SizedBox(width: 8),
            Text(
                "IMAGE GALLERY",
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    color: isDark ? AppColor.lightGold : AppColor.primaryColor,
                    letterSpacing: 1.0
                )
            ),
          ],
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _pageController,
            itemCount: galleryList.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) {
              final imageUrl = galleryList[index];
              return GestureDetector(
                onTap: () => _openImageZoom(context, imageUrl),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColor.glassBorder),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))]
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => Container(color: Colors.grey[200], child: const Icon(Icons.broken_image, color: Colors.grey)),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(galleryList.length, (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: _currentPage == index ? 20 : 8,
            height: 6,
            decoration: BoxDecoration(
              color: _currentPage == index ? AppColor.accentGold : Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          )),
        ),
      ],
    );
  }

  Widget _buildActionButton(VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        gradient: BrandGradient.luxury,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: AppColor.primaryColor.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.public_rounded, color: AppColor.lightGold, size: 20),
        label: const Text(
            "READ FULL ARTICLE",
            style: TextStyle(color: AppColor.lightGold, fontWeight: FontWeight.bold, letterSpacing: 1.1)
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