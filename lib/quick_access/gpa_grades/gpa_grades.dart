import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shimmer/shimmer.dart';
import 'package:school_app/config/app_color.dart';

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

  final Color graphBlue = const Color(0xFF4267B2);

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
        graphSpots: const [
          FlSpot(0, 2),
          FlSpot(1, 3.8),
          FlSpot(2, 2.5),
          FlSpot(3, 3.5),
          FlSpot(4, 2.2),
          FlSpot(5, 3.8)
        ],
      ),
      SubjectData(
        name: "Science",
        currentGrade: 85,
        trend: "-2%",
        trendColor: Colors.red,
        icon: Icons.science_outlined,
        graphSpots: const [
          FlSpot(0, 1.8),
          FlSpot(1, 3.2),
          FlSpot(2, 2.0),
          FlSpot(3, 3.8),
          FlSpot(4, 1.5),
          FlSpot(5, 3.5)
        ],
      ),
      SubjectData(
        name: "History",
        currentGrade: 90,
        trend: "+3%",
        trendColor: Colors.green,
        icon: Icons.auto_stories_outlined,
        graphSpots: const [
          FlSpot(0, 2.5),
          FlSpot(1, 4.0),
          FlSpot(2, 2.8),
          FlSpot(3, 3.0),
          FlSpot(4, 3.8),
          FlSpot(5, 3.2)
        ],
      ),
    ];

    Future.delayed(const Duration(seconds: 2), () {
      setState(() => isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color;
    final cardColor = Theme.of(context).cardColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Grades',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: AppColor.primaryColor,
        foregroundColor: Colors.white,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        itemCount: isLoading ? 5 : subjects.length + 1,
        itemBuilder: (context, index) {
          if (isLoading) {
            return SubjectGradeShimmer(isDark: isDark);
          }

          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: Text(
                "Subject Grades",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textColor),
              ),
            );
          }

          return SubjectGradeCard(
            data: subjects[index - 1],
            graphColor: graphBlue,
            isDark: isDark,
            cardColor: cardColor,
          );
        },
      ),
    );
  }
}

class SubjectGradeCard extends StatelessWidget {
  final SubjectData data;
  final Color graphColor;
  final bool isDark;
  final Color cardColor;

  const SubjectGradeCard(
      {super.key,
        required this.data,
        required this.graphColor,
        required this.isDark,
        required this.cardColor});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge!.color;

    return Card(
      color: cardColor,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: isDark ? 0 : 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(data.icon, color: Colors.grey),
              ),
              const SizedBox(width: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(data.name,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor)),
                Text("Current Grade: ${data.currentGrade}",
                    style: const TextStyle(fontSize: 13, color: Colors.grey)),
              ])
            ],
          ),
          const SizedBox(height: 16),
          const Text("Grade Trend", style: TextStyle(color: Colors.grey)),
          Row(children: [
            Text("${data.currentGrade}",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: textColor)),
            const SizedBox(width: 12),
            Text("Last 6 months ${data.trend}",
                style: TextStyle(
                    color: data.trendColor, fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 12),
          SizedBox(
            height: 150,
            child: LineChart(LineChartData(
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                      if (value.toInt() < months.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(months[value.toInt()],
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey)),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,
                  color: graphColor,
                  barWidth: 3,
                  dotData: const FlDotData(show: false),
                  spots: data.graphSpots,
                ),
              ],
            )),
          ),
        ]),
      ),
    );
  }
}

class SubjectGradeShimmer extends StatelessWidget {
  final bool isDark;
  const SubjectGradeShimmer({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
      highlightColor: isDark ? Colors.grey.shade700 : Colors.grey.shade100,
      child: Card(
        margin: const EdgeInsets.only(bottom: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(width: 40, height: 40, color: Colors.white),
              const SizedBox(width: 12),
              Column(children: [
                Container(width: 120, height: 14, color: Colors.white),
                const SizedBox(height: 8),
                Container(width: 80, height: 12, color: Colors.white),
              ])
            ]),
            const SizedBox(height: 16),
            Container(width: 100, height: 12, color: Colors.white),
            const SizedBox(height: 8),
            Container(width: 60, height: 28, color: Colors.white),
            const SizedBox(height: 8),
            Container(width: double.infinity, height: 120, color: Colors.white),
          ]),
        ),
      ),
    );
  }
}
