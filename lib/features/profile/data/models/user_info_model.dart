import 'package:collection/collection.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import '../../../../commons/data/model/json_parser.dart';
import '../../domain/entities/gender_type.dart';
import '../../domain/entities/user_info.dart';

class UserInfoModel extends UserInfo {
  const UserInfoModel({
    required int id,
    required String firstName,
    required String lastName,
    required String fatherName,
    required String? avatar,
    required Gender gender,
    required Jalali? birthDate,
  }) : super(
          id: id,
          firstName: firstName,
          lastName: lastName,
          fatherName: fatherName,
          gender: gender,
          avatar: avatar,
          birthDate: birthDate,
        );

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      id: JsonParser.intParser(json, ['user_id']),
      firstName: JsonParser.stringParser(json, ['first_name']),
      lastName: JsonParser.stringParser(json, ['last_name']),
      fatherName: JsonParser.stringParser(json, ['father_name']),
      avatar: JsonParser.stringParser(json, ['Image']),
      birthDate: JsonParser.stringParser(json, ['birth_date']).isEmpty
          ? null
          : Jalali(
              int.parse(JsonParser.stringParser(json, ['birth_date']).substring(0, 4)),
              int.parse(JsonParser.stringParser(json, ['birth_date']).substring(4, 6)),
              int.parse(JsonParser.stringParser(json, ['birth_date']).substring(6, 8)),
            ),
      gender: Gender.values.firstWhereOrNull((element) => element.code == JsonParser.intParser(json, ['gender'])) ?? Gender.boy,
    );
  }

  factory UserInfoModel.fromSuper(UserInfo userInfo) {
    return UserInfoModel(
      id: userInfo.id,
      firstName: userInfo.firstName,
      lastName: userInfo.lastName,
      fatherName: userInfo.fatherName,
      birthDate: userInfo.birthDate,
      gender: userInfo.gender,
      avatar: userInfo.avatar,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'avatar': avatar,
      'last_name': lastName,
      'father_name': fatherName,
      'birth_date':
          birthDate == null ? null : "${birthDate!.year}${birthDate!.month.toString().padLeft(2, '0')}${birthDate!.day.toString().padLeft(2, '0')}",
      'gender': gender.code,
    };
  }
}
