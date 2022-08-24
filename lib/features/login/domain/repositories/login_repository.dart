import 'package:dartz/dartz.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/commons/request_result.dart';

abstract class LoginRepository {
  Future<Either<Failure, bool>> registerWithPhoneNumber({required String phoneNumber,required String nationalCode});

  Future<Either<Failure, bool>> loginWithOtp(String nationalCode, String otp);

  String getToken();
  String getUserId();

  void saveTokenInStorage(String token);
}
