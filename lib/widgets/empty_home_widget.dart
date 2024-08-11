import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class EmptyHomeWidget extends StatelessWidget {
  const EmptyHomeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Icon(
          FluentIcons.notebook_lightning_24_filled,
          color: Theme.of(context).colorScheme.onTertiaryContainer,
          size: 164,
        ),
        const SizedBox(height: 50),
        Text(
          "No Saved Answers. Tap the button below to ask a question",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          "Your saved answers will appear here",
          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.grey.shade600),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}
