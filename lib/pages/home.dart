// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:insta_solve/pages/scan_page.dart';
import 'package:insta_solve/widgets/instasolve_app_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const InstasolveAppBar(),

      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_search,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              size: 164,
            ),
            SizedBox(height: 50),
            Text(
              "Start scanning to save your answers",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 10),
            Text(
              "Your saved answers will appear here",
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey.shade600),
            ),
            SizedBox(height: 80),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        tooltip: "Scan Picture",
        label: Text("Scan"),
        icon: Icon(Icons.camera_alt_rounded),
        onPressed: () {
          Navigator.pushNamed(context, ScanPage.routeName);
        }
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}