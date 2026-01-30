import 'package:flutter/material.dart';
import '../../../../config/app_color.dart';
import 'list_fees.dart';

class TuitionTableWidget extends StatelessWidget {
  final bool isDark;
  const TuitionTableWidget({super.key, required this.isDark});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: isDark ? AppColor.surfaceColor : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColor.glassBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Table Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              decoration: const BoxDecoration(gradient: BrandGradient.luxury),
              child: const Row(
                children: [
                  Expanded(flex: 3, child: Text("MAJOR", style: TextStyle(color: AppColor.lightGold, fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1))),
                  Expanded(flex: 1, child: Text("YEAR", textAlign: TextAlign.center, style: TextStyle(color: AppColor.lightGold, fontWeight: FontWeight.w900, fontSize: 10))),
                  Expanded(flex: 2, child: Text("FEE (YUAN)", textAlign: TextAlign.end, style: TextStyle(color: AppColor.lightGold, fontWeight: FontWeight.w900, fontSize: 10))),
                ],
              ),
            ),
            // Table Rows
            ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tuitionData.length,
              separatorBuilder: (context, index) => Divider(height: 1, thickness: 1, color: AppColor.glassBorder),
              itemBuilder: (context, index) {
                final item = tuitionData[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['major'], style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: isDark ? Colors.white : AppColor.primaryColor)),
                            const SizedBox(height: 4),
                            Text(item['cat'].toString().toUpperCase(), style: const TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                          ],
                        ),
                      ),
                      Expanded(flex: 1, child: Text("${item['year']}", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.black87))),
                      Expanded(flex: 2, child: Text("¥ ${item['fee']}", textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.w900, color: AppColor.accentGold, fontSize: 14))),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}