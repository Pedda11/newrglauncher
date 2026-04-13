import 'package:flutter/material.dart';

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool? centerTitle;
  final Widget? trailing;

  const MyAppbar(
      {super.key, required this.title, this.centerTitle = true, this.trailing});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        trailing ?? Container(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);
}
