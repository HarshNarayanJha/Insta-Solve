import 'package:flutter/material.dart';

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
          color: Theme.of(context).colorScheme.primary
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      titleTextStyle: Theme.of(context).textTheme.headlineMedium,
      centerTitle: true,
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}