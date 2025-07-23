import 'package:flutter/material.dart';
import 'page/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'แอปบันทึกค่าใช้จ่าย',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: HomePage(),
    );
  }
}
