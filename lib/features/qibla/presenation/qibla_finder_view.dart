import 'package:flutter/material.dart';
import 'package:islamic_calander_2/core/widgets/default_drawer.dart';

class QiblaFinderView extends StatefulWidget {
  const QiblaFinderView({super.key});

  @override
  State<QiblaFinderView> createState() => _QiblaFinderViewState();
}

class _QiblaFinderViewState extends State<QiblaFinderView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.2),
        foregroundColor: Colors.black,
      ),
      drawer: const DefaultDrawer(opacity: 0.7),
      body: const SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
