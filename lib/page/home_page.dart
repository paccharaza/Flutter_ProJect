import 'package:flutter/material.dart';
import 'history_page.dart';

class ExpenseItem {
  TextEditingController titleController;
  TextEditingController valueController;

  ExpenseItem({required String title, String value = ''})
      : titleController = TextEditingController(text: title),
        valueController = TextEditingController(text: value);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _initialBalanceController =
      TextEditingController(text: '');

  List<Map<String, dynamic>> historyList = [];

  final List<ExpenseItem> _expenses = [
    ExpenseItem(title: 'ค่ากุญแจเสีย'),
    ExpenseItem(title: 'ค่าสายยาง+ถังขยะเสียหาย'),
    ExpenseItem(title: 'ค่าทำความสะอาด'),
    ExpenseItem(title: 'ค่าน้ำ+ไฟ ที่เหลือ'),
  ];

  void addExpenseItem() {
    setState(() {
      _expenses.add(ExpenseItem(title: ''));
    });
  }

  void removeExpenseItem(int index) {
    setState(() {
      _expenses.removeAt(index);
    });
  }

  double get totalExpense {
    return _expenses.fold(0, (sum, item) {
      final value = double.tryParse(item.valueController.text) ?? 0;
      return sum + value;
    });
  }

  double get remaining {
    final initial = double.tryParse(_initialBalanceController.text) ?? 0;
    return initial - totalExpense;
  }

  void saveToHistory() {
    final now = DateTime.now();
    historyList.add({
      'date': now,
      'initial': _initialBalanceController.text,
      'expenses': _expenses
          .map((e) => {
                'title': e.titleController.text,
                'value': e.valueController.text,
              })
          .toList(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("บันทึกประวัติแล้ว")),
    );
  }

  void goToHistoryPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryPage(historyList: historyList),
      ),
    );
  }
//eiei
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text('บันทึกรายจ่ายรายเดือน'),
        backgroundColor: Colors.indigo[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: goToHistoryPage,
            tooltip: 'ดูประวัติ',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('เงินมัดจำคงเหลือ', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _initialBalanceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'บาท',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 20),
            const Text('รายการค่าใช้จ่าย',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ..._expenses.asMap().entries.map((entry) {
              int index = entry.key;
              ExpenseItem item = entry.value;
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: item.titleController,
                          decoration: const InputDecoration(
                            hintText: 'ชื่อรายการ',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          controller: item.valueController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'บาท',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () => removeExpenseItem(index),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: addExpenseItem,
                  icon: const Icon(Icons.add),
                  label: const Text(
                    'เพิ่มหัวข้อ',
                    style:  TextStyle(
                        color: Colors.white), // ✅ บังคับสีขาวตรงนี้เลย
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        Colors.white, // ปกติจะใช้ได้กับทั้ง icon และ text
                    backgroundColor: Colors.green[600],
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: addExpenseItem,
                  icon: const Icon(Icons.save),
                  label: const Text(
                    'บันทึกประวัติ',
                    style:  TextStyle(
                        color: Colors.white), // ✅ บังคับสีขาวตรงนี้เลย
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        Colors.white, // ปกติจะใช้ได้กับทั้ง icon และ text
                    backgroundColor: Colors.indigo,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(thickness: 1.2),
            buildSummaryRow("รวมทั้งหมด", totalExpense,
                color: Colors.orange[800]),
            buildSummaryRow("คงเหลือ", remaining,
                color: remaining < 0 ? Colors.red : Colors.green[800]),
          ],
        ),
      ),
    );
  }

  Widget buildSummaryRow(String label, double value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text('${value.toStringAsFixed(0)} บาท',
              style: TextStyle(
                fontSize: 16,
                color: color ?? Colors.black87,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }
}
