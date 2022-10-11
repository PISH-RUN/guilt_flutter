import 'package:dartz/dartz.dart';
import 'package:guilt_flutter/application/constants.dart';
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
    if (appMode == AppMode.psp) {
      return const Right(true);
    }
    final output = await main.getProfile(nationalCode);
    return output.fold(
      (failure) => Left(failure),
      (user) => Right(user.firstName.isNotEmpty && user.lastName.isNotEmpty),
    );
  }
}
