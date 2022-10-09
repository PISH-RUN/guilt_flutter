import 'package:dartz/dartz.dart';
import 'package:guilt_flutter/commons/data/model/paginate_list.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/commons/request_result.dart';
import 'package:guilt_flutter/features/psp/domain/entities/psp_user.dart';
import '/features/psp/domain/entities/guild_psp.dart';
import '../repositories/psp_repository.dart';

class PspMain {
  final PspRepository repository;

  PspMain(this.repository);

  Future<Either<Failure, PaginateList<GuildPsp>>> getAllGuildsByCities(
      {required List<String> cities, required int page, required String searchText}) {
    return repository.getAllGuildsByCities(cities, page, searchText);
  }

  Future<Either<Failure, PaginateList<GuildPsp>>> getFollowUpGuildList(
      {required int page, required List<String> cities, required String searchText}) {
    return repository.getFollowUpGuildList(page, cities, searchText);
  }

  Future<RequestResult> updateStateOfSpecialGuild(GuildPsp guildPsp, {bool isJustState = true, String token = ""}) {
    return repository.updateStateOfSpecialGuild(guildPsp, isJustState: isJustState, token: token);
  }

  Future<Either<Failure, String>> getUserPhoneNumber(int userId) {
    return repository.getUserPhoneNumber(userId);
  }

  Future<RequestResult> signUpPsp(PspUser pspUser) {
    return repository.signUpPsp(pspUser);
  }
}
