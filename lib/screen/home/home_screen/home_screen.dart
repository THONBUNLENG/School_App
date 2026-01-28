import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:school_app/config/app_color.dart';
import 'package:school_app/extension/string_extension.dart';
import 'package:school_app/screen/home/home_screen/change_language.dart';
import 'package:school_app/screen/home/website/website_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_localization/flutter_localization.dart';
import '../../../extension/change_notifier.dart';
import '../news/new_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    FlutterLocalization.instance.onTranslatedLanguage = (locale) {
      if (mounted) setState(() {});
    };
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final bool isDark = themeManager.isDarkMode;

    // Colors
    final Color bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color textColor = isDark ? Colors.white : const Color(0xFF333333);
    final Color subTextColor = isDark ? Colors.white70 : Colors.black87;

    // Carousel images
    final List<String> imgList = [
      'https://media.gettyimages.com/id/81632904/photo/nanjing-china-doctoral-graduates-from-the-nanjing-university-pose-for-a-photo-during-the-degree.jpg?s=612x612&w=gi&k=20&c=CrVDHvm8GqmNeiWrJNGShfcUdrQSwNmJihgQDhNTeiU=',
      'https://wentchina.com/wp-content/uploads/2022/07/beb9a30caa486871c7e60ca07b881faf.png',
      'https://math.nju.edu.cn/DFS//file/2020/05/09/20200509142906141v5f1ac.jpg',
      'https://www.fu-berlin.de/studium/international/studium_ausland/direkt/Programme-und-Ausschreibungen/da_china_taiwan/nanjing_university/2024_excursion.jpg?width=4000',
      'https://www.nju.edu.cn/__local/9/0E/EE/95C31227EECC4145D027BCF2847_5F93343F_C6F8.jpg',
      'https://media.istockphoto.com/id/1313715567/photo/the-front-gate-of-nanjing-university.jpg?s=612x612&w=0&k=20&c=UqYE5vszLsCVoBv_yL4DuHLJUF4Kms8faM1mmaiLkGo=',
      'https://www.nju.edu.cn/__local/5/D2/7A/7AB17C9E383016E6CB6BF5E7E43_5857A471_903FE.jpg',
      'https://hwxy.nju.edu.cn/DFS//file/2024/12/06/20241206165052607t3mzi4.jpg?iid=89352',
      'https://scholarshipsfuture.com/wp-content/uploads/2025/10/Nanjing-University-CSC-Scholarship-2026-in-China-Fully-Funded-1024x576.jpg',
      'https://studyinchinas.com/wp-content/uploads/2019/05/Nanjing-University.jpg',
      'https://cscguideofficials.com/wp-content/uploads/2021/09/Nanjing-university-professors-emails-csc-guide-official.png',
      'https://es.nju.edu.cn/_upload/article/images/8b/f0/2aee4ff9413e88bb07e1985d2311/c58589f0-fb50-47b1-92a1-0b70992d90c9.jpg',
    ];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor:AppColor.primaryColor,
        toolbarHeight: 60,
        elevation: 2,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/image/logo.png',
              height: 60,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.school, color:Colors.white, size: 40),
            ),
            const SizedBox(width: 10),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '南京大學',
                  style: TextStyle(
                    fontFamily: 'MaoTi',
                    fontSize: 24,
                    color: Colors.white,
                    letterSpacing: 8,
                  ),
                ),
                Text(
                  'NANJING  UNIVERSITY',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Carousel Slider
            CarouselSlider(
              options: CarouselOptions(
                height: 280.0,
                autoPlay: true,
                viewportFraction: 0.98,
                enlargeCenterPage: true,
                autoPlayInterval: const Duration(seconds: 4),
              ),
              items: imgList.map((item) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: item,
                      width: double.infinity,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[100],
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A2A73)),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            // Marquee
            Container(
              height: 38,
              margin: const EdgeInsets.symmetric(vertical: 0),
              decoration: BoxDecoration(
                color: AppColor.primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Marquee(
                  text: 'Welcome to NANJING UNIVERSITY!  欢迎来到南京大学！',
                  style: const TextStyle(
                    fontFamily: 'MaoTi',
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  blankSpace: 80.0,
                  velocity: 35.0,
                  pauseAfterRound: const Duration(seconds: 1),
                  accelerationDuration: const Duration(seconds: 1),
                  accelerationCurve: Curves.linear,
                ),
              ),
            ),

            // Language Selector
            Padding(
              padding: const EdgeInsets.only(top: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _langIcon(context, '🇺🇸', 'en', subTextColor),
                  _langIcon(context, '🇨🇳', 'zh', subTextColor),
                ],
              ),
            ),

            // Grid Items
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      _gridItem(context, 'news', 'assets/image/new.png', cardColor, textColor),
                      _gridItem(context, 'programs', 'assets/image/book_icon.png', cardColor, textColor),
                      _gridItem(context, 'admission', 'assets/image/admission_icon.png', cardColor, textColor),
                      _gridItem(context, 'fees', 'assets/image/fees_icon.png', cardColor, textColor),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      _gridItem(context, 'history', 'assets/image/history.png', cardColor, textColor),
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            height: 110,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4A2A73),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(isDark ? 0.5 : 0.1),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/image/e_learning_logo.png', height: 40,
                                    errorBuilder: (c, e, s) => const Icon(Icons.computer, color: Colors.white, size: 35)),
                                const SizedBox(height: 5),
                                Text(
                                    'e_learning_title'.tr,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontFamily: 'Battambang', color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)
                                ),
                                Text(
                                    'e_learning_sub'.tr,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w500)
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      _gridItem(context, 'contacts', 'assets/image/contact_icon.png', cardColor, textColor),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      _gridItem(context, 'website', 'assets/image/logo_school.png', cardColor, textColor),
                      _gridItem(context, 'facebook', 'assets/image/fb_icon.png', cardColor, textColor),
                      _gridItem(context, 'youtube', 'assets/image/youtube_icon.png', cardColor, textColor),
                      _gridItem(context, 'jobs', 'assets/image/jobs.png', cardColor, textColor),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _langIcon(BuildContext context, String flag, String code, Color txtCol) {
    bool isSelected = translator.currentLocale?.languageCode == code;

    return InkWell(
      onTap: () {
        if (isSelected) return;

        translator.translate(code);
        if (translator.onTranslatedLanguage != null) {
          translator.onTranslatedLanguage!(Locale(code));
        }
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            Text(flag, style: const TextStyle(fontSize: 22)),
            Text(
               (code == 'en' ? 'english'.tr : 'chinese'.tr),
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? const Color(0xFF00AEEF) : txtCol,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isSelected) Container(height: 2, width: 15, color: const Color(0xFF00AEEF))
          ],
        ),
      ),
    );
  }

  Widget _gridItem(BuildContext context, String labelKey, String imagePath, Color cardBg, Color txtCol) {
    return Expanded(
      child: InkWell(
        onTap: () async {
          Future<void> launchExternalURL(String url) async {
            final Uri uri = Uri.parse(url);
            if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
              debugPrint('Cannot open URL: $url');
            }
          }

          switch (labelKey) {
            case 'news':
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NewsScreen()));
              break;
            case 'admission':
              await launchExternalURL('https://www.beltei.edu.kh/khm/index.php/admission');
              break;
            case 'fees':
              await launchExternalURL('https://www.beltei.edu.kh/khm/index.php/tuition-fee');
              break;
            case 'history':
              await launchExternalURL('https://www.beltei.edu.kh/khm/index.php/about-beltei/history');
              break;
            case 'contacts':
              await launchExternalURL('https://www.beltei.edu.kh/khm/index.php/contact-us');
              break;
            case 'website':
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const NanjingWebView(url: 'https://www.nju.edu.cn/en/'),
              ));
              break;
            case 'facebook':
              await launchExternalURL('https://www.facebook.com/belteiinternationalgroup');
              break;
            case 'youtube':
              await launchExternalURL('https://www.youtube.com/@njusters5239');
              break;
            case 'jobs':
              await launchExternalURL('https://www.beltei.edu.kh/khm/index.php/job-announcement');
              break;
          }
        },
        child: Column(
          children: [
            Container(
              height: 62, width: 62,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cardBg,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (c, e, s) => const Icon(Icons.grid_view_rounded, color: Color(0xFF81005B), size: 25),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 35,
              child: Text(
                labelKey.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Battambang',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: txtCol,
                    height: 1.3
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}