import 'package:flutter/material.dart';
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
    const Color nandaPurple = Color(0xFF81005B);
    final item = widget.newsItem;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: nandaPurple,
        title: const Text('News Detail', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildMainMedia(item),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _buildMetadata(item),
                  const Divider(height: 30),
                  Text(item.description, style: const TextStyle(fontSize: 16, height: 1.6)),
                  const SizedBox(height: 30),
                  _buildSwipeGallery(context, item),
                  const SizedBox(height: 30),
                  _buildActionButton(_launchURL, nandaPurple),
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
        const Icon(Icons.access_time, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text(item.date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(width: 15),
        const Icon(Icons.remove_red_eye_outlined, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text('${item.views} views', style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildMainMedia(NewsModel item) {
    if (item.category == 'Videos' && _youtubeController != null) {
      return Hero(
        tag: 'news_${item.id}',
        child: YoutubePlayer(controller: _youtubeController!, showVideoProgressIndicator: true),
      );
    }

    String mainImageUrl = '';
    if (item.images.isNotEmpty) {
      bool isFirstItemVideo = item.images.first.contains('youtu.be') || item.images.first.contains('youtube.com');
      if (isFirstItemVideo && item.images.length > 1) {
        mainImageUrl = item.images[1];
      } else {
        mainImageUrl = item.images.first;
      }
    }

    return Hero(
      tag: 'news_${item.id}',
      child: ClipRRect(
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
        child: Image.network(
          mainImageUrl,
          width: double.infinity,
          height: 250,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            height: 250, color: Colors.grey[300],
            child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeGallery(BuildContext context, NewsModel item) {
    final List<String> onlyImages = item.images.where((url) {
      return !url.toLowerCase().contains('youtube.com') && !url.toLowerCase().contains('youtu.be');
    }).toList();

    if (onlyImages.length <= 1) return const SizedBox.shrink();
    final galleryList = onlyImages.skip(1).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Gallery", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 12),
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
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
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(galleryList.length, (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: _currentPage == index ? 10 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: _currentPage == index ? const Color(0xFF005696) : Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          )),
        ),
      ],
    );
  }

  Widget _buildActionButton(VoidCallback onPressed, Color color) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.language, color: Colors.white),
        label: const Text("Read More on Website", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}