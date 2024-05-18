import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
// import 'package:flutter_tex/flutter_tex.dart'
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_solve/data/util_data.dart';
import 'package:insta_solve/env/env.dart';
import 'package:insta_solve/pages/scan_page.dart';
import 'package:insta_solve/widgets/instasolve_app_bar.dart';
import 'package:flutter_markdown_latex/flutter_markdown_latex.dart';
import 'package:markdown/markdown.dart' as md;

class AnswerPage extends StatefulWidget {
  const AnswerPage({super.key});

  static const routeName = '/answer';

  @override
  State<AnswerPage> createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  // final TeXViewRenderingEngine renderingEngine = const TeXViewRenderingEngine.katex();
  String responseText = "";

  late final GenerativeModel _model;

  @override
  void initState() {
    super.initState();
    _model =
        GenerativeModel(model: 'gemini-1.5-pro-latest', apiKey: Env.apiKey);
  }

  Future<void> getResponse(
      XFile? img, String userPrompt, Prompt subject, String grade) async {
    late final List<Content> content = [];

    // first add the base prompt based on subject
    if (subject == Prompt.generic) {
      // it's the generic
      subject = (img != null) ? Prompt.genericPhoto : Prompt.generic;
    }

    // add the base prompt
    content.add(Content.text(UtilData.prompts[subject]!));

    Content? gradePrompt;
    // the first grade is No specific grade, so set
    if (grade != UtilData.grades.first) {
      gradePrompt = Content.text(
          "You are also given the grade (class) for the question. It is $grade. Answer such that a student of $grade grade can understand the answer and language");
    }

    // add the grade prompt if it is
    if (gradePrompt != null) {
      content.add(gradePrompt);
    }

    if (img != null) {
      content.add(Content.text("The question is in the photo"));
      final image = await (img.readAsBytes());
      final imageParts = [DataPart('image/png', image)];
      content.add(Content.multi([...imageParts]));
    }

    // finally add the user prompt if it is
    if (userPrompt.isNotEmpty) {
      content.add(Content.text(userPrompt));
    }

    content.forEach((element) { print(element.toJson()); });

    // final tokenCount = await _model.countTokens(content);
    // print('Token count: ${tokenCount.totalTokens}');

    final response = _model.generateContentStream(content);

    await for (final chunk in response) {
      setState(() {
        if (chunk.text != null) {
          responseText += chunk.text!;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final XFile? file;
    final String promptText;
    final Prompt subject;
    final String grade;

    file = arguments[ScanPage.imageKey];
    promptText = arguments[ScanPage.promptKey];
    subject = arguments[ScanPage.subjectKey];
    grade = arguments[ScanPage.gradeKey];

    print([file, promptText, subject, grade]);

    if (responseText.isEmpty) {
      getResponse(file, promptText, subject, grade);
    }

    double w = MediaQuery.of(context).size.width;
    // double h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const InstasolveAppBar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: (Platform.isLinux)
            ? const PageScrollPhysics()
            : const BouncingScrollPhysics(),
        child: Container(
          constraints: const BoxConstraints.tightForFinite(),
          width: w,
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              (file != null)
                  ? Image.file(
                      File(file.path),
                      frameBuilder:
                          (context, child, frame, wasSynchronouslyLoaded) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .tertiaryContainer,
                                borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.all(8.0),
                            child: child,
                          ),
                        );
                      },
                    )
                  : Text("No image for this question",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.grey)),

              (promptText.isNotEmpty)
                  ? Text(promptText,
                      style: Theme.of(context).textTheme.headlineMedium)
                  : Text("No prompt for this question",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.grey)),
              // GestureDetector(
              //   onTap: () => Navigator.popUntil(context, ModalRoute.withName("/scan")),
              //   child: const Text("Answers to all your academic questions")
              // )
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText("Answer :",
                        textStyle: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline),
                        speed: const Duration(milliseconds: 200)),
                  ],
                  isRepeatingAnimation: false,
                ),
              ),

              // Text(responseText),
              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Theme.of(context).colorScheme.tertiaryContainer,
                child: Container(
                  width: w,
                  padding: const EdgeInsets.all(8.0),
                  child: MarkdownBody(
                    selectable: true,
                    data: responseText,
                    styleSheet: MarkdownStyleSheet(
                        p: TextStyle(
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                    )),
                    builders: {
                      'latex': LatexElementBuilder(
                        textStyle: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onTertiaryContainer),
                      ),
                    },
                    extensionSet: md.ExtensionSet(
                      [LatexBlockSyntax()],
                      [LatexInlineSyntax()],
                    ),
                  ),
                ),
              ),

              // TeXView(
              //   renderingEngine: renderingEngine,
              //   child: TeXViewMarkdown(responseText),
              //   style: const TeXViewStyle(
              //     margin: TeXViewMargin.all(10),
              //     padding: TeXViewPadding.all(20),
              //     elevation: 10,
              //     borderRadius: TeXViewBorderRadius.all(25),
              //   ),
              //   loadingWidgetBuilder: (context) => const Center(
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       mainAxisSize: MainAxisSize.min,
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         CircularProgressIndicator.adaptive(),
              //         SizedBox(
              //           height: 20,
              //         ),
              //         Text("Cooking the answer...")
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
