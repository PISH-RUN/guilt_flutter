import 'package:collection/collection.dart';
import '../../../../commons/data/model/json_parser.dart';
import '../../domain/entities/gender_type.dart';
import '../../domain/entities/user_info.dart';

class UserInfoModel extends UserInfo {
  const UserInfoModel({
    required String imageUrl,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String nationalCode,
    required Gender gender,
  }) : super(
          imageUrl: imageUrl,
          firstName: firstName,
          lastName: lastName,
          phoneNumber: phoneNumber,
          nationalCode: nationalCode,
          gender: gender,
        );

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      imageUrl: JsonParser.stringParser(json, ['imageUrl']),
      firstName: JsonParser.stringParser(json, ['firstName']),
      lastName: JsonParser.stringParser(json, ['lastName']),
      phoneNumber: JsonParser.stringParser(json, ['phoneNumber']),
      nationalCode: JsonParser.stringParser(json, ['nationalCode']),
      gender: Gender.values.firstWhereOrNull((element) => element.name == JsonParser.stringParser(json, ['gender'])) ?? Gender.boy,
    );
  }

  factory UserInfoModel.fromSuper(UserInfo userInfo) {
    return UserInfoModel(
      imageUrl: userInfo.imageUrl,
      firstName: userInfo.firstName,
      lastName: userInfo.lastName,
      phoneNumber: userInfo.phoneNumber,
      nationalCode: userInfo.nationalCode,
      gender: userInfo.gender,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'nationalCode': nationalCode,
      'gender': gender.name,
    };
  }
}
