import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_button.dart';

enum StatusKind { empty, error }

class StatusPanel extends StatelessWidget {
  const StatusPanel({
    super.key,
    required this.message,
    this.action,
    this.onAction,
    this.loading = false,
    this.kind = StatusKind.empty,
  }) : assert(onAction == null || action != null);
  final String message;
  final String? action;
  final VoidCallback? onAction;
  final bool loading;
  final StatusKind kind;
  @override
  Widget build(BuildContext context) => loading
      ? LoadingState(message: message)
      : kind == StatusKind.error
      ? ErrorState(message: message, action: action, onAction: onAction)
      : EmptyState(message: message, action: action, onAction: onAction);
}

class LoadingState extends StatelessWidget {
  const LoadingState({super.key, required this.message});
  final String message;
  @override
  Widget build(BuildContext context) =>
      _StateContent(message: message, loading: true);
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.message,
    this.action,
    this.onAction,
  }) : assert(onAction == null || action != null);
  final String message;
  final String? action;
  final VoidCallback? onAction;
  @override
  Widget build(BuildContext context) =>
      _StateContent(message: message, action: action, onAction: onAction);
}

class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    required this.message,
    this.action,
    this.onAction,
  }) : assert(onAction == null || action != null);
  final String message;
  final String? action;
  final VoidCallback? onAction;
  @override
  Widget build(BuildContext context) => _StateContent(
    message: message,
    action: action,
    onAction: onAction,
    error: true,
  );
}

class _StateContent extends StatelessWidget {
  const _StateContent({
    required this.message,
    this.action,
    this.onAction,
    this.loading = false,
    this.error = false,
  });
  final String message;
  final String? action;
  final VoidCallback? onAction;
  final bool loading;
  final bool error;
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
            Icon(
              error ? Icons.error_outline : Icons.inbox_outlined,
              color: error ? Theme.of(context).colorScheme.error : null,
            ),
          const SizedBox(height: AppTheme.gap),
          Semantics(
            liveRegion: loading || error,
            child: Text(message, textAlign: TextAlign.center),
          ),
          if (onAction != null)
            AppButton(onPressed: onAction, child: Text(action!)),
        ],
      ),
    ),
  );
}
