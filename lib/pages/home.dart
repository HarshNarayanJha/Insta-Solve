import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:insta_solve/data/util_data.dart';
import 'package:insta_solve/models/answer.dart';
import 'package:insta_solve/pages/scan_page.dart';
import 'package:insta_solve/widgets/answer_card_widget.dart';
import 'package:insta_solve/widgets/empty_home_widget.dart';
import 'package:insta_solve/widgets/filter_sheet_widget.dart';
import 'package:insta_solve/widgets/instasolve_app_bar.dart';
import 'package:insta_solve/widgets/responsive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const routeName = '/home';

  static const answerKey = 'answer';
  static const keyKey = 'anskey';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController controller = ScrollController();
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  bool fabVisible = true;

  String filterSubject = 'all';
  String filterClass = 'all';
  bool sortOldFirst = false;
  String searchText = '';

  @override
  void initState() {
    controller.addListener(() {
      if (controller.position.userScrollDirection == ScrollDirection.reverse &&
          fabVisible) {
        setState(() {
          fabVisible = false;
        });
      } else if (controller.position.userScrollDirection ==
              ScrollDirection.forward &&
          !fabVisible) {
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

  void onFilterSubject(String newSubject) {
    setState(() {
      filterSubject = newSubject;
    });
  }

  void onFilterClass(String newClass) {
    setState(() {
      filterClass = newClass;
    });
  }

  void onSortOldFirst(bool newSort) {
    setState(() {
      sortOldFirst = newSort;
    });
  }

  @override
  Widget build(BuildContext context) {
    // DateTime now = DateTime.now();
    // DateTime dead = DateTime.parse('2024-05-24');
    // if (now.isAfter(dead)) {
    //   return Center(child: Container(child: Text("App evalution has ended. Uninstall this version and contact the dev to get a new version")));
    // }

    bool filterApplied =
        filterClass != 'all' || filterSubject != 'all' || sortOldFirst;

    return Scaffold(
      appBar: const InstasolveAppBar(),
      body: ValueListenableBuilder(
          valueListenable: Hive.box<Answer>(UtilData.boxName).listenable(),
          builder: (context, box, widget) {
            return Responsive(
              child: Container(
                padding:
                    const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Visibility(
                      visible: box.values.isNotEmpty,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Saved Answers",
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.filter_alt_rounded),
                                color: filterApplied ? Colors.green : null,
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    barrierColor: Colors.black45,
                                    sheetAnimationStyle: AnimationStyle(
                                        duration: Durations.medium1,
                                        curve: Curves.easeIn,
                                        reverseCurve: Curves.easeOut,
                                        reverseDuration: Durations.short4),
                                    showDragHandle: true,
                                    useSafeArea: true,
                                    builder: (context) {
                                      return FilterSheet(
                                        filterSubject: filterSubject,
                                        filterClass: filterClass,
                                        sortOldFirst: sortOldFirst,
                                        onFilterClass: onFilterClass,
                                        onFilterSubject: onFilterSubject,
                                        onSortOldFirst: onSortOldFirst,
                                      );
                                    },
                                  );
                                },
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                          const SizedBox(height: 5),
                          TextField(
                            controller: searchController,
                            focusNode: searchFocus,
                            autofocus: false,
                            onChanged: (value) {
                              setState(() {
                                searchText = value;
                              });
                            },
                            decoration: InputDecoration(
                              suffixIcon: searchText.isEmpty
                                  ? const Icon(Icons.search)
                                  : IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        setState(() {
                                          searchText = "";
                                          searchController.clear();
                                          searchFocus.unfocus();
                                        });
                                      },
                                    ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(35)),
                              label: const Text("Search Answers"),
                              isDense: true,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: (box.values.isEmpty)
                          ? const EmptyHomeWidget()
                          : ListView.separated(
                              controller: controller,
                              itemBuilder: (context, index) {
                                late Answer ans;
                                if (sortOldFirst) {
                                  ans = box.values.toList()[index];
                                } else {
                                  ans = box.values
                                      .toList()
                                      .reversed
                                      .toList()[index];
                                }

                                if (filterClass != 'all') {
                                  if (ans.grade != filterClass) {
                                    return const SizedBox(height: 0);
                                  }
                                }
                                if (filterSubject != 'all') {
                                  if (ans.subject != filterSubject) {
                                    return const SizedBox(height: 0);
                                  }
                                }

                                if (searchText.isNotEmpty &&
                                    !ans.prompt
                                        .toLowerCase()
                                        .contains(searchText.toLowerCase())) {
                                  return const SizedBox(height: 0);
                                }

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
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: AnimatedSlide(
        duration: Durations.medium1,
        offset: fabVisible ? Offset.zero : Offset.fromDirection(3.14 / 2, 1.5),
        child: FloatingActionButton.extended(
            tooltip: "Capture New Question",
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
