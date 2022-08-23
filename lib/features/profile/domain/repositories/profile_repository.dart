import 'package:dartz/dartz.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/commons/request_result.dart';
import 'package:guilt_flutter/features/profile/domain/entities/user_info.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserInfo>> getUserInfo(UserInfo user);

  Future<RequestResult> updateUserInfo(UserInfo user);
}
