import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock project list
    final projects = ["Work", "Personal", "Wellness"];

    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: ListView.builder(
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final project = projects[index];
          return ListTile(
            title: Text(project),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/tasks',
                arguments: project,
              );
            },
          );
        },
      ),
    );
  }
}
