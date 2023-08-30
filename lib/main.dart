import 'package:animation_task_1/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(BlackHoleAnimation());
}
class BlackHoleAnimation extends StatelessWidget {
  const BlackHoleAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage(),);
  }
}