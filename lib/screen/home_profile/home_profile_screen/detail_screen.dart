import 'package:flutter/material.dart';
import 'package:school_app/config/app_color.dart';
import 'package:school_app/model/food.dart';
import 'man_screen_user.dart';
import 'new.dart';


/* ================= SCREEN COMPONENTS ================= */

class DetailScreen extends StatelessWidget {
  final String title;
  const DetailScreen({super.key, required this.title, required Food food, required int cartCount, required void Function(newItem) onAddToCart});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: AppColor.primaryColor, foregroundColor: Colors.white),
      body: Center(child: Text("Welcome to $title Page")),
    );
  }
}

class newItem {
}

class NewsDetailScreen extends StatelessWidget {
  final News news;
  const NewsDetailScreen({super.key, required this.news});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColor.primaryColor, title: const Text("Detail"), foregroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(news.image, width: double.infinity, height: 250, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(news.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(news.date, style: const TextStyle(color: Colors.grey)),
                  const Divider(height: 30),
                  Text(news.content, style: const TextStyle(fontSize: 16, height: 1.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

