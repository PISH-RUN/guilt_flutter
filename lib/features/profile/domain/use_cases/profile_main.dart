import 'package:dartz/dartz.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/commons/request_result.dart';
import 'package:guilt_flutter/features/profile/domain/entities/user_info.dart';
import '../repositories/profile_repository.dart';

class ProfileMain {
  final ProfileRepository repository;

  ProfileMain(this.repository);

  Future<Either<Failure, UserInfo>> getUserInfo(UserInfo user) {
    return repository.getUserInfo(user);
  }

  Future<RequestResult> updateUserInfo(UserInfo user) {
    return repository.updateUserInfo(user);
  }
}
