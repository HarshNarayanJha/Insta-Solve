import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:insta_solve/data/hive_manager.dart';
import 'package:insta_solve/data/util_data.dart';
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
  ScrollController controller = ScrollController();
  bool fabVisible = true;

  @override
  void initState() {
    controller.addListener(() {
      if (controller.position.userScrollDirection == ScrollDirection.reverse && fabVisible) {
        setState(() {
          fabVisible = false;
        });
      } else if (controller.position.userScrollDirection == ScrollDirection.forward && !fabVisible) {
        setState(() {
          fabVisible = true;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    final answerBox = Hive.box<Answer>(UtilData.boxName);
    answerBox.close();
    log("Box closed on dispose");
    super.dispose();
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
      body: ValueListenableBuilder(
          valueListenable: Hive.box<Answer>(UtilData.boxName).listenable(),
          builder: (context, box, widget) {
            return Responsive(
              child: Center(
                child: (box.values.isEmpty)
                    ? const EmptyHomeWidget()
                    : ListView.separated(
                        controller: controller,
                        itemBuilder: (context, index) {
                          Answer ans = box.values.toList()[index];
                          return AnswerCardWidget(
                              onDelete: () async {
                                // await _loadAnswers();
                              },
                              ans: ans,
                              index: index);
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 20,
                          );
                        },
                        itemCount: box.values.length),
              ),
            );
          }),
      floatingActionButton: AnimatedSlide(
        duration: Durations.medium1,
        offset: fabVisible ? Offset.zero : Offset.fromDirection(3.14 / 2, 1.5),
        child: FloatingActionButton.extended(
            tooltip: "Scan Picture",
            label: const Text("New Scan"),
            icon: const Icon(Icons.camera_alt_rounded),
            onPressed: () {
              Navigator.pushNamed(context, ScanPage.routeName);
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
