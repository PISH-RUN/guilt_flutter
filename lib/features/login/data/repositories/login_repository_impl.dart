import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:guilt_flutter/application/constants.dart';
import 'package:guilt_flutter/commons/data/data_source/local_storage_data_source.dart';
import 'package:guilt_flutter/commons/data/data_source/remote_data_source.dart';
import 'package:guilt_flutter/commons/data/model/server_failure.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/commons/request_result.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../models/login_model.dart';
import '../../domain/entities/login.dart';
import '../../domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final RemoteDataSource dataSource;
  final LocalStorageDataSource localStorageDataSource;

  LoginRepositoryImpl({
    required this.dataSource,
    required this.localStorageDataSource,
  });

  @override
  Future<Either<Failure, bool>> registerWithPhoneNumber({required String phoneNumber, required String nationalCode}) async {
    String appNumber = (await PackageInfo.fromPlatform()).buildNumber;
    Either<ServerFailure, bool> result = await dataSource.postToServer<bool>(
      url: "${BASE_URL_API}auth/otp",
      params: {'mobile': "+98$phoneNumber", 'app_version': appNumber},
      mapSuccess: (Map<String, dynamic> data) => true,
    );
    return result.fold((l) => l.statusCode == 400 ? Left(ServerFailure.fromMessage("شماره موبایل فرمت درستی ندارد")) : Left(l), (r) => Right(true));
  }

  @override
  Future<Either<Failure, bool>> loginWithOtp(String phoneNumber, String otp) async {
    String appNumber = (await PackageInfo.fromPlatform()).buildNumber;
    Either<ServerFailure, Login> result = await dataSource.postToServer<Login>(
        url: '${BASE_URL_API}auth/login',
        params: {'mobile': "+98$phoneNumber", 'token': otp, 'app_version': appNumber},
        mapSuccess: (Map<String, dynamic> data) => LoginModel.fromJson(data));

    saveTokenInStorage(result.getOrElse(() => LoginModel(token: "")).token);
    return result.fold(
        (l) => l.statusCode == 400 ? Left(ServerFailure.fromMessage("کد تایید وارد شده اشتباه است")) : Left(l), (r) => const Right(true));
  }

  @override
  String getToken() {
    log("token is====> ${localStorageDataSource.getStringWithKey(TOKEN_KEY_SAVE_IN_LOCAL)}");
    return localStorageDataSource.getStringWithKey(TOKEN_KEY_SAVE_IN_LOCAL);
  }

  @override
  void saveTokenInStorage(String token) {
    localStorageDataSource.setStringWithKey(TOKEN_KEY_SAVE_IN_LOCAL, token);
  }
}
