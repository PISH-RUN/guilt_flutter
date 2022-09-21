import 'package:dartz/dartz.dart';
import 'package:guilt_flutter/commons/data/model/paginate_list.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/commons/request_result.dart';
import '/features/psp/domain/entities/guild_psp.dart';
import '../repositories/psp_repository.dart';

class PspMain {
  final PspRepository repository;

  PspMain(this.repository);

  Future<Either<Failure, PaginateList<GuildPsp>>> getAllGuildsByCities(List<String> cities, int page, bool isJustMine, String searchText) {
    return repository.getAllGuildsByCities(cities, page, isJustMine, searchText);
  }

  Future<RequestResult> updateStateOfSpecialGuild(GuildPsp guildPsp, String token) {
    return repository.updateStateOfSpecialGuild(guildPsp, token);
  }
}
