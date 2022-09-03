import 'package:dartz/dartz.dart';
import 'package:guilt_flutter/commons/failures.dart';

abstract class LoginRepository {
  Future<Either<Failure, bool>> registerWithPhoneNumber({required String phoneNumber, required String nationalCode});

  Future<Either<Failure, bool>> loginWithOtp(String nationalCode, String otp);

  String getToken();

  String getUserId();

  String getUserPhone();

  void saveTokenInStorage(String token);
}
