import 'package:flutter/material.dart';
import 'package:insta_solve/widgets/settings_sheet_widget.dart';

class InstasolveAppBar extends StatelessWidget implements PreferredSizeWidget {
  const InstasolveAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        "Insta Solve",
        style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary),
      ),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      titleTextStyle: Theme.of(context).textTheme.headlineMedium,
      centerTitle: true,
      actions: [
        IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                barrierColor: Colors.black45,
                sheetAnimationStyle: AnimationStyle(
                    duration: Durations.medium1,
                    curve: Curves.easeInSine,
                    reverseCurve: Curves.easeOutSine,
                    reverseDuration: Durations.short4),
                showDragHandle: true,
                enableDrag: true,
                useSafeArea: true,
                builder: (context) {
                  return const SettingSheet();
                },
              );
            }),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
