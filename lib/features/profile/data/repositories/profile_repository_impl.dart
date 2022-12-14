import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/commons/data/model/json_parser.dart';
import 'package:guilt_flutter/features/login/api/login_api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import '../../../../application/constants.dart';
import '../../../../application/get_local_key_of_user.dart';
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
  Future<Either<Failure, String>> changeAvatar(XFile avatar) async {
    final output = await remoteDataSource.postMultipartToServer(
      url: '${BASE_URL_API}users/image',
      attachName: 'image',
      imageName: 'image',
      imageFile: avatar,
      localKey: getLocalKeyOfUser(GetIt.instance<LoginApi>().getUserData().nationalCode),
      bodyParameters: {},
    );
    return output.fold((l) => Left(l), (json) {
      String url = json.substring(json.indexOf('image_url:') + 'image_url:'.length);
      url = url.split('}')[0];
      return Right(url);
    });
  }

  @override
  Future<Either<Failure, UserInfo>> getProfile(String nationalCode) async {
    return remoteDataSource.getFromServer<UserInfo>(
      url: '${BASE_URL_API}users',
      localKey: getLocalKeyOfUser(nationalCode),
      params: {},
      mapSuccess: (data) => JsonParser.parser(data, ['data']) == null
          ? UserInfo.empty().copyWith(nationalCode: nationalCode, phoneNumber: GetIt.instance<LoginApi>().getUserData().phoneNumber)
          : UserInfoModel.fromJson(JsonParser.parser(data, ['data'])),
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
