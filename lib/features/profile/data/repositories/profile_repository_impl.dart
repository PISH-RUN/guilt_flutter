import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/features/login/api/login_api.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../application/constants.dart';
import '../../../../application/get_local_key_of_user.dart';
import '../../../../application/guild/api/guild_api.dart';
import '../../../../commons/data/data_source/remote_data_source.dart';
import '../../../../commons/failures.dart';
import '../../../../commons/request_result.dart';
import '../../domain/entities/user_info.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/user_info_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final RemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<RequestResult> changeAvatar(XFile avatar) async {
    final output = await remoteDataSource.postMultipartToServer(
      url: '${BASE_URL_API}users/record/image',
      attachName: 'image',
      imageName: 'image',
      image: avatar,
      localKey: getLocalKeyOfUser(GetIt.instance<LoginApi>().getUserData().nationalCode),
      bodyParameters: {},
    );
    if (!output.isSuccess) {
      return output;
    }
    await GetIt.instance<GuildApi>().getMyGuildList(nationalCode: GetIt.instance<LoginApi>().getUserData().nationalCode, isForceRefresh: true);
    return RequestResult.success();
  }

  @override
  Future<Either<Failure, UserInfo>> getProfile(String nationalCode) async {
    return remoteDataSource.getFromServer<UserInfo>(
      url: '${BASE_URL_API}users',
      localKey: getLocalKeyOfUser(nationalCode),
      params: {},
      mapSuccess: (data) => UserInfoModel.fromJson(data['data']),
    );
  }

  @override
  Future<RequestResult> updateProfile(UserInfo userInfo) async {
    return RequestResult.fromEither(await remoteDataSource.postToServer(
      url: '${BASE_URL_API}users',
      localKey: getLocalKeyOfUser(GetIt.instance<LoginApi>().getUserData().nationalCode),
      params: UserInfoModel.fromSuper(userInfo).toJson(),
      mapSuccess: (data) => UserInfoModel.fromJson(data['data']),
    ));
  }
}
