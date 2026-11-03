import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.loading = false,
  }) : icon = null;
  const AppButton.icon({
    super.key,
    required this.onPressed,
    required Widget label,
    required this.icon,
    this.loading = false,
  }) : child = label;
  final VoidCallback? onPressed;
  final Widget child;
  final Widget? icon;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final leading = loading
        ? SizedBox.square(
            dimension: AppTheme.wideGap,
            child: const CircularProgressIndicator(strokeWidth: 2),
          )
        : icon;
    return Semantics(
      liveRegion: loading,
      child: leading == null
          ? FilledButton(onPressed: loading ? null : onPressed, child: child)
          : FilledButton.icon(
              onPressed: loading ? null : onPressed,
              icon: leading,
              label: child,
            ),
    );
  }
}
