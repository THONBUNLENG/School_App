import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import 'package:school_app/config/app_color.dart';
import '../../extension/change_notifier.dart'; // សម្រាប់ check isDarkMode

class SubjectData {
  final String name;
  final int currentGrade;
  final String trend;
  final Color trendColor;
  final IconData icon;
  final List<FlSpot> graphSpots;

  SubjectData({
    required this.name,
    required this.currentGrade,
    required this.trend,
    required this.trendColor,
    required this.icon,
    required this.graphSpots,
  });
}

class GradesScreen extends StatefulWidget {
  const GradesScreen({super.key});

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  bool isLoading = true;

  late final List<SubjectData> subjects;

  @override
  void initState() {
    super.initState();
    subjects = [
      SubjectData(
        name: "Mathematics",
        currentGrade: 92,
        trend: "+5%",
        trendColor: Colors.green,
        icon: Icons.calculate_outlined,
        graphSpots: const [FlSpot(0, 80), FlSpot(1, 85), FlSpot(2, 82), FlSpot(3, 88), FlSpot(4, 90), FlSpot(5, 92)],
      ),
      SubjectData(
        name: "Science",
        currentGrade: 85,
        trend: "-2%",
        trendColor: Colors.redAccent,
        icon: Icons.science_outlined,
        graphSpots: const [FlSpot(0, 88), FlSpot(1, 87), FlSpot(2, 85), FlSpot(3, 86), FlSpot(4, 84), FlSpot(5, 85)],
      ),
      SubjectData(
        name: "History",
        currentGrade: 90,
        trend: "+3%",
        trendColor: Colors.green,
        icon: Icons.auto_stories_outlined,
        graphSpots: const [FlSpot(0, 82), FlSpot(1, 84), FlSpot(2, 86), FlSpot(3, 85), FlSpot(4, 88), FlSpot(5, 90)],
      ),
    ];

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeManager>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColor.backgroundColor : const Color(0xFFFBFBFB),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: BrandGradient.luxury),
        ),
        title: const Text(
          'Academic Grades',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.lightGold),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColor.lightGold, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: isLoading ? 3 : subjects.length + 1,
        itemBuilder: (context, index) {
          if (isLoading) return SubjectGradeShimmer(isDark: isDark);

          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                "Subject Performance",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : AppColor.primaryColor),
              ),
            );
          }

          return SubjectGradeCard(
            data: subjects[index - 1],
            isDark: isDark,
          );
        },
      ),
    );
  }
}

class SubjectGradeCard extends StatelessWidget {
  final SubjectData data;
  final bool isDark;

  const SubjectGradeCard({super.key, required this.data, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isDark ? AppColor.surfaceColor : Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColor.glassBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColor.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(data.icon, color: isDark ? AppColor.lightGold : AppColor.primaryColor),
                  ),
                  const SizedBox(width: 15),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(data.name,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColor.primaryColor)),
                    Text("Current Grade", style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                  ])
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: data.trendColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(data.trend,
                    style: TextStyle(color: data.trendColor, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text("${data.currentGrade}",
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: isDark ? AppColor.lightGold : AppColor.primaryColor)),
              const SizedBox(width: 5),
              const Text("%", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 15),
          const Text("6-Month Progress", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 10),
          SizedBox(
            height: 120,
            child: LineChart(_buildChartData()),
          ),
        ]),
      ),
    );
  }

  LineChartData _buildChartData() {
    return LineChartData(
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (value, meta) {
              const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
              if (value.toInt() < months.length) {
                return Text(months[value.toInt()], style: const TextStyle(fontSize: 10, color: Colors.grey));
              }
              return const SizedBox();
            },
          ),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          isCurved: true,
          curveSmoothness: 0.35,
          color: AppColor.accentGold,
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColor.accentGold.withOpacity(0.3), AppColor.accentGold.withOpacity(0)],
            ),
          ),
          spots: data.graphSpots,
        ),
      ],
    );
  }
}

class SubjectGradeShimmer extends StatelessWidget {
  final bool isDark;
  const SubjectGradeShimmer({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.white10 : Colors.grey.shade300,
      highlightColor: isDark ? Colors.white24 : Colors.grey.shade100,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        height: 280,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
      ),
    );
  }
}