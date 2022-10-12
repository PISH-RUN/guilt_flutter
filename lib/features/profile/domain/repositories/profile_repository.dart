import 'package:dartz/dartz.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/commons/request_result.dart';
import 'package:guilt_flutter/features/profile/domain/entities/user_info.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserInfo>> getProfile(String nationalCode);

  Future<RequestResult> updateProfile( UserInfo userInfo);

  Future<Either<Failure, String>> changeAvatar( XFile avatar);
}