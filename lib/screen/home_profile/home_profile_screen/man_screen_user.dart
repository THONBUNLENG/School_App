import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_app/campus_life/library_screen.dart' hide nandaPurple;
import 'package:school_app/campus_life/timetable_screen.dart' hide nandaPurple;
import 'package:school_app/campus_life/wifi_screen.dart' hide nandaPurple;
import 'package:school_app/config/app_color.dart';
import 'package:school_app/screen/home/home_screen/main_holder.dart';
import 'package:school_app/screen/home_profile/home_profile_screen/setting.dart' hide nandaPurple;
import 'package:shimmer/shimmer.dart';
import '../../../campus_life/canteen/menu_screen.dart';
import '../../../extension/change_notifier.dart';
import '../../../quick_access/ net_transfer_page/net_transfer_page.dart';
import '../../../quick_access/campus_bus/campus_bus_screen.dart';
import '../../../quick_access/campus_bus/man_bus.dart';
import '../../../quick_access/campus_code/campus_code_page.dart';
import '../../../quick_access/electricity/electricity_page.dart';
import '../../../quick_access/empty_rooms/empty_rooms.dart';
import '../../../quick_access/gpa_grades/gpa_grades.dart';
import '../../../quick_access/repair_hub/main_navigation.dart';
import '../../../quick_access/topup/net_topup_page.dart';
import '../../../quick_access/wallet/wallet_add_card.dart';
import '../edit_profile.dart';
import 'list_item.dart';
import 'new.dart';


class ManScreenUser extends StatefulWidget {
  const ManScreenUser({super.key});

  @override
  State<ManScreenUser> createState() => _ManScreenUserState();
}

