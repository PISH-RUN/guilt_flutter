import 'package:dartz/dartz.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/commons/request_result.dart';
import 'package:guilt_flutter/features/profile/domain/entities/user_info.dart';
import 'package:guilt_flutter/features/profile/domain/repositories/profile_repository.dart';
import 'package:image_picker/image_picker.dart';

class ProfileMain {
  final ProfileRepository repository;

  ProfileMain(this.repository);

  Future<Either<Failure, UserInfo>> getProfile(String nationalCode) async {
    return repository.getProfile(nationalCode);
  }

  Future<RequestResult> updateUserInfo(UserInfo user) {
    return repository.updateProfile(user);
  }

  Future<RequestResult> changeAvatar(XFile avatar) {
    return repository.changeAvatar(avatar);
  }
}
