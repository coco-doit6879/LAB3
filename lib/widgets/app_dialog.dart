import 'package:flutter/material.dart';

/// Scrollable content and native action overflow keep dialogs usable on phones.
class AppDialog extends StatelessWidget {
  const AppDialog({super.key, required this.title, this.content, this.actions});
  final Widget title;
  final Widget? content;
  final List<Widget>? actions;
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: title,
    content: content,
    actions: actions,
    scrollable: true,
  );
}
