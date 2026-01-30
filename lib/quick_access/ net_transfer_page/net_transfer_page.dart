import 'package:flutter/material.dart';
import 'package:school_app/config/app_color.dart';

class NetTransfersPage extends StatelessWidget {
  const NetTransfersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColor.backgroundColor : const Color(0xFFFBFBFB),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: BrandGradient.luxury),
        ),
        toolbarHeight: 70,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColor.lightGold, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nanjing University",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColor.lightGold,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              "Transfer Statistics • 2026",
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
            ),
          ],
        ),
        actions: const [
          Icon(Icons.bar_chart_rounded, color: AppColor.lightGold),
          SizedBox(width: 16),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            "Net Transfers Analysis",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : AppColor.primaryColor,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 15),

          /// 📈 Statistical Line Chart
          _buildStatisticsChart(isDark),

          const SizedBox(height: 25),

          /// 📊 Data Table Card
          Text(
            "Detailed Records",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? AppColor.lightGold : Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: AppColor.glassBorder, width: 1),
            ),
            color: isDark ? AppColor.surfaceColor : Colors.white,
            elevation: 4,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(
                    AppColor.primaryColor.withOpacity(isDark ? 0.3 : 0.05),
                  ),
                  columnSpacing: 25,
                  headingTextStyle: TextStyle(
                    color: isDark ? AppColor.lightGold : AppColor.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  columns: const [
                    DataColumn(label: Text("SumNet")),
                    DataColumn(label: Text("Wtey")),
                    DataColumn(label: Text("Toste")),
                    DataColumn(label: Text("Phtvs")),
                  ],
                  rows: _buildDataRows(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsChart(bool isDark) {
    return Container(
      height: 200,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColor.surfaceColor : Colors.white,
        borderRadius: BorderRadius.circular(15),
        // កែពី order ទៅជា border
        border: Border.all(color: AppColor.glassBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Monthly Trend", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Icon(Icons.trending_up, color: AppColor.brandOrange, size: 18),
            ],
          ),
          const Expanded(
            child: Center(

              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: SimpleLineChart(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<DataRow> _buildDataRows() {
    final List<Map<String, String>> data = [
      {"name": "Nanjing Forms", "wtey": "17 Mlation", "toste": "1.51 BA", "phtvs": "2117"},
      {"name": "Transfer Studets", "wtey": "182 4T", "toste": "109 Cn", "phtvs": "2018"},
      {"name": "Hansfers Student", "wtey": "209/0T", "toste": "101 Fimg", "phtvs": "2067"},
    ];

    return data.map((item) => DataRow(cells: [
      DataCell(Text(item['name']!, style: const TextStyle(fontWeight: FontWeight.w500))),
      DataCell(Text(item['wtey']!)),
      DataCell(Text(item['toste']!)),
      DataCell(Text(item['phtvs']!)),
    ])).toList();
  }
}

/// 🎨 Custom Painter សម្រាប់គូរ Line Chart សាមញ្ញ
class SimpleLineChart extends StatelessWidget {
  const SimpleLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 100),
      painter: ChartPainter(),
    );
  }
}

class ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColor.accentGold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.2, size.width * 0.4, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.6, size.height * 0.9, size.width * 0.8, size.height * 0.3);
    path.lineTo(size.width, size.height * 0.1);


    final shadowPath = Path.from(path);
    shadowPath.lineTo(size.width, size.height);
    shadowPath.lineTo(0, size.height);
    shadowPath.close();

    final shadowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColor.accentGold.withOpacity(0.3), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(shadowPath, shadowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}