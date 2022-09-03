import 'package:collection/collection.dart';
import '../../../../commons/data/model/json_parser.dart';
import '../../domain/entities/gender_type.dart';
import '../../domain/entities/user_info.dart';

class UserInfoModel extends UserInfo {
  const UserInfoModel({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String nationalCode,
    required String? avatar,
    required Gender gender,
  }) : super(
          firstName: firstName,
          lastName: lastName,
          phoneNumber: phoneNumber,
          nationalCode: nationalCode,
          gender: gender,
          avatar: avatar,
        );

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      firstName: JsonParser.stringParser(json, ['firstName']),
      lastName: JsonParser.stringParser(json, ['lastName']),
      phoneNumber: JsonParser.stringParser(json, ['phoneNumber']),
      nationalCode: JsonParser.stringParser(json, ['nationalCode']),
      avatar: JsonParser.stringParser(json, ['Image']),
      gender: Gender.values.firstWhereOrNull((element) => element.name == JsonParser.stringParser(json, ['gender'])) ?? Gender.boy,
    );
  }

  factory UserInfoModel.fromSuper(UserInfo userInfo) {
    return UserInfoModel(
      firstName: userInfo.firstName,
      lastName: userInfo.lastName,
      phoneNumber: userInfo.phoneNumber,
      nationalCode: userInfo.nationalCode,
      gender: userInfo.gender,
      avatar: userInfo.avatar,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'avatar': avatar,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'nationalCode': nationalCode,
      'gender': gender.name,
    };
  }
}
