import 'package:guilt_flutter/commons/data/model/json_parser.dart';
import '../../domain/entities/user_info.dart';

class UserInfoModel extends UserInfo {
  const UserInfoModel({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String nationalCode,
  }) : super(
          firstName: firstName,
          lastName: lastName,
          phoneNumber: phoneNumber,
          nationalCode: nationalCode,
        );

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      firstName: JsonParser.stringParser(json, ['firstName']),
      lastName: JsonParser.stringParser(json, ['lastName']),
      phoneNumber: JsonParser.stringParser(json, ['phoneNumber']),
      nationalCode: JsonParser.stringParser(json, ['nationalCode']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "phoneNumber": phoneNumber,
      "nationalCode": nationalCode,
    };
  }
}
