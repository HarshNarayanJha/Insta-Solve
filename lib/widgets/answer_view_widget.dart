import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:insta_solve/data/util_data.dart';

class AnswerViewWidget extends StatelessWidget {
  const AnswerViewWidget({
    super.key,
    required this.w,
    required this.renderingEngine,
    required this.responseText,
    required this.textAnimationIndex,
  });

  final double w;
  final TeXViewRenderingEngine renderingEngine;
  final String responseText;
  final int textAnimationIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: w,
      child: Column(
        children: [
          IconButton.outlined(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: responseText.toPlainText()));
            },
            icon: const Row(
              children: [
                Spacer(),
                Icon(Icons.copy_rounded),
                Text("Copy"),
                Spacer(),
              ],
            ),
            tooltip: "Copy",
          ),
          TeXView(
            renderingEngine: renderingEngine,
            child: TeXViewMarkdown(responseText),
            style: TeXViewStyle(
              textAlign: TeXViewTextAlign.justify,
              margin: const TeXViewMargin.all(5),
              backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
              contentColor: Theme.of(context).colorScheme.onTertiaryContainer,
              padding: const TeXViewPadding.all(16),
              elevation: 5,
              // height: 100,
              borderRadius: const TeXViewBorderRadius.all(10),
            ),
            loadingWidgetBuilder: (context) => Center(
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
                        WavyAnimatedText("Cooking the Answer...",
                            speed: const Duration(milliseconds: 100)),
                        TypewriterAnimatedText("Cooking the Answer...",
                            cursor: '|',
                            speed: const Duration(milliseconds: 100)),
                      ][textAnimationIndex]
                    ],
                    repeatForever: true,
                    isRepeatingAnimation: true,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
