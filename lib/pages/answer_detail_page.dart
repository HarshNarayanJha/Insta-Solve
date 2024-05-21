import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:image_picker/image_picker.dart';
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
    final int index = arguments[HomePage.indexKey];

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
                ? Hero(tag: 'image-$index', child: ImageFrame(file: XFile(ans.imagePath!)))
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text("No image for this question",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.grey))),
            const SizedBox(height: 20),
            (ans.prompt.isNotEmpty)
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Hero(
                      tag: 'prompt-$index',
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
            const SizedBox(height: 20),
            AnswerViewWidget(
                w: double.maxFinite,
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
