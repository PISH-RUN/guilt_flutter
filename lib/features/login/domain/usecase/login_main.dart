import 'package:dartz/dartz.dart';
import 'package:guilt_flutter/commons/failures.dart';

import '../repositories/login_repository.dart';

class LoginMain {
  final LoginRepository repository;

  LoginMain(this.repository);

  Future<Either<Failure, bool>> loginWithOtp({required String phoneNumber, required String password}) {
    return repository.loginWithOtp(phoneNumber, password);
  }

  Future<Either<Failure, bool>> registerWithPhoneNumber({required String phoneNumber, required String nationalCode}) {
    return repository.registerWithPhoneNumber(phoneNumber: phoneNumber, nationalCode: nationalCode);
  }

  Future<Either<Failure, bool>> resendVerifyCode({required String phoneNumber, required String nationalCode}) {
    return registerWithPhoneNumber(phoneNumber: phoneNumber, nationalCode: nationalCode);
  }
}
