import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/application/guild/api/guild_api.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/features/profile/domain/entities/user_info.dart';
import 'package:guilt_flutter/features/profile/domain/use_cases/profile_main.dart';

class ProfileApi {
  final ProfileMain main;

  ProfileApi(this.main);

  Future<Either<Failure, UserInfo>> getProfile({required String nationalCode}) async {
    return main.getProfile(nationalCode);
  }

  Future<Either<Failure, bool>> hasProfile({required String nationalCode}) async {
    final output = await main.getProfile(nationalCode);
    return output.fold(
      (failure) => failure.failureType == FailureType.haveNoGuildAndProfile ? const Right(false) : Left(failure),
      (user) => Right(user.firstName.isNotEmpty && user.lastName.isNotEmpty && user.nationalCode.isNotEmpty && user.phoneNumber.isNotEmpty),
    );
  }
}
