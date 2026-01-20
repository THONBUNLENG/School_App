import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:school_app/extension/string_extension.dart';
import 'package:school_app/screen/home/home_screen/change_language.dart';
import 'package:school_app/screen/home/website/website_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'change_notifier.dart';
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

    final Color bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final Color textColor = isDark ? Colors.white : const Color(0xFF333333);
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color subTextColor = isDark ? Colors.white70 : Colors.black87;

    final List<String> imgList = [
      'https://www.beltei.edu.kh/storage/app/posters/2/wNckAuLNVvILHTuRjPZA5RK0Mv3wDMjn9FBjQ3fN.jpg',
      'https://www.beltei.edu.kh/storage/app/posters/2/ZjnHN5q8iuTz97HhGwr0v4eZjk2JLdmUZxpCbh0A.jpg',
      'https://www.beltei.edu.kh/storage/app/posters/2/7xBuoScsqs10cFnVLgQxGdgd1czZfzRwxAk7Q7er.jpg',
      'https://www.beltei.edu.kh/storage/app/posters/2/PtUGAevEWZ3xdcYMnN7o2ICxis00XRlGUugGw1FY.jpg',
      'https://www.beltei.edu.kh/uploaded/university/news/images/482/681a3edc-a.jpg',
      'https://scontent.fpnh19-1.fna.fbcdn.net/v/t39.30808-6/489884761_1087968210037789_5723458033536820815_n.jpg?stp=dst-jpg_p526x296_tt6&_nc_cat=111&ccb=1-7&_nc_sid=833d8c&_nc_ohc=J3ziCV9GQQYQ7kNvwHkOB04&_nc_oc=Adk0QOilBFKnYka3o9RPc3KZDn4u8XQdTY6ikN94_wRcRlY4FLtOAPijqD-ggaULnxE&_nc_zt=23&_nc_ht=scontent.fpnh19-1.fna&_nc_gid=5gtrS3rraISW6T7UqoD8kQ&oh=00_Afr_6-_zN_vdUzJSyCUHh1Bky-tl9rtD9Cj0F4ERQgrA6w&oe=697262E8',
      'https://scontent.fpnh19-1.fna.fbcdn.net/v/t39.30808-6/596204014_1302377595261586_4224572311210693712_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=833d8c&_nc_ohc=SZOw-VpftnIQ7kNvwGzaMH8&_nc_oc=AdmVQxEq1NrCkXfWu5HCaV165eD_PIAocEa-xm4V_MMya1E3q_I2ZG9eD6LbeKTiWfU&_nc_zt=23&_nc_ht=scontent.fpnh19-1.fna&_nc_gid=XrcOJGFigyA9LmM4VWqi7w&oh=00_Afo1_I4BbglzbhFBBRrQRqe3O-BAhYUISVAxpb4rW66b0w&oe=69726470',
      'https://scontent.fpnh19-1.fna.fbcdn.net/v/t39.30808-6/586598395_1276119004556041_3596077203540924878_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=127cfc&_nc_ohc=A82UMZJdbc4Q7kNvwEGRzyN&_nc_oc=Adlsjolf1CNxMfTtK75QEJEhVzbK6e7qvEhsvcyzfexvg8tLMuZ7nGGzns7Km7eSrx4&_nc_zt=23&_nc_ht=scontent.fpnh19-1.fna&_nc_gid=9XGQn8VWaiMa0fFnvBESzw&oh=00_AfpSiN5iNNfbOKp30h0PJwbaSHl2w4kl7RF8pRsDOf9PMQ&oe=697271A8',
      'https://www.beltei.edu.kh/asset/img/school/campus/school-B3.jpg',
      'https://www.beltei.edu.kh/asset/img/school/campus/school-B30.jpg',
    ];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF005696),
        toolbarHeight: 60,
        elevation: 2,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/image/logo_beltel_school.png',
              height: 40,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.school, color: Colors.white, size: 40),
            ),
            const SizedBox(width: 10),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('សាលា ប៊ែលធី អន្តរជាតិ',
                    style: TextStyle(fontSize: 14, fontFamily: 'Battambang', fontWeight: FontWeight.bold, color: Colors.white)),
                Text('BELTEI INTERNATIONAL SCHOOL',
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)),
                Text('贝  蒂   国  际   学   校',
                    style: TextStyle(fontSize: 11, color: Colors.white, letterSpacing: 2)),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
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
                    color: Colors.white,
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
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF005696)),
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

            Container(
              height: 38,
              margin: const EdgeInsets.symmetric(vertical: 0),
              decoration: BoxDecoration(
                color: const Color(0xFF005696),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Marquee(
                  text: 'សាលា ប៊ែលធី អន្តរជាតិជាគុណភាពអប់រំល្អបំផុតនៅកម្ពុជា!  BELTEI, The Best Quality of Education in Cambodia!   BELTEI 柬埔寨最優質的教育！',
                  style: const TextStyle(
                    fontFamily: 'Battambang',
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

            //Language Selector
            Padding(
              padding: const EdgeInsets.only(top: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _langIcon(context, '🇰🇭', 'km', subTextColor),
                  _langIcon(context, '🇺🇸', 'en', subTextColor),
                  _langIcon(context, '🇨🇳', 'zh', subTextColor),
                ],
              ),
            ),

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
                              color: const Color(0xFF0086C2),
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
                      _gridItem(context, 'website', 'assets/image/logo_beltel_group.png', cardColor, textColor),
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
              code == 'km' ? 'khmer'.tr : (code == 'en' ? 'english'.tr : 'chinese'.tr),
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
              debugPrint('មិនអាចបើក Link: $url');
            }
          }

          if (labelKey == 'news') {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const NewsScreen()));
          }
          else if (labelKey == 'admission') {
            await launchExternalURL('https://www.beltei.edu.kh/khm/index.php/admission');
          }
          else if (labelKey == 'fees') {
            await launchExternalURL('https://www.beltei.edu.kh/khm/index.php/tuition-fee');
          }
          else if (labelKey == 'history') {
            await launchExternalURL('https://www.beltei.edu.kh/khm/index.php/about-beltei/history');
          }
          else if (labelKey == 'contacts') {
            await launchExternalURL('https://www.beltei.edu.kh/khm/index.php/contact-us');
          }
          else if (labelKey == 'website') {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => const BelteiWebView(url: 'https://www.belteigroup.com.kh'),
            ));
          }
          else if (labelKey == 'facebook') {
            await launchExternalURL('https://www.facebook.com/belteiinternationalgroup');
          }
          else if (labelKey == 'youtube') {
            await launchExternalURL('https://www.youtube.com/@belteigroup');
          }
          else if (labelKey == 'jobs') {
            await launchExternalURL('https://www.beltei.edu.kh/khm/index.php/job-announcement');
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
                  errorBuilder: (c, e, s) => const Icon(Icons.grid_view_rounded, color: Color(0xFF005696), size: 25),
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