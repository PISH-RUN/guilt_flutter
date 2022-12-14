import 'package:dartz/dartz.dart';
import 'package:guilt_flutter/application/guild/domain/entities/guild.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/commons/request_result.dart';
import 'package:image_picker/image_picker.dart';

abstract class GuildRemoteRepository {
  Future<Either<Failure, List<Guild>>> getListOfMyGuilds(String nationalCode);

  Future<RequestResult> updateSpecialGuild(Guild guildItem);

  Future<Either<Failure, String>> updateAvatar(Guild guild, XFile avatar);

  Future<Either<Failure, Guild>> addGuild(String nationalCode, Guild guild);
}
