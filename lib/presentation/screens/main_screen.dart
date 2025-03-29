import 'package:flutter/material.dart';
import '../widgets/bottom_navbar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ListM'),
      ),
      body: const Center(
        child: Text('Main Screen'),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
