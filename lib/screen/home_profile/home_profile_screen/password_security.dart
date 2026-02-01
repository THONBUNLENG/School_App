import 'package:flutter/material.dart';
import '../../../config/app_color.dart';

class SecurityCenterScreen extends StatelessWidget {
  const SecurityCenterScreen({super.key});

  final Color backgroundDark = const Color(0xFF1B1B1B);
  final List<Color> brandGradient = const [
    Color(0xFF8B2682),
    Color(0xFF81005B),
    Color(0xFFFF005C),
  ];

  final Color cardColor = const Color(0xFF331421);

  @override
  Widget build(BuildContext context) {
    final double avatarRadius = 36;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              brandGradient.first.withOpacity(0.2),
              backgroundDark,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // Sticky header with gradient
            SliverAppBar(
              centerTitle: true,
              flexibleSpace: Container(
                decoration: const BoxDecoration(gradient: BrandGradient.luxury),
              ),
              title: const Text(
                "Personal Data",
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

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 40),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _buildSectionCard(
                        title: "Personal Info",
                        child: ListTile(
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          title: const Text("He Wenlin",
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.w600)),
                          subtitle: const Text("student@nju.edu.cn",
                              style: TextStyle(color: Colors.white70)),
                          trailing: const Icon(Icons.chevron_right, color: Colors.white),
                        ),
                      ),
                      Positioned(
                        top: -avatarRadius,
                        left: MediaQuery.of(context).size.width / 2 - avatarRadius - 16,
                        child: CircleAvatar(
                          radius: avatarRadius,
                          backgroundImage:
                          const NetworkImage("https://scontent.fpnh19-1.fna.fbcdn.net/v/t39.30808-6/565256792_869820712368021_2775110481695495555_n.jpg?stp=dst-jpg_s206x206_tt6&_nc_cat=109&ccb=1-7&_nc_sid=fe5ecc&_nc_ohc=aETkoslTPmMQ7kNvwG46mV0&_nc_oc=AdkkPu-WZakaD75Iq5wUQpq5kBtSLnCdgOV7H5NYk74endTqLQapRIg9Ih6ldgJltTQ&_nc_zt=23&_nc_ht=scontent.fpnh19-1.fna&_nc_gid=Om-11pZeKtMGXs98Oz8nyw&oh=00_AfswhII9esdTEbt1zKgWtFZhQcw0ATYGuyPC3cjap91YcA&oe=698362F5"),
                          backgroundColor: Colors.white,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  _buildSectionCard(
                    title: "Password & Authentication",
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      leading: const Icon(Icons.lock_outline, color: Colors.white),
                      title: const Text(
                        "Last changed: Jan 25, 2026",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      subtitle: const Text(
                        "Edit Profile & Contact Details",
                        style: TextStyle(color: Colors.white70),
                      ),
                      trailing: const Icon(Icons.chevron_right, color: Colors.white),
                    ),
                  ),

                  _buildSectionCard(
                    title: "Your Devices",
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      leading: const Icon(Icons.devices, color: Colors.white),
                      title: const Text("Change Password",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      subtitle: const Text(
                        "Two-Factor Authentication (On)",
                        style: TextStyle(color: Colors.white70),
                      ),
                      trailing: const Icon(Icons.chevron_right, color: Colors.white),
                    ),
                  ),

                  _buildSectionCard(
                    title: "Device Security & Activity",
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      leading: const Icon(Icons.security, color: Colors.white),
                      title: const Text("Login from new location",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      subtitle: const Text(
                        "Tokyo, Japan (1 min ago)",
                        style: TextStyle(color: Colors.white70),
                      ),
                      trailing: const Icon(Icons.chevron_right, color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 30),
                  _buildSecureButton(),
                  const SizedBox(height: 20),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildSecureButton() {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: brandGradient.last,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 6,
          shadowColor: Colors.black45,
        ),
        onPressed: () {},
        child: const Text(
          "Secure Your Account",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
