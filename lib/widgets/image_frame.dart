import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageFrame extends StatelessWidget {
  const ImageFrame({
    super.key,
    required this.file,
  });

  final XFile? file;

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(file!.path),
      height: 250,
      fit: BoxFit.scaleDown,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.all(8.0),
            child:
                ClipRRect(borderRadius: BorderRadius.circular(8), child: child),
          ),
        );
      },
    );
  }
}
