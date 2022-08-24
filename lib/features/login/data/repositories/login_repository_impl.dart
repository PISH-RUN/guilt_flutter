import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:guilt_flutter/application/constants.dart';
import 'package:guilt_flutter/commons/data/data_source/remote_data_source.dart';
import 'package:guilt_flutter/commons/data/model/server_failure.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../domain/entities/login.dart';
import '../../domain/repositories/login_repository.dart';
import '../models/login_model.dart';

class LoginRepositoryImpl implements LoginRepository {
  final RemoteDataSource dataSource;
  final String Function(String key) readDataFromLocal;
  final void Function(String key, String value) writeDataToLocal;

  LoginRepositoryImpl({
    required this.dataSource,
    required this.readDataFromLocal,
    required this.writeDataToLocal,
  });

  @override
  Future<Either<Failure, bool>> registerWithPhoneNumber({required String phoneNumber, required String nationalCode}) async {
    setUserId(nationalCode);
    String appNumber = (await PackageInfo.fromPlatform()).buildNumber;
    Either<ServerFailure, bool> result = await dataSource.postToServer<bool>(
      url: "$BASE_URL_API/api/v1/otp",
      params: {'mobile': "0$phoneNumber", 'nationalcode': nationalCode},
      mapSuccess: (Map<String, dynamic> data) => true,
    );
    return result.fold(
        (l) => l.statusCode == 400 ? Left(ServerFailure.fromMessage("شماره موبایل فرمت درستی ندارد")) : Left(l), (r) => const Right(true));
  }

  @override
  Future<Either<Failure, bool>> loginWithOtp(String nationalCode, String otp) async {
    setUserId(nationalCode);
    String appNumber = (await PackageInfo.fromPlatform()).buildNumber;
    Either<ServerFailure, Login> result = await dataSource.postToServer<Login>(
      url: '${BASE_URL_API}/api/v1/otp/verify',
      params: {'nationalcode': nationalCode, 'otp': otp},
      mapSuccess: (Map<String, dynamic> data) => LoginModel.fromJson(data),
    );

    saveTokenInStorage(result.getOrElse(() => LoginModel(token: "")).token);
    return result.fold(
        (l) => l.statusCode == 400 ? Left(ServerFailure.fromMessage("کد تایید وارد شده اشتباه است")) : Left(l), (r) => const Right(true));
  }

  @override
  String getToken() {
    log("token is====> ${readDataFromLocal(TOKEN_KEY_SAVE_IN_LOCAL)}");
    return readDataFromLocal(TOKEN_KEY_SAVE_IN_LOCAL);
  }

  @override
  void saveTokenInStorage(String token) {
    writeDataToLocal(TOKEN_KEY_SAVE_IN_LOCAL, token);
  }

  @override
  String getUserId() {
    return readDataFromLocal(USER_ID);
  }

  void setUserId(String userId) {
    writeDataToLocal(USER_ID, userId);
  }
}
