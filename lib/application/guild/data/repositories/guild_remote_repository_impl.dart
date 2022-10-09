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
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class GuildRemoteRepositoryImpl implements GuildRemoteRepository {
  final RemoteDataSource remoteDataSource;

  GuildRemoteRepositoryImpl({required this.remoteDataSource});

  String nationalCodeLocal = "";

  @override
  Future<Either<Failure, List<Guild>>> getListOfMyGuilds(String nationalCode, bool isForceRefresh) async {
    nationalCodeLocal = nationalCode;
    if (GetStorage().hasData("guilds${getLocalKeyOfUser(nationalCode)}")) {
      final guildListLocal = GuildModel.convertStringToGuildList(GetStorage().read<String>("guilds${getLocalKeyOfUser(nationalCode)}") ?? "[]");
      Logger().i("info=> ${guildListLocal.map((e) => e.id)} ");
      return Right(guildListLocal);
    }
    final output = await remoteDataSource.getFromServer<List<Guild>>(
      url: '${BASE_URL_API}guilds',
      params: {},
      localKey: 'guilds${getLocalKeyOfUser(nationalCode)}',
      mapSuccess: (data) => (data['data']['results'] as List).map((json) => GuildModel.fromJson(json)).toList(),
    );
    if (output.isRight()) {
      GetStorage()
          .write("guilds${getLocalKeyOfUser(nationalCode)}", GuildModel.convertGuildListToString(output.getOrElse(() => throw UnimplementedError())));
    }
    return output;
  }

  @override
  Future<RequestResult> updateSpecialGuild(Guild guildItem) async {
    final guildListLocal = GuildModel.convertStringToGuildList(GetStorage().read<String>("guilds${getLocalKeyOfUser(nationalCodeLocal)}") ?? "[]");
    final guild = guildListLocal.firstWhereOrNull((element) => element.uuid == guildItem.uuid);
    int guildOldId = guild == null ? guildItem.id : guild.id;
    return RequestResult.fromEither(
      await remoteDataSource.putToServer(
        url: '${BASE_URL_API}guilds/$guildOldId',
        params: GuildModel.fromSuper(guildItem).toJson(),
        mapSuccess: (guildJson) {
          final guildListLocal =
              GuildModel.convertStringToGuildList(GetStorage().read<String>("guilds${getLocalKeyOfUser(nationalCodeLocal)}") ?? "[]");
          final guildListLocalTemp = guildListLocal.map((e) => guildItem.uuid == e.uuid ? GuildModel.fromJson(guildJson['data']) : e).toList();
          GetStorage().write("guilds${getLocalKeyOfUser(nationalCodeLocal)}", GuildModel.convertGuildListToString(guildListLocalTemp));
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
      url: '${BASE_URL_API}guilds/insert',
      params: GuildModel.fromSuper(guild).toJson(),
      mapSuccess: (data) => GuildModel.fromJson(data['data']),
    );
    if (response.isRight()) {
      Logger().i("info=> ${response.getOrElse(() => throw UnimplementedError())} ");

      final guildListLocal = GuildModel.convertStringToGuildList(GetStorage().read<String>("guilds${getLocalKeyOfUser(nationalCodeLocal)}") ?? "[]");
      guildListLocal.add(response.getOrElse(() => throw UnimplementedError()));
      GetStorage().write("guilds${getLocalKeyOfUser(nationalCodeLocal)}", GuildModel.convertGuildListToString(guildListLocal));
    }
    return response;
  }
}
