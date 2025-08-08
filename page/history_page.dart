import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> historyList;

  const HistoryPage({super.key, required this.historyList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ประวัติการใช้จ่าย")),
      body: historyList.isEmpty
          ? const Center(child: Text("ยังไม่มีประวัติ"))
          : ListView.builder(
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                final record = historyList[index];
                final List expenses = record['expenses'];

                final double total = expenses.fold(0.0, (sum, item) {
                  final value = double.tryParse(item['value'] ?? '') ?? 0;
                  return sum + value;
                });

                final double initial = double.tryParse(record['initial']) ?? 0;
                final double remaining = initial - total;
                final date = (record['date'] as DateTime).toLocal();

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '📅 ${date.day}/${date.month}/${date.year} เวลา ${date.hour}:${date.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text('ยอดเริ่มต้น: ${initial.toStringAsFixed(0)} บาท'),
                        const SizedBox(height: 4),
                        ...expenses.map<Widget>((e) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(e['title'] ?? ''),
                                Text('${e['value'] ?? ''} บาท'),
                              ],
                            )),
                        const Divider(),
                        buildSummaryRow("รวมทั้งหมด", total),
                        buildSummaryRow("คงเหลือ", remaining),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget buildSummaryRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text('${value.toStringAsFixed(0)} บาท',
              style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
  //eiei
}
