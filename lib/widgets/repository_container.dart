import 'package:flutter/material.dart';

class RepositoryContainer extends StatelessWidget {
  final Widget child;
  const RepositoryContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: child,
    );
  }
}
