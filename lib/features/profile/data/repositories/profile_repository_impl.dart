import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

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
  Future<RequestResult> changeAvatar(String nationalCode, XFile avatar) async {
    Logger().i("info=> ${nationalCode} ");
    final output = await remoteDataSource.postMultipartToServer(
      url: '$BASE_URL_API/api/v1/users/record/$nationalCode/image',
      attachName: 'image',
      imageName: 'image',
      image: avatar,
      localKey: getLocalKeyOfUser(nationalCode),
      bodyParameters: {},
    );
    if (!output.isSuccess) {
      return output;
    }
    await GetIt.instance<GuildApi>().getMyGuildList(nationalCode: nationalCode, isForceRefresh: true);
    return RequestResult.success();
  }

  @override
  Future<Either<Failure, UserInfo>> getProfile(String nationalCode) async {
    final response = await GetIt.instance<GuildApi>().getMyGuildList(nationalCode: nationalCode);
    return response.fold((failure) => Left(failure), (guilds) {
      if (guilds.isEmpty) {
        if (GetStorage().hasData('profileTemp')) {
          return Right(UserInfoModel.fromJson(jsonDecode(GetStorage().read('profileTemp'))));
        }
        return Left(Failure.haveNoGuild());
      }
      GetStorage().remove('profileTemp');
      return Right(UserInfo(
        avatar: guilds[0].avatar,
        firstName: guilds[0].firstName,
        lastName: guilds[0].lastName,
        phoneNumber: guilds[0].phoneNumber,
        nationalCode: guilds[0].nationalCode,
        gender: guilds[0].gender,
      ));
    });
  }

  @override
  Future<RequestResult> updateProfile(String nationalCode, UserInfo userInfo) async {
    final response = await GetIt.instance<GuildApi>().getMyGuildList(nationalCode: nationalCode);
    return response.fold((l) => RequestResult.failure(l), (guildList) {
      if (guildList.isEmpty) {
        GetStorage().write('profileTemp', jsonEncode(UserInfoModel.fromSuper(userInfo).toJson()));
        return RequestResult.success();
      }
      guildList = guildList
          .map((guild) => guild.copyWith(
                firstName: userInfo.firstName,
                lastName: userInfo.lastName,
                phoneNumber: userInfo.phoneNumber,
                gender: userInfo.gender,
              ))
          .toList();
      return GetIt.instance<GuildApi>().updateGuildList(nationalCode: nationalCode, guildList: guildList);
    });
  }
}
