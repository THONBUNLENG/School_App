

class News {
  final String title, date, image, category, content;
  News({
    required this.title,
    required this.date,
    required this.image,
    required this.category,
    this.content = "Detailed information about this event will be shown here...",
  });
}

final List<News> newsList = [
  News(
    title: "Nanjing University Welcome New Students for 2026",
    date: "2026-01-20",
    image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ8whZAQMvtKZodhoEC9HszojChiLe_yjdTGg&s",
    category: "Education",
  ),
  News(
    title: "New Achievement in AI Research at NJU",
    date: "2026-01-18",
    image: "https://as.nju.edu.cn/_upload/article/images/94/40/b5f5440b44fa8fd6385ec86b508e/0c7ef2e7-1a31-4921-bd8f-ed17fc154716.jpg",
    category: "Technology",
  ),
  News(
    title: "Nanjing University - Chinese Government Scholarship",
    date: "Deadline: Nov 1, 2025 – Jan 20, 2026",
    image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEfHm2TGEtylp0jF12YWuXJdH5t1ckky75vA&s",
    category: "Scholarship",
  ),
];

final List<Map<String, dynamic>> announcementData = [
  {"text": "Nanjing University\nExchange Programme", "important": true, "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQR9HX1Y0gzH6-0WJ7vIaAUJAszwTljktom3w&s"},
  {"text": "System Update\nMaintenance", "important": true, "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTIbEOJI-nT_XAzHfX5HGyfmT0tS3adkSLxXg&s"},
  {"text": "Library Hours\nExtended", "important": false, "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR5OV1Zr5Aw1EVCLVQzYSoTkS3frODB8KMWgA&s"},
];