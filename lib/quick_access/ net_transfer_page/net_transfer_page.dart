import 'package:flutter/material.dart';
import 'package:school_app/config/app_color.dart';

class NetTransfersPage extends StatelessWidget {
  const NetTransfersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.primaryColor,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nanjing University",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "Tuesday 27 • 14:50",
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
        actions: const [
          Icon(Icons.notifications_none),
          SizedBox(width: 12),
          Icon(Icons.search),
          SizedBox(width: 12),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            "Net Transfers",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          /// 📊 Data Table
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: theme.cardColor,
            elevation: 2,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(
                    theme.primaryColor.withOpacity(0.2),
                  ),
                  dataRowColor: MaterialStateProperty.all(theme.cardColor),
                  columnSpacing: 32,
                  headingTextStyle: TextStyle(
                    color: theme.textTheme.bodyMedium?.color,
                    fontWeight: FontWeight.bold,
                  ),
                  dataTextStyle: TextStyle(
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                  columns: const [
                    DataColumn(label: SizedBox(width: 120, child: Text("SumNet", overflow: TextOverflow.ellipsis))),
                    DataColumn(label: SizedBox(width: 150, child: Text("Wtey", overflow: TextOverflow.ellipsis))),
                    DataColumn(label: SizedBox(width: 150, child: Text("Toste", overflow: TextOverflow.ellipsis))),
                    DataColumn(label: SizedBox(width: 80, child: Text("Phtvs", overflow: TextOverflow.ellipsis))),
                  ],
                  rows: const [
                    // Group 1
                    DataRow(cells: [
                      DataCell(SizedBox(width: 120, child: Text("Nanjing Forms"))),
                      DataCell(SizedBox(width: 150, child: Text("17 Mlation Aduing"))),
                      DataCell(SizedBox(width: 150, child: Text("1.51 BA BK3"))),
                      DataCell(SizedBox(width: 80, child: Text("2117"))),
                    ]),
                    DataRow(cells: [
                      DataCell(SizedBox(width: 120, child: Text("Mansfer Studets"))),
                      DataCell(SizedBox(width: 150, child: Text("182 4T TrEK2"))),
                      DataCell(SizedBox(width: 150, child: Text("109 Cn Tmy H7"))),
                      DataCell(SizedBox(width: 80, child: Text("2018"))),
                    ]),
                    DataRow(cells: [
                      DataCell(SizedBox(width: 120, child: Text("Hansfers Student"))),
                      DataCell(SizedBox(width: 150, child: Text("209/0T Tmg H1"))),
                      DataCell(SizedBox(width: 150, child: Text("101 Fimg H2"))),
                      DataCell(SizedBox(width: 80, child: Text("2067"))),
                    ]),
                    // Group 2 (Now seamlessly integrated)
                    DataRow(cells: [
                      DataCell(SizedBox(width: 120, child: Text("Training Esa"))),
                      DataCell(SizedBox(width: 150, child: Text("112 LJT EK2"))),
                      DataCell(SizedBox(width: 150, child: Text("1.28 26 DE K3"))),
                      DataCell(SizedBox(width: 80, child: Text("3716"))),
                    ]),
                    DataRow(cells: [
                      DataCell(SizedBox(width: 120, child: Text("Umpers Slents"))),
                      DataCell(SizedBox(width: 150, child: Text("29 Mty LLS B2Y"))),
                      DataCell(SizedBox(width: 150, child: Text("2.22 2 ME 5H1"))),
                      DataCell(SizedBox(width: 80, child: Text("2018"))),
                    ]),
                    DataRow(cells: [
                      DataCell(SizedBox(width: 120, child: Text("Rensfermium in LDR"))),
                      DataCell(SizedBox(width: 150, child: Text("816 2/U LBK3"))),
                      DataCell(SizedBox(width: 150, child: Text("3.85 TA BK2"))),
                      DataCell(SizedBox(width: 80, child: Text("1216"))),
                    ]),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          /// 🏛 Image Card
          Card(
            color: theme.cardColor,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  "https://www.chinajob.com/document/upload/image/202507/20250714125220_89951.jpg",
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    "Nanjing University Campus",
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
