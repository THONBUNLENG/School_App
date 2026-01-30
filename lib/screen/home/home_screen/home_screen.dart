import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:school_app/config/app_color.dart';
import 'package:school_app/extension/string_extension.dart';
import 'package:school_app/screen/home/admission/admission.dart';
import 'package:school_app/screen/home/contacts/contacts.dart';
import 'package:school_app/screen/home/history/history.dart';
import 'package:school_app/screen/home/home_screen/change_language.dart';
import 'package:school_app/screen/home/job/job.dart';
import 'package:school_app/screen/home/schools_department/schools_department.dart';
import 'package:school_app/screen/home/website/website_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_localization/flutter_localization.dart';
import '../../../extension/change_notifier.dart';
import '../main_programs/main_programs.dart';
import '../news/new_screen.dart';
import '../scholarship/scholarship.dart';
import '../tuition_fees/tution_fees_screen.dart';

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
    final Color _ = isDark ? const Color(0xFF121212) : Colors.white;
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
      backgroundColor: isDark ? AppColor.backgroundColor : const Color(0xFFFBFBFB),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: BrandGradient.luxury),
        ),
        toolbarHeight: 75,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/image/logo.png',
              height: 55,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.school, color: AppColor.lightGold, size: 40),
            ),
            const SizedBox(width: 15),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '南京大學',
                  style: TextStyle(
                    fontFamily: 'MaoTi',
                    fontSize: 24,
                    color: AppColor.lightGold,
                    letterSpacing: 6,
                  ),
                ),
                const Text(
                  'NANJING UNIVERSITY',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: Colors.white70,
                    letterSpacing: 1.2,
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
            // --- Carousel Slider ---
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 220.0,
                  autoPlay: true,
                  viewportFraction: 0.92,
                  enlargeCenterPage: true,
                  autoPlayInterval: const Duration(seconds: 5),
                ),
                items: imgList.map((item) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl: item,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(color: Colors.white),
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
            ),

            // --- Marquee News Bar ---
        Container(
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          decoration: BoxDecoration(
            color: isDark
                ? AppColor.surfaceColor.withOpacity(0.5)
                : AppColor.primaryColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isDark
                  ? AppColor.lightGold.withOpacity(0.2)
                  : AppColor.primaryColor.withOpacity(0.1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 15),
              const Icon(
                  Icons.campaign_rounded,
                  color: AppColor.accentGold,
                  size: 20
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Marquee(
                  text: 'Welcome to NANJING UNIVERSITY!  欢迎来到南京大学！   •   ',
                  style: TextStyle(
                    color: isDark ? AppColor.lightGold : AppColor.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                  blankSpace: 100.0,
                  velocity: 35.0,
                  pauseAfterRound: const Duration(seconds: 2),
                  startPadding: 10.0,
                  accelerationDuration: const Duration(seconds: 1),
                  accelerationCurve: Curves.linear,
                ),
              ),
              const SizedBox(width: 15),
            ],
          ),
        ),

            // Language Selector
            Padding(
              padding: const EdgeInsets.only(top: 12, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _langIcon(context, '🇺🇸', 'en', subTextColor),
                  const SizedBox(width: 10),
                  _langIcon(context, '🇨🇳', 'zh', subTextColor),
                ],
              ),
            ),

            // --- Grid Menu Items ---
            Padding(
              padding: const EdgeInsets.all(15.0),
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
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const  SchoolsDepartment(url: 'https://www.nju.edu.cn/en/Institution/Schools_Departments.htm'),
                            ));
                          },
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            height: 110,
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                              gradient: BrandGradient.luxury,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.primaryColor.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/image/e_learning_logo.png', height: 40,
                                    errorBuilder: (c, e, s) => const Icon(Icons.laptop_chromebook, color: AppColor.lightGold, size: 35)),
                                const SizedBox(height: 8),
                                Text(
                                    'Schools & Department',
                                    style: const TextStyle(color: AppColor.lightGold, fontSize: 11, fontWeight: FontWeight.bold)
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
                      _gridItem(context, 'Scholarship', 'assets/image/scholarship.png', cardColor, textColor),
                      _gridItem(context, 'youtube', 'assets/image/youtube_icon.png', cardColor, textColor),
                      _gridItem(context, 'job openings', 'assets/image/jobs.png', cardColor, textColor),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _langIcon(BuildContext context, String flag, String code, Color txtCol) {
    bool isSelected = translator.currentLocale?.languageCode == code;

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        if (isSelected) return;

        translator.translate(code);
        if (translator.onTranslatedLanguage != null) {
          translator.onTranslatedLanguage!(Locale(code));
        }
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(
              (code == 'en' ? 'english'.tr : 'chinese'.tr),
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? AppColor.lightGold : txtCol.withOpacity(0.6),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 2.5,
              width: isSelected ? 20 : 0,
              decoration: BoxDecoration(
                color: AppColor.lightGold,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: AppColor.accentGold.withOpacity(0.4),
                      blurRadius: 4,
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _gridItem(BuildContext context, String labelKey, String imagePath, Color cardBg, Color txtCol) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: InkWell(
        splashColor: AppColor.primaryColor.withOpacity(0.1),
        highlightColor: Colors.transparent,
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
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const  Admission(url: 'https://www.nju.edu.cn/en/Admission.htm'),
              ));
              break;
            case 'fees':
              Navigator.push(context, MaterialPageRoute(builder: (context) => const TuitionPage ()));
              break;
            case 'history':
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const  History(url: 'https://www.nju.edu.cn/en/About/NJU_at_a_Glance/History.htm'),
              ));
              break;
            case 'contacts':
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const Contacts(),
              ));
              break;
            case 'website':
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const NanjingWebView(url: 'https://www.nju.edu.cn/en/'),
              ));
              break;
            case 'Scholarship':
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const Scholarship(url: 'https://hwxy.nju.edu.cn/English/StudyatNJU/Scholarships/ChineseGovernmentScholarship/20230414/i242759.html'),
              ));
              break;
            case 'youtube':
              await launchExternalURL('https://www.youtube.com/@njusters5239');
              break;
            case 'job openings':
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const Job(url: 'https://www.nju.edu.cn/en/Job_Openings.htm'),
              ));
              break;
            case 'programs':
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const  MainPrograms(url: 'https://hwxy.nju.edu.cn/English/StudyatNJU/Admissions/BachelorsPrograms/index.html'),
              ));
              break;
          }
        },
        child: Column(
          children: [
            Container(
              height: 65, width: 65,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cardBg,
                border: Border.all(color: AppColor.glassBorder, width: 1.5),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 6)
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (c, e, s) => const Icon(
                      Icons.grid_view_rounded,
                      color: AppColor.accentGold,
                      size: 25
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // --- Label Text ---
            SizedBox(
              height: 38,
              child: Text(
                labelKey.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Battambang',
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white70 : AppColor.primaryColor,
                    height: 1.2,
                    letterSpacing: 0.2
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}