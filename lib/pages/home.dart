import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:insta_solve/data/hive_manager.dart';
import 'package:insta_solve/models/answer.dart';
import 'package:insta_solve/pages/scan_page.dart';
import 'package:insta_solve/widgets/answer_card_widget.dart';
import 'package:insta_solve/widgets/empty_home_widget.dart';
import 'package:insta_solve/widgets/instasolve_app_bar.dart';
import 'package:insta_solve/widgets/responsive.dart';

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

  @override
  void activate() {
    _loadAnswers();
    super.activate();
  }

  Future<void> _loadAnswers() async {
    List<Answer> ans = await HiveManager.getAnswers();
    setState(() {
      answers = ans;
    });
    log("Home Realod");
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) async {
    super.didUpdateWidget(oldWidget);

    await _loadAnswers();
  }

  @override
  Widget build(BuildContext context) {
    // DateTime now = DateTime.now();
    // DateTime dead = DateTime.parse('2024-05-24');
    // if (now.isAfter(dead)) {
    //   return Center(child: Container(child: Text("App evalution has ended. Uninstall this version and contact the dev to get a new version")));
    // }
    return Scaffold(
      appBar: const InstasolveAppBar(),
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          await _loadAnswers();
        },
        child: Responsive(
          child: Center(
            child: (answers.isEmpty)
                ? const SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: EmptyHomeWidget(),
                  )
                : ListView.separated(
                    itemBuilder: (context, index) {
                      Answer ans = answers[index];
                      return AnswerCardWidget(
                          onDelete: () async {
                            await _loadAnswers();
                          },
                          ans: ans,
                          index: index);
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 20,
                      );
                    },
                    itemCount: answers.length),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
          tooltip: "Scan Picture",
          label: const Text("New Scan"),
          icon: const Icon(Icons.camera_alt_rounded),
          onPressed: () {
            Navigator.pushNamed(context, ScanPage.routeName);
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
