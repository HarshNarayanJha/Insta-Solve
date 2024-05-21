// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:insta_solve/data/hive_manager.dart';
import 'package:insta_solve/models/answer.dart';
import 'package:insta_solve/pages/scan_page.dart';
import 'package:insta_solve/widgets/answer_card_widget.dart';
import 'package:insta_solve/widgets/empty_home_widget.dart';
import 'package:insta_solve/widgets/instasolve_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const routeName = '/home';

  static const answerKey = 'answer';
  static const indexKey = 'index';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box<Answer> answerBox;
  List<Answer> answers = [];

  @override
  void initState() {
    super.initState();
    _loadAnswers();
  }

  Future<void> _loadAnswers() async {
    List<Answer> _ans = await HiveManager.getAnswers();
    setState(() {
      answers = _ans;
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadAnswers();
    DateTime now = DateTime.now();
    DateTime dead = DateTime.parse('2024-05-24');
    if (now.isAfter(dead)) {
      return Center(child: Container(child: Text("App evalution has ended. Uninstall this version and contact the dev to get a new version")));
    }
    return Scaffold(
      appBar: const InstasolveAppBar(),
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          await _loadAnswers();
        },
        child: Center(
          child: (answers.isEmpty)
              ? EmptyHomeWidget()
              : ListView.separated(
                  itemBuilder: (context, index) {
                    Answer ans = answers[index];
                    return AnswerCardWidget(onDelete: () async { await _loadAnswers(); }, ans: ans, index: index);
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 20,
                    );
                  },
                  itemCount: answers.length),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          tooltip: "Scan Picture",
          label: Text("Scan"),
          icon: Icon(Icons.camera_alt_rounded),
          onPressed: () {
            Navigator.pushNamed(context, ScanPage.routeName);
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
