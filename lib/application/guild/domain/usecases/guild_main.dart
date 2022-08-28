import 'package:dartz/dartz.dart';
import 'package:guilt_flutter/application/guild/data/models/guild_model.dart';
import 'package:guilt_flutter/application/guild/domain/entities/guild.dart';
import 'package:guilt_flutter/application/guild/domain/repositories/guild_local_repository.dart';
import 'package:guilt_flutter/application/guild/domain/repositories/guild_remote_repository.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/commons/request_result.dart';
import 'package:guilt_flutter/features/profile/domain/entities/user_info.dart';

class GuildMain {
  final GuildLocalRepository guildLocalRepository;
  final GuildRemoteRepository guildRemoteRepository;

  List<Guild> guildList = [];

  GuildMain(this.guildLocalRepository, this.guildRemoteRepository);

  Future<RequestResult> updateProfileInAllGuildList({required UserInfo profile}) async {
    var guildList = (await getListOfMyGuilds(nationalCode: profile.nationalCode)).getOrElse(() => []);
    guildList = guildList
        .map((e) => e.copyWith(
            firstName: profile.firstName, nationalCode: profile.nationalCode, lastName: profile.lastName, phoneNumber: profile.phoneNumber))
        .toList();
    List<GuildModel> localGuildList = guildList.map((e) => GuildModel.fromSuper(e)).toList();
    localGuildList = [...(guildList.map((e) => GuildModel.fromSuper(e)).toList()), ...localGuildList].toSet().toList();
    guildLocalRepository.upsertGuildInLocal(profile.nationalCode, localGuildList);
    return guildRemoteRepository.updateAllData(profile.nationalCode, localGuildList);
  }

  Future<RequestResult> updateGuild({required String nationalCode, required Guild guild}) async {
    List<GuildModel> localGuildList = guildList.map((e) => GuildModel.fromSuper(e)).toList();
    localGuildList = [GuildModel.fromSuper(guild), ...(guildList.map((e) => GuildModel.fromSuper(e)).toList())].toSet().toList();
    guildLocalRepository.upsertGuildInLocal(nationalCode, localGuildList);
    guildRemoteRepository.updateAllData(nationalCode, localGuildList);
    return RequestResult.success();
  }

  Future<RequestResult> addGuild({required String nationalCode, required Guild guild}) async {
    guild = guild.copyWith(id: guildList.length);
    final response = await guildRemoteRepository.addData(nationalCode, guild);
    if (response.isLeft()) {
      return RequestResult.fromEither(response);
    }
    guildList.add(GuildModel.fromSuper(guild));
    guildLocalRepository.upsertGuildInLocal(nationalCode, guildList);
    return RequestResult.fromEither(response);
  }

  Future<Either<Failure, List<Guild>>> getListOfMyGuilds({required String nationalCode, bool isForceFromServer = false}) async {
    if (!isForceFromServer) {
      final guildList = guildLocalRepository.getListOfMyGuilds(nationalCode);
      if (guildList != null && guildList.isNotEmpty) {
        updateProfile(guildList);
        initialGuildList(guildList);
        return Right(guildList);
      }
    }
    final output = await guildRemoteRepository.getListOfMyGuilds(nationalCode);
    guildLocalRepository.replaceData(nationalCode, output.getOrElse(() => []));
    updateProfile(output.getOrElse(() => []));
    initialGuildList(guildList);
    return output;
  }

  void initialGuildList(List<Guild> list) {
    guildList = list;
  }

  void updateProfile(List<Guild> list) {
    if (list.isNotEmpty) {
      final guild = list[0];
      userInfo = UserInfo(firstName: guild.firstName, lastName: guild.lastName, phoneNumber: guild.phoneNumber, nationalCode: guild.nationalCode);
    }
  }

  Future<Either<Failure, Guild>> getFullDetailOfOneGuild({required String nationalCode, required int guildId, bool isForceFromServer = false}) async {
    if (!isForceFromServer) {
      final guild = guildLocalRepository.getFullDetailOfOneGuild(nationalCode, guildId);
      if (guild != null) {
        return Right(guild);
      }
    }
    return Right(guildList.firstWhere((element) => element.id == guildId));
  }
}
