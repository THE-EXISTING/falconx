import 'package:falconx/falconx.dart';

extension SentryExtension on Object? {
  Future<SentryId> sentryCaptureException(
    dynamic stackTrace, {
    Hint? hint,
    ScopeCallback? withScope,
  }) async =>
      await Sentry.captureException(
        this,
        stackTrace: stackTrace,
        hint: hint,
        withScope: withScope,
      );
}
