import 'dart:io';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:insta_solve/data/hive_manager.dart';
import 'package:insta_solve/data/util_data.dart';
import 'package:insta_solve/models/answer.dart';
import 'package:insta_solve/pages/answer_detail_page.dart';
import 'package:insta_solve/pages/home.dart';
import 'package:insta_solve/pages/scan_page.dart';

class AnswerCardWidget extends StatelessWidget {
  const AnswerCardWidget({
    super.key,
    required this.ans,
    required this.index,
    required this.onDelete,
    // required this.onAskAgain,
  });

  final Answer ans;
  final int index;
  final Future<void> Function() onDelete;

  static const String imageKey = 'image';
  static const String customPromptKey = 'custom';
  static const String subjectKey = 'subject';
  static const String gradeKey = 'grade';

  void openAnswer(BuildContext context, Answer ans) {
    Navigator.pushNamed(context, AnswerDetailPage.routeName, arguments: {
      HomePage.answerKey: ans,
      HomePage.keyKey: ans.key,
    });
  }

  Future<void> deleteAnswer(dynamic key) async {
    await HiveManager.deleteAnswer(key);
    await onDelete();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        openAnswer(context, ans);
      },
      child: Card.filled(
        margin: const EdgeInsets.only(left: 0, right: 0, bottom: 8, top: 8),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Column(
          children: [
            (ans.imagePath != null)
                ? _buildImage()
                : Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text("No Image for this question",
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(color: Colors.grey)),
                  ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  (ans.prompt.isEmpty)
                      ? Text("No Prompt for this question",
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: Colors.grey))
                      : Hero(
                          tag: 'prompt-${ans.key}',
                          child: Text(
                            ans.prompt,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          ),
                        ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(FluentIcons.book_letter_24_filled),
                      Text(
                          ' ${ans.subject.replaceFirst("Photo", '').toTitleCase()}'),
                      const Spacer(),
                      const Icon(FluentIcons.video_person_star_24_filled),
                      Text(' ${ans.grade}'),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: 200,
                          child: Text(
                            ans.response.replaceAll('\n', ' ').toPlainText(),
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            softWrap: false,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onTertiaryContainer),
                          ),
                        ),
                      ),
                      const Spacer(),
                      buildPopupMenu()
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuButton<dynamic> buildPopupMenu() {
    return PopupMenuButton(
      padding: const EdgeInsets.all(0),
      position: PopupMenuPosition.under,
      enableFeedback: true,
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: const Text("Open"),
            onTap: () {
              openAnswer(context, ans);
            },
          ),
          PopupMenuItem(
            child: const Text("Delete"),
            onTap: () async {
              await deleteAnswer(ans.key);
            },
          ),
          PopupMenuItem(
            child: const Text("Ask Again"),
            onTap: () {
              Navigator.of(context).pushNamed(ScanPage.routeName, arguments: {
                AnswerCardWidget.imageKey: ans.imagePath,
                AnswerCardWidget.customPromptKey: ans.prompt,
                AnswerCardWidget.subjectKey: ans.subject,
                AnswerCardWidget.gradeKey: ans.grade
              });
            },
          ),
        ];
      },
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      child: ShaderMask(
          shaderCallback: (bounds) {
            return const LinearGradient(
                    colors: [Colors.transparent, Colors.black],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)
                .createShader(bounds);
          },
          blendMode: BlendMode.darken,
          child: Hero(
            tag: 'image-${ans.key}',
            child: Image.file(
              File(ans.imagePath!),
              fit: BoxFit.fitWidth,
              height: 100,
              width: double.maxFinite,
            ),
          )),
    );
  }
}
