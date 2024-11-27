import 'package:falconx/lib.dart';

extension FalconXEitherExtensions<F extends Failure, DATA> on Either<F, DATA> {
  B resolve<B>(B Function(DATA data) data, B Function(Failure fail) fail) =>
      fold(fail, data);
}

extension FalconXEitherFutureExtensions<F extends Failure, DATA>
    on Future<Either<F, DATA>> {
  Future<B> resolve<B>(
          B Function(DATA data) data, B Function(Failure fail) fail) async =>
      (await this).fold(fail, data);
}
