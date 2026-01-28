import 'package:flutter/material.dart';
import 'package:school_app/config/app_color.dart';
import '../../api/api_repair_hub.dart';
import 'service_button.dart';

class RepairHubScreen extends StatefulWidget {
  const RepairHubScreen({super.key});

  @override
  State<RepairHubScreen> createState() => _RepairHubScreenState();
}

class _RepairHubScreenState extends State<RepairHubScreen> {
  String statusText = "Loading...";
  double progress = 0.0;
  bool loading = true;

  static const Color primaryColor = Color(0xFF6A4AB5);

  @override
  void initState() {
    super.initState();
    loadStatus();
  }

  Future<void> loadStatus() async {
    setState(() => loading = true);
    try {
      final data = await RepairService.fetchStatus();
      setState(() {
        statusText = data['status'];
        progress = (data['progress'] as num).toDouble();
        loading = false;
      });
    } catch (e) {
      setState(() {
        statusText = "Failed to load status";
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "RepairHub",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 1,
        actionsIconTheme: const IconThemeData(color: Color(0xFF6A4AB5)),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text("Welcome, Student",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ServiceButton(
                  icon: Icons.flash_on,
                  label: "Electricity",
                  onTap: () {

                    print("Electricity clicked");
                  },
                ),
                ServiceButton(
                  icon: Icons.water_drop,
                  label: "Plumbing",
                ),
                ServiceButton(
                  icon: Icons.chair,
                  label: "Furniture",
                ),
                ServiceButton(
                  icon: Icons.wifi,
                  label: "Internet",
                ),
              ],
            ),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: loadStatus,
                child: const Text("Report a Problem",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
            const SizedBox(height: 20),
            loading
                ? const CircularProgressIndicator()
                : Text(statusText,
                style: const TextStyle(color: primaryColor, fontSize: 14)),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
