import 'package:flutter/material.dart';

class TasksView extends StatefulWidget {
  const TasksView({super.key});

  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            // backgroundColor: Colors.white.withOpacity(0.3),
            title: const Text(
              "Tasks",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          body: const SingleChildScrollView(child: Column(children: []))),
    );
  }
}
