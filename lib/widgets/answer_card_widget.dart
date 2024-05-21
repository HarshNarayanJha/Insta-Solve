// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:insta_solve/data/hive_manager.dart';
import 'package:insta_solve/data/util_data.dart';
import 'package:insta_solve/models/answer.dart';
import 'package:insta_solve/pages/answer_detail_page.dart';
import 'package:insta_solve/pages/home.dart';

class AnswerCardWidget extends StatelessWidget {
  const AnswerCardWidget({
    super.key,
    required this.ans,
    required this.index, required this.onDelete,
  });

  final Answer ans;
  final int index;
  final Future<void> Function() onDelete;

  void openAnswer(BuildContext context, Answer ans, int index) {
    Navigator.pushNamed(context, AnswerDetailPage.routeName, arguments: {
      HomePage.answerKey: ans,
      HomePage.indexKey: index,
    });
  }

  Future<void> deleteAnswer(int index) async {
    await HiveManager.deleteAnswerAt(index);
    await onDelete();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        openAnswer(context, ans, index);
      },
      child: Card.filled(
        margin: EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
        color: Theme.of(context).colorScheme.tertiaryContainer,
        child: Column(
          children: [
            (ans.imagePath != null)
                ? ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    child: ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                                  colors: [Colors.transparent, Colors.black],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter)
                              .createShader(bounds);
                        },
                        blendMode: BlendMode.darken,
                        child: Hero(
                          tag: 'image-$index',
                          child: Image.file(
                            File(ans.imagePath!),
                            fit: BoxFit.fitWidth,
                            height: 100,
                            width: double.maxFinite,
                          ),
                        )),
                  )
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
                          tag: 'prompt-$index',
                          child: Text(
                            ans.prompt,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          ),
                        ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(Icons.book_rounded),
                      Text(
                          ' ${ans.subject.replaceFirst("Photo", '').toTitleCase()}'),
                      Spacer(),
                      Icon(Icons.class_outlined),
                      Text(' ${ans.grade}'),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: (ans.response.length > 30)
                            ? Text(
                                "${ans.response.trim().replaceAll('\n', ' ').substring(0, 30)}...",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onTertiaryContainer),
                              )
                            : Text(
                                ans.response,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onTertiaryContainer),
                              ),
                      ),
                      Spacer(),
                      PopupMenuButton(
                        padding: EdgeInsets.all(0),
                        position: PopupMenuPosition.under,
                        enableFeedback: true,
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              child: Text("Open"),
                              onTap: () {
                                openAnswer(context, ans, index);
                              },
                            ),
                            PopupMenuItem(
                              child: Text("Delete"),
                              onTap: () async {
                                await deleteAnswer(index);
                              },
                            ),
                            PopupMenuItem(child: Text("Ask Again")),
                          ];
                        },
                      )
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
}
