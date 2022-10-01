import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:guilt_flutter/application/constants.dart';
import 'package:guilt_flutter/application/get_local_key_of_user.dart';
import 'package:guilt_flutter/application/guild/data/models/guild_model.dart';
import 'package:guilt_flutter/application/guild/domain/entities/guild.dart';
import 'package:guilt_flutter/application/guild/domain/repositories/guild_remote_repository.dart';
import 'package:guilt_flutter/commons/data/data_source/remote_data_source.dart';
import 'package:guilt_flutter/commons/data/model/server_failure.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/commons/request_result.dart';
import 'package:guilt_flutter/features/login/api/login_api.dart';
import 'package:guilt_flutter/features/profile/api/profile_api.dart';
import 'package:http/http.dart' as http;

class GuildRemoteRepositoryImpl implements GuildRemoteRepository {
  final RemoteDataSource remoteDataSource;

  GuildRemoteRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Guild>>> getListOfMyGuilds(String nationalCode, bool isForceRefresh) {
    return remoteDataSource.getListFromServer<Guild>(
      url: '${BASE_URL_API}users/record/$nationalCode',
      params: {},
      isForceRefresh: isForceRefresh,
      localKey: getLocalKeyOfUser(nationalCode),
      mapSuccess: (data) => data.mapIndexed((index, json) => GuildModel.fromJson(json, index)).toList(),
    );
  }

  @override
  Future<RequestResult> updateAllData(String nationalCode, List<Guild> guildList) async {
    final json = guildList.map((guild) => GuildModel.fromSuper(guild).toJson()).toList();
    GetStorage().write(getLocalKeyOfUser(nationalCode), jsonEncode(json));
    return RequestResult.fromEither(
      await remoteDataSource.postToServer(
        url: '${BASE_URL_API}users/record/$nationalCode/upsert',
        params: json,
        mapSuccess: (_) {
          GetStorage().write(getLocalKeyOfUser(nationalCode), jsonEncode(guildList.map((guild) => GuildModel.fromSuper(guild).toJson()).toList()));
          return true;
        },
      ),
    );
  }

  void handleGlobalErrorInServer(http.Response response) {
    if (response.statusCode == AUTHENTICATION_IS_WRONG_STATUS_CODE) GetIt.instance<LoginApi>().signOut();
  }

  @override
  Future<Either<Failure, Guild>> addGuild(String nationalCode, Guild guild) async {
    final response = await remoteDataSource.postToServer(
      url: '${BASE_URL_API}users/record/$nationalCode',
      params: GuildModel.fromSuper(guild).toJson(),
      mapSuccess: (date) => guild,
    );
    if (response.isRight()) {
      final listJson = jsonDecode(GetStorage().read<String>(getLocalKeyOfUser(nationalCode)) ?? "[]") as List;
      listJson.add(GuildModel.fromSuper(guild).toJson());
      GetStorage().write(getLocalKeyOfUser(nationalCode), jsonEncode(listJson));
    }
    return response;
  }
}
