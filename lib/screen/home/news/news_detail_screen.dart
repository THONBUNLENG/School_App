import 'package:flutter/material.dart';
import 'package:school_app/model/model.dart';
import 'package:url_launcher/url_launcher.dart';


class NewsDetailScreen extends StatelessWidget {
  final NewsModel newsItem;

  const NewsDetailScreen({super.key, required this.newsItem});


  Future<void> _launchURL() async {
    final Uri url = Uri.parse(newsItem.link);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF005696),
        elevation: 0,
        title: const Text('News Detail', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Hero(
              tag: newsItem.link,
              child: Image.network(
                newsItem.imageUrl,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(height: 250, color: Colors.grey[300], child: const Icon(Icons.broken_image, size: 50)),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    newsItem.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.4),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(newsItem.date, style: const TextStyle(color: Colors.grey)),
                      const SizedBox(width: 20),
                      const Icon(Icons.remove_red_eye_outlined, size: 16, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text('${newsItem.views} views', style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const Divider(height: 30),

                  const Text(
                    "សូមចុចប៊ូតុងខាងក្រោមដើម្បីអានខ្លឹមសារព័ត៌មានទាំងស្រុង និងទស្សនារូបភាពបន្ថែមទៀតនៅលើគេហទំព័រផ្លូវការរបស់សាលា ប៊ែលធី អន្តរជាតិ។",
                    style: TextStyle(fontSize: 15, height: 1.6),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _launchURL,
                      icon: const Icon(Icons.open_in_browser),
                      label: const Text("Read Full Article"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF005696),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}