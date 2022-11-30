import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:get_storage/get_storage.dart';
import 'package:guilt_flutter/application/constants.dart';
import 'package:guilt_flutter/commons/data/data_source/remote_data_source.dart';
import 'package:guilt_flutter/commons/data/model/server_failure.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/features/login/domain/entities/user_role.dart';

import '../../domain/entities/user_data.dart';
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

  String globalPhoneNumber = "";

  @override
  Future<Either<Failure, bool>> registerWithPhoneNumber({required String phoneNumber, required String nationalCode}) async {
    globalPhoneNumber = phoneNumber;
    Either<ServerFailure, bool> result = await dataSource.postToServer<bool>(
      url: "${BASE_URL_API}users/otp",
      isTokenNeed: false,
      params: {'mobile': "0$phoneNumber", 'national_code': nationalCode},
      mapSuccess: (Map<String, dynamic> data) => true,
    );

    return result.fold((l) => l.message == "mobile and national_code mismatch" ? Left(Failure("شماره تلفن وارد شده، متعلق به کدملی دریافتی نمی باشد")) : Left(l), (r) => const Right(true));
  }

  @override
  Future<Either<Failure, UserData>> loginWithOtp(String nationalCode, String otp) async {
    Either<ServerFailure, UserData> result = await dataSource.postToServer<UserData>(
      url: '${BASE_URL_API}users/verify',
      params: {'national_code': nationalCode, 'otp': otp},
      isTokenNeed: false,
      mapSuccess: (Map<String, dynamic> data) =>
          UserDataModel.fromJson(nationalCode: nationalCode, phoneNumber: globalPhoneNumber, json: data['data']),
    );
    return result.fold((l) => l.statusCode == 400 ? Left(ServerFailure.fromMessage("کد ورود به سامانه اصناف صحیح نمی باشد")) : Left(l),
        (r) => Right(result.getOrElse(() => throw UnimplementedError())));
  }

  @override
  UserData getUserData() {
    final jsonText = GetStorage().read<String>('userData');
    if (jsonText == null) {
      return const UserData(token: '', phoneNumber: '', nationalCode: '', role: UserRole.user);
    }
    return UserData.fromJson(jsonDecode(jsonText));
  }
}
