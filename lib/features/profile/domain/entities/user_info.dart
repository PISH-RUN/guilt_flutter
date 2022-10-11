import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/features/login/api/login_api.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'gender_type.dart';

class UserInfo extends Equatable {
  final int id;
  final String phoneNumber;
  final String nationalCode;
  final String firstName;
  final String lastName;
  final String fatherName;
  final Jalali? birthDate;
  final String? avatar;
  final Gender gender;

  const UserInfo({
    required this.id,
    required this.phoneNumber,
    required this.nationalCode,
    required this.firstName,
    required this.lastName,
    required this.fatherName,
    required this.avatar,
    required this.birthDate,
    required this.gender,
  });

  UserInfo copyWith({
    String? firstName,
    String? nationalCode,
    String? phoneNumber,
    String? lastName,
    String? fatherName,
    Gender? gender,
    Jalali? birthDate,
    String? avatar,
  }) {
    return UserInfo(
      id: id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      nationalCode: nationalCode ?? this.nationalCode,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      fatherName: fatherName ?? this.fatherName,
      avatar: avatar ?? this.avatar,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
    );
  }

  @override
  String toString() {
    return 'UserInfo{id: $id, avatar: $avatar,fatherName: $fatherName, firstName: $firstName, lastName: $lastName, gender: $gender}';
  }

  factory UserInfo.empty() => UserInfo(
        id: 0,
        firstName: "",
        lastName: "",
        fatherName: "",
        nationalCode: "",
        phoneNumber: "",
        birthDate: Jalali.now(),
        avatar: null,
        gender: Gender.boy,
      );

  @override
  List<Object> get props => [id];
}
