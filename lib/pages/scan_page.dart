import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_solve/data/util_data.dart';
import 'package:insta_solve/pages/answer_page.dart';
import 'package:insta_solve/widgets/instasolve_app_bar.dart';

class ScanPage extends StatefulWidget {


  const ScanPage({super.key});

  static const routeName = '/scan';
  static const imageKey = 'image';
  static const promptKey = 'prompt';
  static const gradeKey = 'grade';

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  XFile? _image;
  String subjectValue = UtilData.qtypes.keys.first;
  String gradeValue = UtilData.grades[9];
  TextEditingController customInput = TextEditingController();

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
    final XFile? image = await picker.pickImage(source: imageSource);

    if (image != null) {
      ImageCropper cropper = ImageCropper();
      final croppedImage = await cropper.cropImage(
        // context: context,
        sourcePath: image.path,
        // imageBytes: await image.readAsBytes(),
        // onImageDoneListener: (data) {}
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio16x9,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio3x2,
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: "Cropping One Question",
            lockAspectRatio: false
          ),
          IOSUiSettings(
            title: "Cropping One Question",
            aspectRatioLockEnabled: false
          ),
        ],
      );
      setState(() {
        _image = croppedImage != null ? XFile(croppedImage.path) : null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    
    double w = MediaQuery.of(context).size.width;
    // double h = MediaQuery.of(context).size.height;

    bool gotData() => customInput.text.isNotEmpty || (_image != null);

    return Scaffold(
      appBar: const InstasolveAppBar(),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: Container(
          constraints: const BoxConstraints.tightForFinite(),
          width: w,
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20,),
              Text(
                "Choose either Image or Image with prompt or only Prompt",
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 30,),
              Stack(
                // alignment: Alignment.center,
                children: [
          
                  (_image == null) 
                    ? ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0, tileMode: TileMode.decal),
                        child: Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.grey.shade800),
                        ),
                      )
                    : Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.grey.shade800),
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
                            icon: const Icon(Icons.photo, size: 48,),
                            color: Colors.white,
                          ),
                  
                          IconButton(
                            onPressed: () {
                              _openCamera();
                            },
                            icon: const Icon(Icons.camera_alt, size: 48,),
                            color: Colors.white,
                          ),
                        ],
                      )
                      : Image.file(File(_image!.path)),
                  ),
                  
                ],
              ),
          
              // DropdownButton<String>(
              //   value: gradeValue,
              //   icon: const Icon(Icons.class_outlined),
              //   elevation: 16,
              //   underline: Container(
              //     height: 2,
              //     color: Theme.of(context).colorScheme.primary,
              //   ),
              //   onChanged: (String? value) {
              //     setState(() {
              //       gradeValue = value!;
              //     });
              //   },
              //   items: UtilData.grades.map<DropdownMenuItem<String>>((String val) {
              //     return DropdownMenuItem<String>(
              //       value: val,
              //       child: Text(val)
              //     );
              //   }).toList(),
              // ),

              const SizedBox(height: 40,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: 350,
                  child: TextField(
                    controller: customInput,
                    maxLength: 45,
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

              const SizedBox(height: 40,),
              DropdownMenu<String>(
                width: 350,
                label: const Text("Question's subject"),
                menuHeight: 600,
                leadingIcon: const Icon(Icons.subject_outlined),
                initialSelection: subjectValue,
                helperText: "finetune the question based on subject\nsometimes 'Generic' may provide better solutions",
                onSelected: (String? value) {
                  setState(() {
                    subjectValue = value!;
                  });
                },
                dropdownMenuEntries: UtilData.qtypes.keys.map<DropdownMenuEntry<String>>((String val) {
                  return DropdownMenuEntry<String>(
                    value: val,
                    label: val
                  );
                }).toList(),
              ),

              const SizedBox(height: 40,),
              
              DropdownMenu<String>(
                width: 350,
                label: const Text("Question's Grade level"),
                menuHeight: 400,
                leadingIcon: const Icon(Icons.class_outlined),
                initialSelection: gradeValue,
                helperText: "question's grade level\nset to no grade to auto determine",
                onSelected: (String? value) {
                  setState(() {
                    gradeValue = value!;
                  });
                },
                dropdownMenuEntries: UtilData.grades.map<DropdownMenuEntry<String>>((String val) {
                  return DropdownMenuEntry<String>(
                    value: val,
                    label: val
                  );
                }).toList(),
              ),

              const SizedBox(height: 50,),
          
              ElevatedButton.icon(
                icon: Icon(Icons.home_work_outlined, color: Theme.of(context).colorScheme.onTertiaryContainer,),
                onPressed: gotData() 
                  ? () {
                    Navigator.pushNamed(
                      context,
                      AnswerPage.routeName,
                      arguments: {
                          ScanPage.imageKey: _image,
                          ScanPage.promptKey: customInput.text,
                          ScanPage.gradeKey: gradeValue,
                        } 
                      );
                  }
                  : null,
                style: gotData() ? ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.tertiaryContainer)) : const ButtonStyle(),
                label: Text("Solve!", style: TextStyle(color: Theme.of(context).colorScheme.onTertiaryContainer))
              ),

              const SizedBox(height: 30,),
          
              // const Text("Scan question with your camera"),
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
