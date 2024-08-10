import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_solve/data/util_data.dart';
import 'package:insta_solve/models/answer.dart';
import 'package:insta_solve/pages/home.dart';
import 'package:insta_solve/widgets/answer_view_widget.dart';
import 'package:insta_solve/widgets/image_frame.dart';
import 'package:insta_solve/widgets/instasolve_app_bar.dart';

class AnswerDetailPage extends StatefulWidget {
  const AnswerDetailPage({super.key});

  static const routeName = '/answer_detail';

  @override
  State<AnswerDetailPage> createState() => _AnswerDetailPageState();
}

class _AnswerDetailPageState extends State<AnswerDetailPage> {
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final Answer ans = arguments[HomePage.answerKey];
    final int key = arguments[HomePage.keyKey];

    return Scaffold(
      appBar: const InstasolveAppBar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const ClampingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            (ans.imagePath != null)
                ? Hero(
                    tag: 'image-$key',
                    child: ImageFrame(file: XFile(ans.imagePath!)))
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text("No image for this question",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.grey))),
            const SizedBox(height: 10),
            (ans.prompt.isNotEmpty)
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Hero(
                      tag: 'prompt-$key',
                      child: Text(ans.prompt,
                          style: Theme.of(context).textTheme.headlineMedium),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text("No prompt for this question",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.grey)),
                  ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(FluentIcons.book_letter_24_filled),
                  Text(' ${ans.subject.replaceFirst("Photo", '').toTitleCase()}'),
                  const Spacer(),
                  const Icon(FluentIcons.video_person_star_24_filled),
                  Text(' ${ans.grade}'),
                ],
              ),
            ),
            const SizedBox(height: 10),
            AnswerViewWidget(
                renderingEngine: const TeXViewRenderingEngine.mathjax(),
                responseText: ans.response,
                textAnimationIndex: 1),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
