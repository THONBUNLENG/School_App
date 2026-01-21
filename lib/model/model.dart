class NewsModel {
  final int id;
  final String title;
  final String subtitle;
  final String description;       // short description
  final String longDescription;   // full article
  final List<String> images;
  final String date;
  final int views;
  final String link;
  final String category;          // category: ALL / Daily New / Announcement / Videos

  NewsModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.longDescription,
    required this.images,
    required this.date,
    required this.views,
    required this.link,
    required this.category,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      description: json['description'] ?? '',
      longDescription: json['longDescription'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      date: json['date'] ?? '',
      views: json['views'] ?? 0,
      link: json['link'] ?? '',
      category: json['category'] ?? 'ALL',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'longDescription': longDescription,
      'images': images,
      'date': date,
      'views': views,
      'link': link,
      'category': category,
    };
  }
}
