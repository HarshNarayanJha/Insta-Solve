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
          Icons.image_search,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          size: 164,
        ),
        const SizedBox(height: 50),
        Text(
          "Start scanning to save your answers",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          "Your saved answers will appear here",
          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey.shade600),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}