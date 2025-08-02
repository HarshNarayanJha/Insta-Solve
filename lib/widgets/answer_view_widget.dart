import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:insta_solve/data/util_data.dart';
import 'package:share_plus/share_plus.dart';

class AnswerViewWidget extends StatelessWidget {
  const AnswerViewWidget({
    super.key,
    required this.responseText,
    required this.textAnimationIndex,
    required this.question,
    this.imgPath,
  });

  final String responseText;
  final String question;
  final String? imgPath;
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
                final path = imgPath;
                SharePlus.instance.share(ShareParams(
                    text: responseText.toPlainText(),
                    title: "Solution from InstaSolve",
                    subject: question,
                    files: path != null ? [XFile(path)] : null));
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
        // Container(
        //   padding: EdgeInsets.all(16.0),
        //   margin: EdgeInsets.all(8.0),
        //   decoration: BoxDecoration(
        //       color: Theme.of(context).colorScheme.tertiaryContainer,
        //       borderRadius: BorderRadiusGeometry.circular(10),
        //       border: Border.all(
        //           color: Theme.of(context).colorScheme.tertiaryFixed,
        //           width: 2.0)),
        //   child: TeXWidget(
        //     math: responseText,
        //     displayFormulaWidgetBuilder: (context, displayFormula) {
        //       return Center(
        //         child: TeX2SVG(
        //           math: displayFormula,
        //           loadingWidgetBuilder: (context) =>
        //               buildLoadingWidget(context, textAnimationIndex),
        //           formulaWidgetBuilder: (context, svg) {
        //             double displayFontSize = 24;
        //             return SvgPicture.string(
        //               svg,
        //               colorFilter: ColorFilter.mode(
        //                   Theme.of(context).colorScheme.primaryFixed,
        //                   BlendMode.srcIn),
        //               height: displayFontSize,
        //               width: displayFontSize,
        //               fit: BoxFit.contain,
        //               alignment: Alignment.center,
        //             );
        //           },
        //         ),
        //       );
        //     },
        //     inlineFormulaWidgetBuilder: (context, inlineFormula) {
        //       return TeX2SVG(
        //         math: inlineFormula,
        //         loadingWidgetBuilder: (context) =>
        //             buildLoadingWidget(context, textAnimationIndex),
        //         formulaWidgetBuilder: (context, svg) {
        //           double displayFontSize = 24;
        //           return SvgPicture.string(
        //             svg,
        //             colorFilter: ColorFilter.mode(
        //                 Theme.of(context).colorScheme.primaryFixed,
        //                 BlendMode.srcIn),
        //             height: displayFontSize,
        //             width: displayFontSize,
        //             fit: BoxFit.contain,
        //             alignment: Alignment.center,
        //           );
        //         },
        //       );
        //     },
        //     textWidgetBuilder: (context, text) {
        //       return TextSpan(
        //         text: text,
        //         style: TextStyle(
        //           color: Theme.of(context).colorScheme.onTertiaryContainer,
        //           fontSize: 16,
        //         ),
        //       );
        //     },
        //   ),
        // ),
        // MarkdownBody(
        //   data: responseText,
        //   selectable: true,
        //   builders: {
        //     'latex': LatexElementBuilder(),
        //   },
        //   // softLineBreak: true,
        //   // extensionSet: md.ExtensionSet([
        //   //   ...md.ExtensionSet.gitHubFlavored.blockSyntaxes,
        //   //   LatexBlockSyntax()
        //   // ], [
        //   //   ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes,
        //   //   LatexInlineSyntax()
        //   // ]),
        // )
        TeXView(
          child: TeXViewColumn(children: [
            TeXViewMarkdown(responseText),
          ]),
          style: TeXViewStyle(
            textAlign: TeXViewTextAlign.left,
            margin: const TeXViewMargin.all(4),
            backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
            contentColor: Theme.of(context).colorScheme.onTertiaryContainer,
            padding: const TeXViewPadding.all(16),
            overflow: TeXViewOverflow.scroll,
            elevation: 5,
            borderRadius: const TeXViewBorderRadius.all(12),
          ),
          loadingWidgetBuilder: (context) =>
              buildLoadingWidget(context, textAnimationIndex),
        ),
      ],
    );
  }

  Widget buildLoadingWidget(BuildContext context, int textAnimationIndex) {
    return Center(
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
                    cursor: '|', speed: const Duration(milliseconds: 100)),
              ][textAnimationIndex]
            ],
            repeatForever: true,
            isRepeatingAnimation: true,
          )
        ],
      ),
    );
  }
}
