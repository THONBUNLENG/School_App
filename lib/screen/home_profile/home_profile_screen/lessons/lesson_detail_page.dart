import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// ------------------- LESSON DETAIL PAGE -------------------
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
    _controller = VideoPlayerController.network(widget.lesson['videoUrl'] ?? '')
      ..initialize().then((_) {
        setState(() {
          _isVideoReady = true;
        });
        _controller.pause();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson['title'] ?? 'Lesson'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Teacher info
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage:
                  NetworkImage(widget.lesson['teacherImage'] ?? ''),
                  onBackgroundImageError: (_, __) =>
                  const Icon(Icons.person, size: 30),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.lesson['teacher'] ?? 'Unknown Teacher',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Lesson description
            Text(
              widget.lesson['description'] ?? 'No description available.',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 20),

            // Video player
            _isVideoReady
                ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  VideoPlayer(_controller),
                  _VideoControlsOverlay(controller: _controller),
                  VideoProgressIndicator(_controller, allowScrubbing: true),
                ],
              ),
            )
                : Container(
              height: 200,
              color: Colors.black12,
              child: const Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoControlsOverlay extends StatelessWidget {
  final VideoPlayerController controller;

  const _VideoControlsOverlay({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.value.isPlaying ? controller.pause() : controller.play();
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: controller.value.isPlaying
            ? const SizedBox.shrink()
            : Container(
          color: Colors.black26,
          child: const Center(
            child: Icon(
              Icons.play_circle,
              color: Colors.white,
              size: 60,
            ),
          ),
        ),
      ),
    );
  }
}
