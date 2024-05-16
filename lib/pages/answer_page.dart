import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insta_solve/pages/scan_page.dart';
import 'package:insta_solve/widgets/instasolve_app_bar.dart';

class AnswerPage extends StatefulWidget {
  const AnswerPage({super.key});

  static const routeName = '/answer';

  @override
  State<AnswerPage> createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final String _filePath;
    _filePath = arguments[ScanPage.imagePathKey];

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const InstasolveAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: w,
          height: h * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.file(
                File(_filePath),
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color:
                              Theme.of(context).colorScheme.tertiaryContainer,
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.all(8.0),
                      child: child,
                    ),
                  );
                },
              ),
              // GestureDetector(
              //   onTap: () => Navigator.popUntil(context, ModalRoute.withName("/scan")),
              //   child: const Text("Answers to all your academic questions")
              // )
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Answer :",
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
