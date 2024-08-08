import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:insta_solve/data/util_data.dart';
import 'package:share_plus/share_plus.dart';

class AnswerViewWidget extends StatelessWidget {
  const AnswerViewWidget({
    super.key,
    required this.renderingEngine,
    required this.responseText,
    required this.textAnimationIndex,
  });

  final TeXViewRenderingEngine renderingEngine;
  final String responseText;
  final int textAnimationIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton.filledTonal(
              constraints: const BoxConstraints(maxWidth: 100),
              onPressed: () {
                Clipboard.setData(
                    ClipboardData(text: responseText.toPlainText()));
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
            IconButton.filledTonal(
              constraints: const BoxConstraints(maxWidth: 100),
              onPressed: () async {
                Share.share(responseText.toPlainText());
              },
              icon: const Row(
                children: [
                  Spacer(),
                  Icon(Icons.share_rounded),
                  Spacer(),
                  Text("Share"),
                  Spacer(),
                ],
              ),
              tooltip: "Share",
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          "Disclaimer: AI responses may not always be completely accurate. Please verify critical details with primary sources or academic references.",
          style: Theme.of(context).textTheme.labelMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
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
    );
  }
}
