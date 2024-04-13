import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 3,
      child: TabBar(
        tabs: [
          Text(
            "All",
            style: TextStyle(fontSize: 20),
          ),
          Text(
            "Patient",
            style: TextStyle(fontSize: 20),
          ),
          Text(
            "Hospital",
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
