import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_app/config/app_color.dart';
import '../../api/api_repair_hub.dart';
import '../../extension/change_notifier.dart'; // សម្រាប់ check isDarkMode
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

  @override
  void initState() {
    super.initState();
    loadStatus();
  }

  Future<void> loadStatus() async {
    if (!mounted) return;
    setState(() => loading = true);
    try {
      final data = await RepairService.fetchStatus();
      if (mounted) {
        setState(() {
          statusText = data['status'];
          progress = (data['progress'] as num).toDouble();
          loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          statusText = "Failed to load status";
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeManager>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColor.backgroundColor : const Color(0xFFFBFBFB),
      appBar: AppBar(
        // 🔥 ប្រើ Gradient ពណ៌ស្វាយដិត Identity របស់ NJU
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: BrandGradient.luxury),
        ),
        iconTheme: const IconThemeData(color: AppColor.lightGold),
        title: const Text(
          "RepairHub",
          style: TextStyle(color: AppColor.lightGold, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Text(
              "Maintenance Services",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : AppColor.primaryColor
              ),
            ),
            const SizedBox(height: 8),
            const Text("Select a category to report an issue",
                style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 35),

            // Service Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildServiceIcon(Icons.flash_on_rounded, "Electricity", Colors.orange),
                _buildServiceIcon(Icons.water_drop_rounded, "Plumbing", Colors.blue),
                _buildServiceIcon(Icons.chair_rounded, "Furniture", Colors.brown),
                _buildServiceIcon(Icons.wifi_rounded, "Internet", Colors.green),
              ],
            ),

            const SizedBox(height: 35),
            // Status Tracking Card
            _buildStatusCard(isDark),

            const SizedBox(height: 25),

            // Report Button with Gold Metallic Gradient
            Container(
              width: double.infinity,
              height: 58,
              decoration: BoxDecoration(
                gradient: BrandGradient.goldMetallic,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: AppColor.accentGold.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6)
                  )
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: loadStatus,
                child: const Text(
                  "Report a Problem",
                  style: TextStyle(color: AppColor.primaryColor, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceIcon(IconData icon, String label, Color color) {
    return Column(
      children: [
        ServiceButton(
          icon: icon,
          label: label,
        ),
      ],
    );
  }

  Widget _buildStatusCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColor.surfaceColor : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColor.glassBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Request Status",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              if (loading)
                const SizedBox(width: 15, height: 15, child: CircularProgressIndicator(strokeWidth: 2, color: AppColor.accentGold))
              else
                Icon(Icons.info_outline, color: AppColor.accentGold.withOpacity(0.7), size: 20),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            statusText,
            style: const TextStyle(color: AppColor.accentGold, fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: isDark ? Colors.white10 : Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColor.accentGold),
            ),
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.centerRight,
            child: Text("${(progress * 100).toInt()}%",
                style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}