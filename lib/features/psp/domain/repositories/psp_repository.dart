import 'package:dartz/dartz.dart';
import 'package:guilt_flutter/commons/data/model/paginate_list.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/commons/request_result.dart';
import 'package:guilt_flutter/features/psp/domain/entities/guild_psp.dart';
import 'package:guilt_flutter/features/psp/domain/entities/psp_user.dart';

abstract class PspRepository {
  Future<Either<Failure, PaginateList<GuildPsp>>> getAllGuildsByCities(List<String> cities, int page, String searchText);

  Future<Either<Failure, PaginateList<GuildPsp>>> getFollowUpGuildList(int page, List<String> cities, String searchText);

  Future<RequestResult> updateStateOfSpecialGuild(GuildPsp guild, {bool isJustState = true, String token = ""});

  Future<Either<Failure, String>> getUserPhoneNumber(int userId);

  Future<RequestResult> signUpPsp(PspUser pspUser);
}
