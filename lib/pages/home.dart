// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:insta_solve/data/util_data.dart';
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
    answerBox = await Hive.openBox(UtilData.boxName);
    setState(() {
      answers = answerBox.values.toList();
    });
    answerBox.close();
  }

  @override
  Widget build(BuildContext context) {
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
                    return AnswerCardWidget(ans: ans, index: index);
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
