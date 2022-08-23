import 'package:dartz/dartz.dart';
import 'package:guilt_flutter/commons/data/data_source/remote_data_source.dart';
import 'package:guilt_flutter/commons/data/model/json_parser.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/commons/request_result.dart';
import 'package:guilt_flutter/features/profile/data/models/user_info_model.dart';
import 'package:guilt_flutter/features/profile/domain/entities/user_info.dart';
import '../../../../application/constants.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final RemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, UserInfo>> getUserInfo(UserInfo user) {
    final output = remoteDataSource.getFromServer<UserInfo>(
      url: '${BASE_URL_API}users/me',
      params: {},
      mapSuccess: (Map<String, dynamic> json) => UserInfoModel.fromJson(JsonParser.parser(json, ['data'])),
    );
    return output;
  }

  @override
  Future<RequestResult> updateUserInfo(UserInfo user) async {
    final output = await remoteDataSource.postToServer<bool>(
      url: '${BASE_URL_API}users/me',
      params: {},
      mapSuccess: (Map<String, dynamic> json) => true,
    );
    return RequestResult.fromEither(output);
  }
}
