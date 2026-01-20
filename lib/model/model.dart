class NewsModel {
  final int id;
  final String title;
  final String imageUrl;
  final String date;
  final int views;
  final String link;

  NewsModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.date,
    required this.views,
    required this.link,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      imageUrl: json['image_url'] ?? '',
      date: json['date'] ?? '',
      views: json['views'] ?? 0,
      link: json['link'] ?? '',
    );
  }
}