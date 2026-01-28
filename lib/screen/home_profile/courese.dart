import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


/// ------------------ COURSE PAGE ------------------
class CoursePageFix extends StatefulWidget {
  const CoursePageFix({super.key});

  @override
  State<CoursePageFix> createState() => _CoursePageFixState();
}

class _CoursePageFixState extends State<CoursePageFix> {
  int _selectedSemester = 1;
  String _searchQuery = "";
  bool _isDark = false;

  final List<Map<String, dynamic>> _courses = [
    {
      "name": "Chinese Language",
      "code": "CN181",
      "teacher": "Li Yang",
      "progress": 0.99,
      "color": Colors.orange,
      "sem": 1,
      "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcROU_tnTEdMZZ_Q7zl6wq5LMme5TdvfReg06g&s",
      "videoUrl": "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4",
      "chapters": [
        "Chapter 1: Basics",
        "Chapter 2: Grammar",
        "Chapter 3: Conversation Practice",
      ]
    },
    {
      "name": "Java Programming",
      "code": "JAVA101",
      "teacher": "Dr. Wang",
      "progress": 0.85,
      "color": Colors.orange,
      "sem": 1,
      "image": "https://miro.medium.com/0*gtY-llyEbkeoS1Sp.png",
      "videoUrl": "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4",
      "chapters": [
        "Chapter 1: Intro to Java",
        "Chapter 2: OOP Concepts",
        "Chapter 3: Project Work",
      ]
    },
    {
      "name": "C# .NET Development",
      "code": "CSHARP201",
      "teacher": "Prof. Li",
      "progress": 0.60,
      "color": Colors.purple,
      "sem": 1,
      "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQlsjyVsfA2CTQMtzbTLcyFHKB9gEnbJgPRFQ&s",
      "videoUrl": "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4",
      "chapters": [
        "Chapter 1: Setup & Basics",
        "Chapter 2: ASP.NET Core",
        "Chapter 3: CRUD Operations",
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    final bgColor = _isDark ? const Color(0xFF0F172A) : const Color(0xFFF4F6F8);

    final filtered = _courses.where((c) {
      return c['sem'] == _selectedSemester &&
          c['name'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Sticky header
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyHeaderDelegate(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "My Courses",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: _isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildSearchBar(),
                  ],
                ),
                minHeight: 136,
                maxHeight: 136,
              ),
            ),

            // Semester filter
            SliverToBoxAdapter(child: _buildSemesterFilter()),

            // Course list
            filtered.isEmpty
                ? SliverFillRemaining(
              hasScrollBody: false,
              child: _buildEmptyState(),
            )
                : SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, i) => _buildCourseCard(filtered[i]),
                childCount: filtered.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: TextField(
        onChanged: (v) => setState(() => _searchQuery = v),
        style: TextStyle(color: _isDark ? Colors.white : Colors.black87),
        decoration: InputDecoration(
          hintText: "Search semester courses",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: _isDark ? Colors.white10 : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildSemesterFilter() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: 4,
        itemBuilder: (context, i) {
          final isSelected = (i + 1) == _selectedSemester;
          return GestureDetector(
            onTap: () => setState(() => _selectedSemester = i + 1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF2B8BC6)
                    : _isDark
                    ? Colors.white10
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
                    : [],
              ),
              child: Center(
                child: Text(
                  "Sem ${i + 1}",
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : _isDark
                        ? Colors.white70
                        : Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> course) {
    final String? img = course['image'];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        color: _isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isDark ? Colors.white10 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showDetails(course),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (img != null && img.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  img,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 140,
                      color: Colors.grey.shade300,
                      child: const Center(child: Icon(Icons.broken_image, size: 40)),
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(
                    "${course['teacher']} • ${course['code']}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: course['progress'],
                      color: course['color'],
                      backgroundColor: course['color'].withOpacity(0.15),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "${(course['progress'] * 100).toInt()}% completed",
                      style: TextStyle(
                        color: course['color'],
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetails(Map<String, dynamic> course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LessonDetailPage(
          lesson: {
            'title': course['name'],
            'teacher': course['teacher'],
            'teacherImage': course['image'],
            'description': "Learn the basics and advanced concepts of ${course['name']}.",
            'videoUrl': course['videoUrl'],
            'chapters': course['chapters'],
            'isDark': _isDark,
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.search_off, size: 60, color: Colors.grey),
          SizedBox(height: 10),
          Text("No courses found", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double minHeight;
  final double maxHeight;

  _StickyHeaderDelegate(this.child, {required this.minHeight, required this.maxHeight});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(color: Colors.transparent, child: child);
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}

/// ------------------ LESSON DETAIL PAGE ------------------
class LessonDetailPage extends StatefulWidget {
  final Map<String, dynamic> lesson;
  const LessonDetailPage({super.key, required this.lesson});

  @override
  State<LessonDetailPage> createState() => _LessonDetailPageState();
}

class _LessonDetailPageState extends State<LessonDetailPage> with WidgetsBindingObserver {
  late VideoPlayerController _controller;
  bool _isVideoReady = false;
  bool _isDark = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _isDark = widget.lesson['isDark'] ?? false;
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
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      _controller.pause(); // Auto-pause when leaving the page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDark ? const Color(0xFF0F172A) : Colors.white,
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
                  backgroundImage: NetworkImage(widget.lesson['teacherImage'] ?? ''),
                  onBackgroundImageError: (_, __) => const Icon(Icons.person, size: 30),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.lesson['teacher'] ?? 'Unknown Teacher',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Lesson description
            Text(
              widget.lesson['description'] ?? 'No description available.',
              style: TextStyle(
                fontSize: 14,
                color: _isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Chapters
            if (widget.lesson['chapters'] != null)
              ...List<Widget>.from(
                widget.lesson['chapters'].map(
                      (chapter) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, size: 18, color: Colors.green),
                        const SizedBox(width: 10),
                        Text(
                          chapter,
                          style: TextStyle(fontSize: 14, color: _isDark ? Colors.white70 : Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),
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
