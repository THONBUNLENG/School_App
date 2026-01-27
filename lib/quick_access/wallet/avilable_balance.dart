import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WalletStatisticsScreen extends StatelessWidget {
  const WalletStatisticsScreen({super.key, required this.balance});

  final double balance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Wallet Statistics',
          style: GoogleFonts.inter(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildDateRangePicker(),
            const SizedBox(height: 20),
            _buildStatCard(
              title: 'Money In',
              amount: '\$2,500',
              subtext: 'Total amount added',
              color: const Color(0xFFE9F7EF),
              iconColor: Colors.green,
              icon: Icons.arrow_downward,
            ),
            const SizedBox(height: 16),
            _buildStatCard(
              title: 'Money Out',
              amount: '\$1,800',
              subtext: 'Total amount spent',
              color: const Color(0xFFFDEDEE),
              iconColor: Colors.red,
              icon: Icons.arrow_upward,
            ),
            const SizedBox(height: 20),
            _buildNetFlowChart(),
            const SizedBox(height: 24),
            _buildTransactionCategories(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRangePicker() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                const Icon(Icons.calendar_today_outlined, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Date Range',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ]),
              Text(
                'Custom',
                style: GoogleFonts.inter(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _dateInputField('Start Date', '10/01/2023')),
              const SizedBox(width: 12),
              Expanded(child: _dateInputField('End Date', '10/31/2023')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dateInputField(String label, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F4F7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: GoogleFonts.inter(fontWeight: FontWeight.w500),
              ),
              const Icon(Icons.calendar_month, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String amount,
    required String subtext,
    required Color color,
    required Color iconColor,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: 8),
            Text(title,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  fontSize: 14,
                )),
          ]),
          const SizedBox(height: 8),
          Text(amount,
              style: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              )),
          Text(subtext,
              style: GoogleFonts.inter(
                color: Colors.black54,
                fontSize: 13,
              )),
        ],
      ),
    );
  }

  Widget _buildNetFlowChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Net Flow (Oct 1 - Oct 31)',
            style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 13),
          ),
          Text(
            '\$700',
            style:
            GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        switch (value.toInt()) {
                          case 0:
                            return const Text('1W');
                          case 3:
                            return const Text('2W');
                          case 6:
                            return const Text('3W');
                          case 9:
                            return const Text('4W');
                          default:
                            return const Text('');
                        }
                      },
                      reservedSize: 32,
                    ),
                  ),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 1),
                      FlSpot(2, 3.5),
                      FlSpot(4, 2.5),
                      FlSpot(6, 3),
                      FlSpot(8, 1),
                      FlSpot(10, 2.2),
                    ],
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [Colors.blue.withOpacity(0.2), Colors.transparent],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildTransactionCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Transaction Categories',
            style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              _categoryTile('Top-ups', '+\$2,000', Colors.green),
              const Divider(height: 1),
              _categoryTile('Canteen Payments', '-\$300', Colors.red),
              const Divider(height: 1),
              _categoryTile('Fees', '-\$1,500', Colors.red),
            ],
          ),
        ),
      ],
    );
  }

  Widget _categoryTile(String title, String amount, Color amountColor) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      title: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
      trailing: Text(
        amount,
        style: GoogleFonts.inter(
          color: amountColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
