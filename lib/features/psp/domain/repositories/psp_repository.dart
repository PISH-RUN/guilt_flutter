import 'package:dartz/dartz.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/commons/request_result.dart';
import 'package:guilt_flutter/features/psp/domain/entities/guild_psp.dart';

abstract class PspRepository {
  Future<Either<Failure, List<GuildPsp>>> getAllGuildsByCities(List<String> cities, int page);

  Future<RequestResult> updateStateOfSpecialGuild(GuildPsp guild);
}
