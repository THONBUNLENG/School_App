import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyQrScreen extends StatelessWidget {
  const MyQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color(0xFF81005B);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage(
              "assets/image/img_bc.png",
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.darken,
            ),
          ),
        ),
        child: Column(
          children: [
            AppBar(
              title: const Text("My QR Code", style: TextStyle(color: Colors.white)),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
            ),

            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // --- QR CARD ---
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E1E1E) : Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Profile Info
                            const CircleAvatar(
                              radius: 35,
                              backgroundColor: Color(0xFF81005B),
                              child: CircleAvatar(
                                radius: 32,
                                backgroundImage: NetworkImage("https://scontent.fpnh19-1.fna.fbcdn.net/v/t39.30808-6/565256792_869820712368021_2775110481695495555_n.jpg?stp=dst-jpg_s206x206_tt6&_nc_cat=109&ccb=1-7&_nc_sid=fe5ecc&_nc_ohc=K9NmnfrV6VEQ7kNvwFyygHf&_nc_oc=Adnxy44aKN3VODMFFOUty1W7HnHm007aK5SyNMU_BoX9bW-uiLX5C1HMtzZnq8FMzOU&_nc_zt=23&_nc_ht=scontent.fpnh19-1.fna&_nc_gid=tCXfLjKrpi-cHZ0LJjdy_A&oh=00_AfoUoIkEmAjPAs7-u9NooHyfhKqfExQOZ3l3YazHV8D-9g&oe=69790F35"),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "何 文霖",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            const Text(
                              "ID: 007 276 457",
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            const SizedBox(height: 25),

                            // QR Image Placeholder
                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Image.asset(
                                "assets/image/qr_acc.png",
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),

                            const SizedBox(height: 25),
                            const Text(
                              "Scan to pay or transfer money",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Actions Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _qrActionButton(Icons.download, "Save", () {}),
                          const SizedBox(width: 40),
                          _qrActionButton(Icons.share, "Share", () {}),
                          const SizedBox(width: 40),
                          _qrActionButton(Icons.copy, "Copy Link", () {
                            Clipboard.setData(const ClipboardData(text: "007276457"));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("ID Copied!")),
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _qrActionButton(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}