import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:developer' as dev;

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_solve/data/hive_manager.dart';
import 'package:insta_solve/data/preferences_service.dart';
import 'package:insta_solve/data/util_data.dart';
import 'package:insta_solve/env/env.dart';
import 'package:insta_solve/pages/scan_page.dart';
import 'package:insta_solve/widgets/answer_view_widget.dart';
import 'package:insta_solve/widgets/image_frame.dart';
import 'package:insta_solve/widgets/instasolve_app_bar.dart';
import 'package:insta_solve/widgets/no_connection_widget.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:http/http.dart' as http;

class AnswerPage extends StatefulWidget {
  const AnswerPage({super.key});

  static const routeName = '/answer';

  @override
  State<AnswerPage> createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  final preferencesService = PreferencesService();

  final TeXViewRenderingEngine renderingEngine =
      const TeXViewRenderingEngine.mathjax();

  late final ScrollController pageScrollController;
  bool fabVisible = false;
  bool autosave = false;
  bool answerSaved = false;
  int answerKey = -1;

  final textAnimationIndex = Random().nextInt(2);

  double spinnerOpacity = 0;

  String responseText = "";
  bool modelLoaded = false;
  bool apiCalled = false;

  InternetStatus? _connectionStatus;
  late StreamSubscription<InternetStatus> _subscription;

  late final GenerativeModel _model;

  @override
  void initState() {
    super.initState();

    pageScrollController = ScrollController();

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

    // model init moved here!
    loadPreferences();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void loadPreferences() async {
    final savedSettings = await preferencesService.getSettings();

    bool customApiKey = false;
    String userApiKey = "";

    setState(() {
      autosave = savedSettings.autosave;
      customApiKey = savedSettings.customApiKey;
      userApiKey = savedSettings.userApiKey ?? "";
    });

    GenerationConfig generationConfig = GenerationConfig(
      temperature: 0.2,
      topK: 1,
      topP: 1,
      // maxOutputTokens: 1024,
    );

    final apiKeyRegex = RegExp(r'^AIza[0-9A-Za-z\\-_]{35}$');

    if (customApiKey) {
      if (apiKeyRegex.hasMatch(userApiKey)) {
        _model = GenerativeModel(
            model: 'gemini-1.5-flash',
            apiKey: userApiKey,
            generationConfig: generationConfig);
      } else {
        // Invalid Api Key Provided!
        apiCalled = true;
        responseText =
            "The API key provided is invalid. Please check your API key in preferences or disable the custom API key option.";
      }
    } else {
      _model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: Env.apiKey,
          generationConfig: generationConfig);
    }

    setState(() {
      modelLoaded = true;
    });
  }

  Future<void> getResponse(
      XFile? img, String userPrompt, Prompt subject, String grade) async {
    if (responseText.isNotEmpty) {
      return;
    }

    late final List<Content> content = [];

    // first add the base prompt based on subject
    if (subject == Prompt.generic) {
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

    try {
      dev.log(
          "Calling Google ****************************************************");
      final response = await _model.generateContent(content);

      setState(() {
        if (response.text != null) {
          responseText = response.text!;
          fabVisible = true;
          if (autosave) {
            _saveAnswer(img, grade, userPrompt, subject, responseText);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              content: const Text("Automatically saved to the library."),
              action: SnackBarAction(
                  label: "Delete",
                  onPressed: () async {
                    await HiveManager.deleteAnswer(answerKey);
                    setState(() {
                      answerSaved = false;
                    });
                  }),
            ));
          }
        } else {
          responseText = "Unable to fetch the answer.";
        }
      });

      // analytics
      await http.post(
        Uri.parse('https://api.jsonbin.io/v3/b'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'X-Master-Key':
              r'$2a$10$OIp9.7.yZEypFzzir/N/NeSOwkCbQ/bDz7gFkPeGRVWtzvh22GrKK'
        },
        body: jsonEncode(<String, String>{
          'grade': grade,
          'prompt': userPrompt,
          'subject': subject.name,
          'response': responseText,
          'id': 'adarsh'
        }),
      );
    } catch (e) {
      // if (e.runtimeType == )
      setState(() {
        responseText = e.toString();
      });
    }
    // final response = _model.generateContentStream(content);
  }

  Future<void> _saveAnswer(XFile? img, String grade, String userPrompt,
      Prompt subject, String response) async {
    if (answerSaved) {
      return;
    }

    int key =
        await HiveManager.saveAnswer(img, grade, userPrompt, subject, response);
    answerKey = key;
    setState(() {
      answerSaved = true;
    });
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

    if (_connectionStatus == InternetStatus.connected &&
        modelLoaded &&
        !apiCalled) {
      getResponse(file, promptText, subject, grade);
      apiCalled = true;
    }

    double w = MediaQuery.of(context).size.width;

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
              const SizedBox(height: 15),
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
                          style: Theme.of(context).textTheme.headlineSmall),
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
                    Text(
                        ' ${subject.name.replaceFirst("Photo", '').toTitleCase()}'),
                    const Spacer(),
                    const Icon(FluentIcons.video_person_star_24_filled),
                    Text(' $grade'),
                  ],
                ),
              ),
              // const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),
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
                                        "Generating Answer...",
                                        cursor: '|',
                                        speed:
                                            const Duration(milliseconds: 100)),
                                    WavyAnimatedText("Generating Answer...",
                                        speed:
                                            const Duration(milliseconds: 100))
                                  ][textAnimationIndex]
                                ],
                                repeatForever: true,
                                isRepeatingAnimation: true,
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                  "Generating Answers sometimes can take a while, give it some time",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey))
                            ],
                          ),
                        ),
                      )
                    : AnswerViewWidget(
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
          tooltip: "Save this answer for future reference",
          onPressed: () async {
            // save the image to the disk
            if (answerSaved) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                behavior: SnackBarBehavior.floating,
                content: const Text("Already Saved"),
                action: SnackBarAction(
                    label: "Remove",
                    onPressed: () async {
                      await HiveManager.deleteAnswer(answerKey);
                      setState(() {
                        answerSaved = false;
                      });
                    }),
              ));
              return;
            }

            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              content: const Text("Saved to Library."),
              action: SnackBarAction(
                  label: "Delete",
                  onPressed: () async {
                    await HiveManager.deleteAnswer(answerKey);
                    setState(() {
                      answerSaved = false;
                    });
                  }),
            ));

            await _saveAnswer(file, grade, promptText, subject, responseText);
          },
          label: Text(answerSaved ? "Answer Saved" : "Save Answer"),
          icon: Icon(answerSaved
              ? Icons.bookmark_added_rounded
              : Icons.bookmark_add_rounded),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
