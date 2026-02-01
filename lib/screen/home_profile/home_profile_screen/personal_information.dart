import 'package:flutter/material.dart';
import 'package:school_app/screen/home_profile/home_profile_screen/password_security.dart';
import 'package:school_app/screen/home_profile/home_profile_screen/personal_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/app_color.dart';
import '../../home/home_screen/menu_screen/logout.dart';

class AppleIDSettings extends StatefulWidget {
  const AppleIDSettings({super.key});

  @override
  State<AppleIDSettings> createState() => _AppleIDSettingsState();
}

class _AppleIDSettingsState extends State<AppleIDSettings> {
  String _userName = "Loading...";
  String _userEmail = "...";

  final Color primaryBrand = const Color(0xFF81005B);
  final Color backgroundDark = const Color(0xFF1B1B1B);
  final List<Color> brandGradient = [
    const Color(0xFF8B2682),
    const Color(0xFF81005B),
    const Color(0xFFFF005C),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? "He Wenlin";
      _userEmail = prefs.getString('user_email') ?? "student@nju.edu.cn";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDark,
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: BrandGradient.luxury),
        ),
        title: const Text(
          "Personal Information",
          style: TextStyle(
              color: AppColor.lightGold,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              letterSpacing: 1.2
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColor.lightGold, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topRight,
            radius: 1.5,
            colors: [primaryBrand.withOpacity(0.15), backgroundDark],
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildProfileHeader(),
              const SizedBox(height: 35),
              _buildSettingsList(),
              const SizedBox(height: 40),
              _buildSignOutButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {

    const String profileUrl = "https://scontent.fpnh19-1.fna.fbcdn.net/v/t39.30808-6/565256792_869820712368021_2775110481695495555_n.jpg?stp=dst-jpg_s206x206_tt6&_nc_cat=109&ccb=1-7&_nc_sid=fe5ecc&_nc_ohc=aETkoslTPmMQ7kNvwG46mV0&_nc_oc=AdkkPu-WZakaD75Iq5wUQpq5kBtSLnCdgOV7H5NYk74endTqLQapRIg9Ih6ldgJltTQ&_nc_zt=23&_nc_ht=scontent.fpnh19-1.fna&_nc_gid=Om-11pZeKtMGXs98Oz8nyw&oh=00_AfswhII9esdTEbt1zKgWtFZhQcw0ATYGuyPC3cjap91YcA&oe=698362F5";

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(3.5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: brandGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                  color: primaryBrand.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2
              )
            ],
          ),
          child: CircleAvatar(
            radius: 52,
            backgroundColor: backgroundDark,
            backgroundImage: profileUrl.isNotEmpty
                ? const NetworkImage(profileUrl)
                : null,
            child: profileUrl.isEmpty
                ? const Icon(Icons.person_rounded, size: 60, color: Colors.white)
                : null,
          ),
        ),
        const SizedBox(height: 18),
        Text(
            _userName,
            style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.5
            )
        ),
        const SizedBox(height: 4),
        Text(
            _userEmail,
            style: TextStyle(
                fontSize: 15,
                color: Colors.white.withOpacity(0.5),
                fontWeight: FontWeight.w400
            )
        ),
      ],
    );
  }

  Widget _buildSettingsList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        children: [
          _buildMenuTile(
            "Name, Phone Numbers, Email",
            Icons.person_outline_rounded,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PersonalDataScreen()),
              );
            },
          ),
          _buildDivider(),
          _buildMenuTile(
            "Password & Security",
            Icons.lock_outline_rounded,
            onTap: () {
              Navigator.push(context,
              MaterialPageRoute(builder:(context)=> SecurityCenterScreen ()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSignOutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => LogoutDialog.show(context),
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: brandGradient[2].withOpacity(0.1),
            border: Border.all(color: brandGradient[2].withOpacity(0.5), width: 1.2),
          ),
          child: Center(
            child: Text("Sign Out",
                style: TextStyle(color: brandGradient[2], fontSize: 17, fontWeight: FontWeight.w800, letterSpacing: 1)),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuTile(String title, IconData icon, {String? trailingText, VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap, // បន្ថែមមុខងារចុចនៅទីនេះ
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Icon(icon, color: brandGradient[0].withOpacity(0.8), size: 22),
      title: Text(title, style: const TextStyle(fontSize: 15.5, color: Colors.white, fontWeight: FontWeight.w500)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(trailingText, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.white.withOpacity(0.2)),
        ],
      ),
    );
  }

  Widget _buildDivider() => Divider(height: 1, color: Colors.white.withOpacity(0.05), indent: 55, endIndent: 20);
}