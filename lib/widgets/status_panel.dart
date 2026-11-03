import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class StatusPanel extends StatelessWidget {
  const StatusPanel({
    super.key,
    required this.message,
    this.action,
    this.onAction,
    this.loading = false,
  });
  final String message;
  final String? action;
  final VoidCallback? onAction;
  final bool loading;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppTheme.wideGap),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (loading)
            const CircularProgressIndicator()
          else
            const Icon(Icons.info_outline),
          const SizedBox(height: AppTheme.gap),
          Text(message, textAlign: TextAlign.center),
          if (onAction != null)
            FilledButton(onPressed: onAction, child: Text(action!)),
        ],
      ),
    ),
  );
}
