import 'package:dartz/dartz.dart';
import 'package:guilt_flutter/application/guild/domain/entities/guild.dart';
import 'package:guilt_flutter/application/guild/domain/repositories/guild_remote_repository.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/commons/request_result.dart';
import 'package:image_picker/image_picker.dart';

class GuildMain {
  final GuildRemoteRepository guildRemoteRepository;

  GuildMain(this.guildRemoteRepository);

  Future<RequestResult> updateGuild({required Guild guild}) async {
    await guildRemoteRepository.updateSpecialGuild(guild);
    return RequestResult.success();
  }

  Future<RequestResult> addGuild({required String nationalCode, required Guild guild}) async {
    final response = await guildRemoteRepository.addGuild(nationalCode, guild);
    if (response.isLeft()) {
      return RequestResult.fromEither(response);
    }
    return RequestResult.fromEither(response);
  }

  Future<Either<Failure, String>> updateAvatar({required Guild guild, required XFile avatar}) async {
    return guildRemoteRepository.updateAvatar(guild, avatar);
  }

  Future<Either<Failure, List<Guild>>> getListOfMyGuilds({required String nationalCode}) async {
    return (await guildRemoteRepository.getListOfMyGuilds(nationalCode)).fold((l) => left(l), (r) => Right(r));
  }

  Future<Either<Failure, Guild>> getFullDetailOfOneGuild(
      {required String nationalCode, required String guildUuid, bool isForceFromServer = false}) async {
    final response = await getListOfMyGuilds(nationalCode: nationalCode);
    return response.fold((l) => Left(l), (guildList) => Right(guildList.firstWhere((element) => element.uuid == guildUuid)));
  }
}
