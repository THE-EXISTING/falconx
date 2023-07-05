import 'package:falconx/lib.dart';

extension SentryExtension on Object? {
  Future<SentryId> sentryCaptureException(
    dynamic stackTrace, {
    Hint? hint,
    ScopeCallback? withScope,
  }) =>
      Sentry.captureException(
        this,
        stackTrace: stackTrace,
        hint: hint,
        withScope: withScope,
      );
}
