import 'package:guilt_flutter/commons/data/model/json_parser.dart';
import 'package:guilt_flutter/features/login/domain/entities/user_role.dart';

import '../../domain/entities/user_data.dart';

class UserDataModel extends UserData {
  const UserDataModel({
    required String token,
    required String phoneNumber,
    required String nationalCode,
    required UserRole role,
  }) : super(
          token: token,
          phoneNumber: phoneNumber,
          nationalCode: nationalCode,
          role: role,
        );

  factory UserDataModel.fromJson({required String nationalCode, required String phoneNumber, required Map<String, dynamic> json}) {
    return UserDataModel(
      token: JsonParser.stringParser(json, ['access_token']),
      role: UserRole.values.firstWhere((element) => element.name == JsonParser.stringParser(json, ['role'])),
      phoneNumber: phoneNumber,
      nationalCode: nationalCode,
    );
  }
}
