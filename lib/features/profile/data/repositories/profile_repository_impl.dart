import 'package:dartz/dartz.dart';
import 'package:guilt_flutter/application/constants.dart';
import 'package:guilt_flutter/features/profile/data/models/user_info_model.dart';
import 'package:guilt_flutter/features/profile/domain/entities/user_info.dart';
import 'package:guilt_flutter/features/profile/domain/repositories/profile_repository.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../commons/data/data_source/remote_data_source.dart';
import '../../../../commons/failures.dart';
import '../../../../commons/request_result.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final RemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<RequestResult> changeAvatar(String nationalCode, XFile avatar) {
    return remoteDataSource.postMultipartToServer(
      url: '${BASE_URL_API}upload',
      attachName: 'avatar',
      imageName: 'avatar',
      image: avatar,
      localKey: 'profile$nationalCode',
      bodyParameters: {"ref": "plugin::users-permissions.user", "field": 'avatar'},
    );
  }

  @override
  Future<Either<Failure, UserInfo>> getProfile(String nationalCode) {
    return remoteDataSource.getFromServer<UserInfo>(
      url: '$BASE_URL_API/api/v1/users/$nationalCode',
      params: {},
      localKey: 'profile$nationalCode',
      mapSuccess: (json) => UserInfoModel.fromJson(json),
    );
  }

  @override
  Future<RequestResult> updateProfile(String nationalCode, UserInfo userInfo) async {
    return RequestResult.fromEither(await remoteDataSource.postToServer(
      url: '$BASE_URL_API/api/v1/users/record/$nationalCode',
      params: UserInfoModel.fromSuper(userInfo).toJson(),
      localKey: 'profile$nationalCode',
      mapSuccess: (date) => true,
    ));
  }
}
