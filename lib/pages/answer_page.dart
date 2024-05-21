import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_solve/data/util_data.dart';
import 'package:insta_solve/env/env.dart';
import 'package:insta_solve/models/answer.dart';
import 'package:insta_solve/pages/scan_page.dart';
import 'package:insta_solve/widgets/answer_view_widget.dart';
import 'package:insta_solve/widgets/image_frame.dart';
import 'package:insta_solve/widgets/instasolve_app_bar.dart';
import 'package:insta_solve/widgets/no_connection_widget.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class AnswerPage extends StatefulWidget {
  const AnswerPage({super.key});

  static const routeName = '/answer';

  @override
  State<AnswerPage> createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  final TeXViewRenderingEngine renderingEngine =
      const TeXViewRenderingEngine.mathjax();

  late final ScrollController pageScrollController;
  bool fabVisible = false;

  final textAnimationIndex = Random().nextInt(2);

  double spinnerOpacity = 0;

  String responseText = "";
  bool apiCalled = false;

  InternetStatus? _connectionStatus;
  late StreamSubscription<InternetStatus> _subscription;

  late final GenerativeModel _model;

  @override
  void initState() {
    super.initState();

    pageScrollController = ScrollController();
    pageScrollController.addListener(() {
      if (responseText.isEmpty) return;

      if (pageScrollController.position.atEdge) {
        if (fabVisible == false) {
          setState(() {
            fabVisible = true;
          });
        }
      } else {
        if (fabVisible == true) {
          setState(() {
            fabVisible = false;
          });
        }
      }
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        spinnerOpacity = 1;
      });
    });

    _subscription = InternetConnection().onStatusChange.listen((status) {
      setState(() {
        _connectionStatus = status;
      });
    });

    GenerationConfig generationConfig = GenerationConfig(
      temperature: 0.2,
      topK: 1,
      topP: 1,
      maxOutputTokens: 1024,
    );
    _model = GenerativeModel(
        model: 'gemini-1.5-pro-latest',
        apiKey: Env.apiKey,
        generationConfig: generationConfig);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<void> getResponse(
      XFile? img, String userPrompt, Prompt subject, String grade) async {
    if (responseText.isNotEmpty) {
      return;
    }

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
      gradePrompt = Content.text(UtilData.getGradeString(grade));
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

    // final response = _model.generateContentStream(content);
    final response = await _model.generateContent(content);

    print("Calling Google");

    setState(() {
      if (response.text != null) {
        responseText = response.text!;
      }
    });
  }

  Future<void> _saveAnswer(XFile? img, String grade, String userPrompt, Prompt subject, String response) async {
    final Directory? saveDir = await getExternalStorageDirectory();
    File tmpFile;
    File saveImg;
    
    late final Answer answer;
    if (img != null) {
      tmpFile = File(img.path);
      final String fileName = basename(tmpFile.path);
      print("File to copy, $tmpFile");
      print("File copy to, " + '$saveDir/$fileName');
    
      saveImg = await tmpFile.copy('${saveDir!.path}/$fileName');
    
      print("File copied to, $saveImg");
    
      // create answer instance
      answer = Answer(
          imagePath: tmpFile.path,
          grade: grade,
          prompt: userPrompt,
          subject: subject.name,
          response: responseText );
    } else {
      answer = Answer(
          grade: grade,
          prompt: userPrompt,
          subject: subject.name,
          response: responseText);
    }
    
    print("Saving ${answer.prompt}");
    
    // save the answer to disk
    var answerBox = await Hive.openBox<Answer>(UtilData.boxName);
    answerBox.add(answer);
    
    print("Saved Answer");
    
    // close the box
    await answerBox.close();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final XFile? file;
    final String promptText;
    final Prompt subject;
    final String grade;
    final bool connection;

    file = arguments[ScanPage.imageKey];
    promptText = arguments[ScanPage.promptKey];
    subject = arguments[ScanPage.subjectKey];
    grade = arguments[ScanPage.gradeKey];
    connection = arguments[ScanPage.connectionKey];

    _connectionStatus ??=
        connection ? InternetStatus.connected : InternetStatus.disconnected;

    // print([file, promptText, subject, grade]);

    if (_connectionStatus == InternetStatus.connected && !apiCalled) {
      getResponse(file, promptText, subject, grade);
      apiCalled = true;
    }

    double w = MediaQuery.of(context).size.width;
    // double h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const InstasolveAppBar(),
      body: SingleChildScrollView(
        controller: pageScrollController,
        scrollDirection: Axis.vertical,
        physics: const ClampingScrollPhysics(),
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
                  ? ImageFrame(file: file)
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text("No image for this question",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.grey))),
              const SizedBox(height: 20),
              (promptText.isNotEmpty)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(promptText,
                          style: Theme.of(context).textTheme.headlineMedium),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText("Answer :",
                        textStyle: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(fontWeight: FontWeight.w500),
                        speed: const Duration(milliseconds: 200)),
                  ],
                  isRepeatingAnimation: false,
                ),
              ),
              if (_connectionStatus == InternetStatus.connected ||
                  responseText.isNotEmpty)
                (responseText.isEmpty)
                    ? Center(
                        child: AnimatedOpacity(
                          opacity: spinnerOpacity,
                          duration: const Duration(milliseconds: 250),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 20),
                              const CircularProgressIndicator.adaptive(),
                              const SizedBox(height: 20),
                              AnimatedTextKit(
                                animatedTexts: [
                                  [
                                    TypewriterAnimatedText(
                                        "Generating the Answer...",
                                        cursor: '|',
                                        speed:
                                            const Duration(milliseconds: 100)),
                                    WavyAnimatedText("Generating the Answer...",
                                        speed:
                                            const Duration(milliseconds: 100))
                                  ][textAnimationIndex]
                                ],
                                repeatForever: true,
                                isRepeatingAnimation: true,
                              )
                            ],
                          ),
                        ),
                      )
                    : AnswerViewWidget(
                        w: w,
                        renderingEngine: renderingEngine,
                        responseText: responseText,
                        textAnimationIndex: textAnimationIndex)
              else
                const NoConnectionWidget(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      floatingActionButton: AnimatedScale(
        scale: fabVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 100),
        child: FloatingActionButton.extended(
          enableFeedback: true,
          tooltip: "Save the Answer for later reference",
          onPressed: () async {
            // save the image to the disk
            await _saveAnswer(file, grade, promptText, subject, responseText);
          },
          label: const Text("Save Answer"),
          icon: const Icon(Icons.save_alt_rounded),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