class _ManScreenUserState extends State<ManScreenUser> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _isLoading = false);
  }


  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final bool isDarkMode = themeManager.isDarkMode;

    final Color bgColor = isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
    final Color textColor = isDarkMode ? Colors.white : Colors.black87;
    final Color cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: RefreshIndicator(
        color:AppColor.accentGold,
        onRefresh: _fetchNews,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            _buildSliverAppBar(isDarkMode),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrientationBanner(),
                  _section("Campus Life", textColor),
                  _campusLife(context, isDarkMode),
                  _section("Quick Access", textColor),
                  _quickAccess(textColor),
                  _section("Announcements", textColor),
                  _announcements(context, cardColor, textColor),
                  _section("News Updates", textColor),
                ],
              ),
            ),
            _isLoading
                ? _buildSliverShimmer(isDarkMode)
                : _buildSliverNewsList(newsList, cardColor, textColor),
            const SliverToBoxAdapter(child: SizedBox(height: 50)),
          ],
        ),
      ),
    );
  }

  // --- Widget Functions ---

  Widget _buildSliverAppBar(bool isDarkMode) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 80.0,
      backgroundColor: AppColor.primaryColor,
      centerTitle: true,
      title: const Text(
          '南京大學',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MainHolder())
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {

          },
        ),
        IconButton(
          icon: Icon(
              isDarkMode ? Icons.settings_rounded : Icons.settings_outlined,
              color: Colors.white
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingApp()),
          ),
        ),
      ],
    );
  }

  Widget _section(String title, Color color) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 25, 20, 12),
    child: Text(title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: color)),
  );

  Widget _buildOrientationBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [

            Positioned.fill(
              child: Image.network(
                'https://www.stonybrook.edu/commcms/studyabroad/_images/outgoing-banner-images/all-year-website-photos/china/nanjing-banner.png',
                fit: BoxFit.cover,
              ),
            ),


            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      AppColor.primaryColor.withOpacity(0.9),
                      AppColor.primaryColor.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "ADMISSION 2026",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Orientation Day",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Full guide for new NJU students",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      letterSpacing: 0.5,
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

  Widget _campusLife(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LifeItem(
            icon: Icons.access_time,
            label: "Timetable",
            isDark: isDark,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NanjingTimetable(
                    url: 'https://hwxy.nju.edu.cn/English/Academics/AcademicCalendar/Timetables/index.html',
                  ),
                ),
              );
            },
          ),
          LifeItem(
            icon: Icons.restaurant,
            label: "Canteen",
            isDark: isDark,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MenuScreen(
                  ),
                ),
              );
            },
          ),
          LifeItem(
            icon: Icons.book,
            label: "Library",
            isDark: isDark,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NanjingLibrary(
                    url: 'https://njunju.nju.edu.cn/EN/5073/list.htm',
                  ),
                ),
              );
            },
          ),
          LifeItem(
            icon: Icons.wifi,
            label: "WiFi",
            isDark: isDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NanjingWifi(
                      url: 'https://stuex.nju.edu.cn/en_/NJUAPPwSingleSignwonAccount/list.htm',
                    ),
                  ),
                );
              },
          ),
        ],
      ),
    );
  }

  Widget _quickAccess(Color textColor) {
    final List<Map<String, dynamic>> itemsList = [
      {"icon": Icons.swap_horiz, "label": "Net Transfer", "color": Colors.blue, "page":NetTransfersPage ()},
      {"icon": Icons.account_balance_wallet, "label": "Net Balance", "color": Colors.orange, "page": WalletScreen (title: '',)},
      {"icon": Icons.add_circle, "label": "Net Top-up", "color": Colors.green, "page": TopUpWallet()},
      {"icon": Icons.email, "label": "Email Edit", "color": Colors.purple, "page": EditProfileStudent()},
      {"icon": Icons.qr_code_scanner, "label": "Campus Code", "color": Colors.red, "page": QrScannerScreen ()},
       {"icon": Icons.event_available, "label": "Empty Rooms", "color": Colors.teal, "page": EmptyRoomsPage(url: 'https://stuex.nju.edu.cn/en_/wousing/list.htm',)},
      {"icon": Icons.electric_bolt, "label": "Electricity", "color": Colors.amber, "page": ElectricityPage(url: 'https://ese.nju.edu.cn/ese_en/main.psp',)},
       {"icon": Icons.assignment, "label": "GPA/Grades", "color": Colors.indigo, "page":  GradesScreen()},
       {"icon": Icons.support_agent, "label": "Repair Hub", "color": Colors.pink, "page":MainNavigation ()},
       {"icon": Icons.directions_bus, "label": "Campus Bus", "color": Colors.cyan, "page": Main_Bus ()},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: itemsList.length,
      itemBuilder: (context, i) {
        final item = itemsList[i];
        return GestureDetector(
          onTap: () {
            if (item['page'] != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => item['page']),
              );
            }
          },
          child: Column(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: (item['color'] as Color).withOpacity(0.1),
                child: Icon(item['icon'], color: item['color'], size: 20),
              ),
              const SizedBox(height: 4),
              Text(
                item['label'],
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 9, color: textColor),
              ),
            ],
          ),
        );
      },
    );
  }
  Widget _announcements(BuildContext context, Color cardColor, Color textColor) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: announcementData.length,
        itemBuilder: (context, index) => Container(
          width: 250,
          margin: const EdgeInsets.only(right: 12),
          child: AnnouncementCard(
            text: announcementData[index]['text'],
            important: announcementData[index]['important'],
            imageUrl: announcementData[index]['image'],
            cardColor: cardColor,
            textColor: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildSliverNewsList(List<News> list, Color cardColor, Color textColor) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 260,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: list.length,
          itemBuilder: (context, index) => Container(
            width: 280,
            margin: const EdgeInsets.only(right: 15),
            child: Card(
              color: cardColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.network(list[index].image, height: 140, width: double.infinity, fit: BoxFit.cover),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(list[index].category, style: const TextStyle(color:AppColor.primaryColor, fontWeight: FontWeight.bold, fontSize: 10)),
                        Text(list[index].title, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliverShimmer(bool isDark) {
    return SliverToBoxAdapter(
      child: Shimmer.fromColors(
        baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
        highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
        child: Container(height: 200, margin: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15))),
      ),
    );
  }
}