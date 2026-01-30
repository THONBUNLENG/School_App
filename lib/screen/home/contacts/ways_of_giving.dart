import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_color.dart';
import '../../../extension/change_notifier.dart';

class WaysOfGivingPage extends StatelessWidget {
  const WaysOfGivingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Provider.of<ThemeManager>(context).isDarkMode;

    return Scaffold(
      backgroundColor:
      isDark ? AppColor.backgroundColor : const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          _buildHeader(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionCard(
                    "How to Make a Gift (Donation Channels)",
                    "The Nanjing University Education Development Foundation (NJUEDF) welcomes donations from all individuals who care about education. Various ways of making donations can be considered, ranging from small gifts to setting up an endowment fund. Donations can be in cash, checks, bank drafts, stocks, securities, bonds, publications, facilities, real estate and other assets. Donors may designate a specific purpose or leave it undesignated.",
                    isDark,
                  ),
                  _sectionCard(
                    "Postal Remittance",
                    "Recipient/Beneficiary: Nanjing University Education Development Foundation\n"
                        "Address: Room 734, North Administration Building, Xianlin Campus, Nanjing University, 163 Xianlin Avenue, Nanjing, Jiangsu 210023, China\n"
                        "Tel: +86-25-89686186\nFax: +86-25-89686186\nE-mail: foundation@nju.edu.cn\n\nNOTE: Please clearly indicate the purpose of the donation, the name and contact details of the donor.",
                    isDark,
                  ),
                  _sectionCard(
                    "Wire Transfer (RMB, USD, HKD, CAD, EUR)",
                    "All bank account details for different currencies are maintained by NJUEDF. Donors are advised to confirm the currency and account information with the foundation before making a transfer. SWIFT codes and postal addresses are available for each currency.",
                    isDark,
                  ),
                  _sectionCard(
                    "Donor Recognition",
                    "1. Certificates of Appreciation issued by the university.\n"
                        "2. Special donations may be named after the donor.\n"
                        "3. Acknowledgement at project exhibitions.\n"
                        "4. List of donors published in annual report.\n"
                        "5. Engraving on bronzes with donor consent.",
                    isDark,
                  ),
                  _sectionCard(
                    "Donation Management",
                    "1. Donations are kept in NJUEDF accounts and receipts are issued.\n"
                        "2. Specialized management per agreement; separate accounts may be set up.\n"
                        "3. Earmarked grants used per agreement.\n"
                        "4. Endowment fund investments managed per agreement.\n"
                        "5. Regular donations placed in special funds.\n"
                        "6. Declaration, review, award and appropriation follow agreements and administrative rules.\n"
                        "7. Personalized donor awards are negotiable within university principles.",
                    isDark,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildHeader() {
    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          "Ways of Giving",
          style: TextStyle(
            color: AppColor.lightGold,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(gradient: BrandGradient.luxury),
          child: const Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Icon(Icons.volunteer_activism,
                  size: 120, color: Colors.white12),
            ),
          ),
        ),
      ),
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColor.lightGold, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Widget _sectionCard(String title, String content, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColor.surfaceColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.accentGold.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              )),
          const SizedBox(height: 8),
          Text(content,
              style: TextStyle(
                fontSize: 13,
                height: 1.6,
                color: isDark ? Colors.white70 : Colors.black87,
              )),
        ],
      ),
    );
  }
}
