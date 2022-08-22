import 'package:dartz/dartz.dart';
import 'failures.dart';

class RequestResult {
  final bool isSuccess;
  final Failure? failure;

  const RequestResult({required this.isSuccess, required this.failure});

  factory RequestResult.success() => const RequestResult(isSuccess: true, failure: null);

  factory RequestResult.failure(Failure failure) => RequestResult(isSuccess: false, failure: failure);

  factory RequestResult.fromEither(Either<Failure, dynamic> input) => input.fold((l) => RequestResult.failure(l), (r) => RequestResult.success());

  void fold(void Function(Failure failure) failure, void Function() success) {
    if (isSuccess) {
      return success();
    } else {
      return failure(this.failure!);
    }
  }
}
