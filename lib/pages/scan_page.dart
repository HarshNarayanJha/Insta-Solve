import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_solve/data/util_data.dart';
import 'package:insta_solve/pages/answer_page.dart';
import 'package:insta_solve/widgets/instasolve_app_bar.dart';
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
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio16x9,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio3x2,
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: "Cropping One Question", lockAspectRatio: false),
          IOSUiSettings(
              title: "Cropping One Question", aspectRatioLockEnabled: false),
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
      print("No lost File found");
      return;
    }
    final List<XFile>? files = response.files;
    if (files != null) {
      print("Lost files $files");
      setState(() {
        _image = files.first;
      });
      print(_image?.path ?? 'no path');
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

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    // double h = MediaQuery.of(context).size.height;

    bool gotData = customInput.text.isNotEmpty || (_image != null);

    return Scaffold(
      appBar: const InstasolveAppBar(),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        scrollDirection: Axis.vertical,
        physics: (Platform.isLinux)
            ? const PageScrollPhysics()
            : const BouncingScrollPhysics(),
        child: Container(
          constraints: const BoxConstraints.tightForFinite(),
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
                // alignment: Alignment.center,
                children: [
                  if (_image == null)
                    ImageFiltered(
                      imageFilter: ImageFilter.blur(
                          sigmaX: 5.0, sigmaY: 5.0, tileMode: TileMode.decal),
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade800),
                      ),
                    )
                  else
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
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () {
                                  _openGallery();
                                },
                                icon: const Icon(
                                  Icons.photo,
                                  size: 48,
                                ),
                                color: Colors.white,
                              ),
                              IconButton(
                                onPressed: () {
                                  _openCamera();
                                },
                                icon: const Icon(
                                  Icons.camera_alt,
                                  size: 48,
                                ),
                                color: Colors.white,
                              ),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Stack(children: [
                              GestureDetector(
                                  onTap: () {
                                    _toggleImageOverlay();
                                  },
                                  child: Center(
                                      child: Image.file(File(_image!.path)))),
                              AnimatedOpacity(
                                opacity: imageOverlayVisible ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 250),
                                child: GestureDetector(
                                  onTap: () {
                                    _toggleImageOverlay();
                                  },
                                  child: Container(
                                      height: 300,
                                      width: 300,
                                      decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.6)),
                                      child: GestureDetector(
                                        onTap: () {
                                          _removeImage();
                                        },
                                        child: const Icon(
                                          Icons.delete_forever_outlined,
                                          color: Colors.red,
                                          semanticLabel: "Close Image",
                                          size: 72,
                                        ),
                                      )),
                                ),
                              ),
                            ]),
                          ),
                  ),
                ],
              ),

              const SizedBox(
                height: 40,
              ),
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
                      label: const Text("Custom Prompt"),
                      helperText: "solve 5th question.. answer in points.. etc",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      // hintText: "..solve 5th question OR answer in points"
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
              DropdownMenu<String>(
                width: 350,
                label: const Text("Question's subject"),
                menuHeight: 600,
                leadingIcon: const Icon(Icons.subject_outlined),
                initialSelection: subject.name,
                helperText:
                    "finetune the question based on subject\nsometimes 'Generic' may provide better solutions",
                onSelected: (String? value) {
                  setState(() {
                    subject = Prompt.values.firstWhere((e) => e.name == value!);
                  });
                },
                dropdownMenuEntries: UtilData.qtypes
                    .map<DropdownMenuEntry<String>>((Prompt val) {
                  return DropdownMenuEntry<String>(
                      value: val.name, label: val.name.toTitleCase());
                }).toList(),
              ),

              const SizedBox(height: 40),

              DropdownMenu<String>(
                width: 350,
                label: const Text("Question's Grade level"),
                menuHeight: 400,
                leadingIcon: const Icon(Icons.class_outlined),
                initialSelection: gradeValue,
                helperText:
                    "question's grade level\nset to no grade to auto determine",
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
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                  ),
                  onPressed: (gotData)
                      ? () async {
                          Navigator.pushNamed(context, AnswerPage.routeName,
                              arguments: {
                                ScanPage.imageKey: _image,
                                ScanPage.promptKey: customInput.text,
                                ScanPage.gradeKey: gradeValue,
                                ScanPage.subjectKey: subject,
                                ScanPage.connectionKey: await InternetConnection().hasInternetAccess,
                              });
                        }
                      : null,
                  style: (gotData)
                      ? ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                              Theme.of(context).colorScheme.tertiaryContainer))
                      : const ButtonStyle(),
                  label: Text("Solve!",
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onTertiaryContainer))),

              const SizedBox(height: 30),

              // const Text("Scan question with your camera"),Content.text(prompt)
              // GestureDetector(
              //   onTap: () => Navigator.pushNamed(context, "/answer"),
              //   child: const Text("Now view answer"),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
