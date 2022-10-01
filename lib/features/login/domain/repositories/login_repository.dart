import 'package:dartz/dartz.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/features/login/domain/entities/user_data.dart';

abstract class LoginRepository {
  Future<Either<Failure, bool>> registerWithPhoneNumber({required String phoneNumber, required String nationalCode});

  Future<Either<Failure, bool>> loginWithOtp(String nationalCode, String otp);

  UserData getUserData();
}
