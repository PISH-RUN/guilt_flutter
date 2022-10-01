import 'package:equatable/equatable.dart';
import 'package:guilt_flutter/commons/data/model/json_parser.dart';
import 'package:guilt_flutter/features/login/domain/entities/user_role.dart';

class UserData extends Equatable {
  final String token;
  final String phoneNumber;
  final String nationalCode;
  final UserRole role;

  const UserData({
    required this.token,
    required this.phoneNumber,
    required this.nationalCode,
    required this.role,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      token: JsonParser.stringParser(json, ['token']),
      phoneNumber: JsonParser.stringParser(json, ['phoneNumber']),
      nationalCode: JsonParser.stringParser(json, ['nationalCode']),
      role: UserRole.values.firstWhere((element) => element.name == JsonParser.stringParser(json, ['role'])),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'phoneNumber': phoneNumber,
      'nationalCode': nationalCode,
      'role': role.name,
    };
  }

  @override
  List<Object> get props => [nationalCode, token];
}
