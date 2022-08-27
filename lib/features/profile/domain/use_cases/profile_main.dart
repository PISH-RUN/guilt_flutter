import 'package:dartz/dartz.dart';
import 'package:guilt_flutter/application/guild/domain/usecases/guild_main.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/commons/request_result.dart';
import 'package:guilt_flutter/features/profile/domain/entities/user_info.dart';

class ProfileMain {
  final GuildMain guild;

  ProfileMain(this.guild);

  Future<Either<Failure, UserInfo>> getUserInfo(UserInfo user) async {
    return Right(userInfo);
  }

  Future<RequestResult> updateUserInfo(UserInfo user) {
    return guild.updateProfileInAllGuildList(profile: user);
  }
}
