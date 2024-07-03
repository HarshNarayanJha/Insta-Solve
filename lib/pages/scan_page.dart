import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_solve/data/hive_manager.dart';
import 'package:insta_solve/data/util_data.dart';
import 'package:insta_solve/pages/answer_page.dart';
import 'package:insta_solve/widgets/answer_card_widget.dart';
import 'package:insta_solve/widgets/instasolve_app_bar.dart';
import 'package:insta_solve/widgets/responsive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  static const routeName = '/scan';
  static const imageKey = 'image';
  static const promptKey = 'prompt';
  static const subjectKey = 'subject';
  static const gradeKey = 'grade';
  static const connectionKey = 'connection';

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  XFile? _image;
  Prompt subject = UtilData.qtypes[0];
  String gradeValue = UtilData.grades[9];
  TextEditingController customInput = TextEditingController();
  bool imageOverlayVisible = false;

  bool askedAgainSetDone = false;
  bool answerSavedForLater = false;

  @override
  void initState() {
    super.initState();
    _checkForImagePickerLostData();
  }

  void _openGallery() {
    if (_image == null) {
      _getImageFrom(ImageSource.gallery);
    }
  }

  void _openCamera() {
    if (_image == null) {
      _getImageFrom(ImageSource.camera);
    }
  }

  Future<void> _getImageFrom(ImageSource imageSource) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: imageSource, imageQuality: 50);

    if (image != null) {
      ImageCropper cropper = ImageCropper();
      final croppedImage = await cropper.cropImage(
        sourcePath: image.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: "Cropping Question Image",
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio16x9,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio3x2,
            ],
          ),
          IOSUiSettings(
            title: "Cropping Question Image",
            aspectRatioLockEnabled: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio16x9,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio3x2,
            ],
          ),
        ],
      );
      setState(() {
        _image = croppedImage != null ? XFile(croppedImage.path) : null;
      });
    }
  }

  Future<void> _checkForImagePickerLostData() async {
    final ImagePicker picker = ImagePicker();
    final LostDataResponse response = await picker.retrieveLostData();
    if (response.isEmpty) {
      log("No lost File found");
      return;
    }
    final List<XFile>? files = response.files;
    if (files != null) {
      log("Lost files $files");
      setState(() {
        _image = files.first;
      });
      log(_image?.path ?? 'no path');
    }
  }

  void _toggleImageOverlay() {
    setState(() {
      imageOverlayVisible = !imageOverlayVisible;
    });
  }

  void _removeImage() {
    setState(() {
      _image = null;
      imageOverlayVisible = false;
    });
  }

  Future<void> toAnswer() async {
    // ignore: use_build_context_synchronously
    Navigator.pushNamed(context, AnswerPage.routeName, arguments: {
      ScanPage.imageKey: _image,
      ScanPage.promptKey: customInput.text,
      ScanPage.gradeKey: gradeValue,
      ScanPage.subjectKey: subject,
      ScanPage.connectionKey: await InternetConnection().hasInternetAccess,
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    if (!askedAgainSetDone) {
      if (arguments.containsKey(AnswerCardWidget.imageKey) &&
          arguments[AnswerCardWidget.imageKey] != null) {
        setState(() {
          _image = XFile(arguments[AnswerCardWidget.imageKey]);
          askedAgainSetDone = true;
        });
      }
      if (arguments.containsKey(AnswerCardWidget.customPromptKey)) {
        setState(() {
          customInput.text = arguments[AnswerCardWidget.customPromptKey];
          askedAgainSetDone = true;
        });
      }
      if (arguments.containsKey(AnswerCardWidget.subjectKey)) {
        setState(() {
          subject = Prompt.values.firstWhere(
              (p) => p.name == arguments[AnswerCardWidget.subjectKey]);
          askedAgainSetDone = true;
        });
      }
      if (arguments.containsKey(AnswerCardWidget.gradeKey)) {
        setState(() {
          gradeValue = arguments[AnswerCardWidget.gradeKey];
          askedAgainSetDone = true;
        });
      }
    }

    double w = MediaQuery.of(context).size.width;

    bool gotData = customInput.text.isNotEmpty || (_image != null);

    return Scaffold(
      appBar: const InstasolveAppBar(),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        scrollDirection: Axis.vertical,
        physics: const PageScrollPhysics(),
        child: Responsive(
          child: Container(
            width: w,
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  "Choose either Image or Image with prompt or only Prompt.",
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.center,
                ),
                Text(
                  "NOTE: if the app closes after taking a photo, reopen this screen to get the photo back",
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Stack(
                  children: [
                    Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey.shade800),
                    ),
                    SizedBox(
                      width: 300,
                      height: 300,
                      child: (_image == null)
                          ? CameraButtonRow(
                              openCamera: _openCamera,
                              openGallary: _openGallery,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Stack(children: [
                                GestureDetector(
                                  onTap: () {
                                    _toggleImageOverlay();
                                  },
                                  child: Center(
                                    child: Image.file(
                                      File(_image!.path),
                                      width: 300,
                                    ),
                                  ),
                                ),
                                AnimatedOpacity(
                                  opacity: imageOverlayVisible ? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 250),
                                  child: GestureDetector(
                                    onTap: () {
                                      _toggleImageOverlay();
                                    },
                                    child: ImageDeleteOverlay(
                                        removeImage: _removeImage),
                                  ),
                                ),
                              ]),
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SizedBox(
                    width: 350,
                    child: TextField(
                      controller: customInput,
                      onChanged: (String value) {
                        setState(() {
                          gotData =
                              customInput.text.isNotEmpty || (_image != null);
                        });
                      },
                      maxLength: 60,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(16),
                        label: const Text("Custom Instructions"),
                        suffixIcon: AnimatedOpacity(
                          duration: Durations.short3,
                          opacity: customInput.text.isEmpty ? 0.0 : 1.0,
                          child: GestureDetector(
                            child: const Icon(Icons.clear_rounded),
                            onTap: () {
                              setState(() {
                                customInput.clear();
                              });
                            },
                          ),
                        ),
                        helperText:
                            "Solve 5th question.. answer in points.. etc",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                DropdownMenu<String>(
                  width: 350,
                  label: const Text("Question's subject"),
                  menuHeight: 300,
                  leadingIcon: const Icon(Icons.subject_rounded),
                  initialSelection: subject.name,
                  helperText:
                      "Finetune the question based on subject\nSometimes 'Generic' may provide better solutions",
                  onSelected: (String? value) {
                    setState(() {
                      subject =
                          Prompt.values.firstWhere((e) => e.name == value!);
                    });
                  },
                  dropdownMenuEntries: UtilData.qtypes
                      .map<DropdownMenuEntry<String>>((Prompt val) {
                    return DropdownMenuEntry<String>(
                      value: val.name,
                      label: val.name.toTitleCase(),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 40),
                DropdownMenu<String>(
                  width: 350,
                  label: const Text("Question's Grade level"),
                  menuHeight: 300,
                  leadingIcon: const Icon(Icons.class_rounded),
                  initialSelection: gradeValue,
                  helperText:
                      "Question's grade level\nSet to no grade to auto determine",
                  onSelected: (String? value) {
                    setState(() {
                      gradeValue = value!;
                    });
                  },
                  dropdownMenuEntries: UtilData.grades
                      .map<DropdownMenuEntry<String>>((String val) {
                    return DropdownMenuEntry<String>(value: val, label: val);
                  }).toList(),
                ),
                const SizedBox(height: 50),
                ElevatedButton.icon(
                    icon: Icon(
                      Icons.home_work_outlined,
                      color: (gotData)
                          ? Theme.of(context).colorScheme.onTertiaryContainer
                          : Colors.grey,
                    ),
                    onPressed: (gotData)
                        ? () async {
                            await toAnswer();
                          }
                        : null,
                    style: (gotData)
                        ? ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                Theme.of(context)
                                    .colorScheme
                                    .tertiaryContainer))
                        : const ButtonStyle(),
                    label: Text("Solve!",
                        style: TextStyle(
                            color: (gotData)
                                ? Theme.of(context)
                                    .colorScheme
                                    .onTertiaryContainer
                                : Colors.grey))),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                    icon: Icon(
                      Icons.save_as_rounded,
                      color: (gotData && !answerSavedForLater)
                          ? Theme.of(context).colorScheme.onSecondaryContainer
                          : Colors.grey,
                    ),
                    onPressed: (gotData && !answerSavedForLater)
                        ? () async {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text("Saved to Library!!"),
                            ));
                            setState(() {
                              answerSavedForLater = true;
                            });
                            await HiveManager.saveAnswer(
                                _image,
                                gradeValue,
                                customInput.text.isEmpty
                                    ? ''
                                    : customInput.text,
                                subject,
                                "Not yet Asked");
                          }
                        : null,
                    style: (gotData && !answerSavedForLater)
                        ? ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer))
                        : const ButtonStyle(),
                    label: Text("Save to Ask Later!",
                        style: TextStyle(
                            color: (gotData && !answerSavedForLater)
                                ? Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer
                                : Colors.grey))),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ImageDeleteOverlay extends StatelessWidget {
  const ImageDeleteOverlay({
    super.key,
    required this.removeImage,
  });

  final VoidCallback removeImage;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        width: 300,
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.6)),
        child: GestureDetector(
          onTap: removeImage,
          child: const Icon(
            Icons.delete_forever_outlined,
            color: Colors.red,
            semanticLabel: "Close Image",
            size: 72,
          ),
        ));
  }
}

class CameraButtonRow extends StatelessWidget {
  const CameraButtonRow({
    super.key,
    required this.openGallary,
    required this.openCamera,
  });

  final VoidCallback openGallary;
  final VoidCallback openCamera;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: openGallary,
          icon: const Icon(
            Icons.photo,
            size: 48,
          ),
          color: Colors.white,
        ),
        IconButton(
          onPressed: openCamera,
          icon: const Icon(
            Icons.camera_alt,
            size: 48,
          ),
          color: Colors.white,
        ),
      ],
    );
  }
}
