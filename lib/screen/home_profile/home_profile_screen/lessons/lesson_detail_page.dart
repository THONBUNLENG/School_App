import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:school_app/config/app_color.dart'; // ប្រើ AppColor & BrandGradient របស់អ្នក

class LessonDetailPage extends StatefulWidget {
  final Map<String, dynamic> lesson;

  const LessonDetailPage({super.key, required this.lesson});

  @override
  State<LessonDetailPage> createState() => _LessonDetailPageState();
}

class _LessonDetailPageState extends State<LessonDetailPage> {
  late VideoPlayerController _controller;
  bool _isVideoReady = false;

  @override
  void initState() {
    super.initState();
    // ប្រើ networkUrl សម្រាប់ Flutter កំណែថ្មី
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.lesson['videoUrl'] ?? ''))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isVideoReady = true;
          });
          _controller.pause();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
        title: Text(
          widget.lesson['title']?.toUpperCase() ?? 'LESSON DETAIL',
          style: const TextStyle(
            fontSize: 16,
            color: AppColor.lightGold,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- ១. Video Player Section (Luxury Frame) ---
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: _isVideoReady
                    ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      VideoPlayer(_controller),
                      _VideoControlsOverlay(controller: _controller),
                      VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true,
                        colors: const VideoProgressColors(
                          playedColor: AppColor.accentGold,
                          bufferedColor: Colors.white24,
                          backgroundColor: Colors.white10,
                        ),
                      ),
                    ],
                  ),
                )
                    : Container(
                  height: 220,
                  width: double.infinity,
                  color: isDark ? AppColor.surfaceColor : Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(color: AppColor.accentGold),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // --- ២. Teacher Info Card (Glassmorphism) ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColor.surfaceColor : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColor.glassBorder),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(color: AppColor.lightGold, shape: BoxShape.circle),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white24,
                      backgroundImage: NetworkImage(widget.lesson['teacherImage'] ?? ''),
                      onBackgroundImageError: (_, __) => const Icon(Icons.person, size: 30),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.lesson['teacher'] ?? 'Academic Professor',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColor.lightGold : AppColor.primaryColor,
                          ),
                        ),
                        const Text(
                          'Nanjing University Faculty',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // --- ៣. Lesson Description ---
            Row(
              children: [
                const Icon(Icons.description_outlined, color: AppColor.accentGold, size: 20),
                const SizedBox(width: 8),
                Text(
                  "LESSON DESCRIPTION",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : AppColor.primaryColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? AppColor.surfaceColor.withOpacity(0.5) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColor.glassBorder),
              ),
              child: Text(
                widget.lesson['description'] ?? 'No description available.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: isDark ? Colors.white70 : Colors.black87,
                  fontFamily: 'Battambang',
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _VideoControlsOverlay extends StatefulWidget {
  final VideoPlayerController controller;

  const _VideoControlsOverlay({required this.controller});

  @override
  State<_VideoControlsOverlay> createState() => _VideoControlsOverlayState();
}

class _VideoControlsOverlayState extends State<_VideoControlsOverlay> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.controller.value.isPlaying
              ? widget.controller.pause()
              : widget.controller.play();
        });
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: widget.controller.value.isPlaying
            ? const SizedBox.shrink()
            : Container(
          color: Colors.black45,
          child: const Center(
            child: Icon(
              Icons.play_circle_fill_rounded,
              color: AppColor.lightGold,
              size: 70,
            ),
          ),
        ),
      ),
    );
  }
}