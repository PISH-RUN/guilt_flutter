import 'package:dartz/dartz.dart';
import 'package:guilt_flutter/application/guild/domain/entities/guild.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/commons/request_result.dart';
import 'package:guilt_flutter/features/psp/domain/entities/guild_psp.dart';
import '../repositories/psp_repository.dart';

class PspMain {
  final PspRepository repository;

  PspMain(this.repository);

  Future<Either<Failure, List<GuildPsp>>> getAllGuildsByCities(List<String> cities, int page) {
    return repository.getAllGuildsByCities(cities, page);
  }

  Future<RequestResult> updateStateOfSpecialGuild(GuildPsp guildPsp) {
    return repository.updateStateOfSpecialGuild(guildPsp);
  }
}
