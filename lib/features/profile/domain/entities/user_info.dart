import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/features/login/api/login_api.dart';
import 'gender_type.dart';

class UserInfo extends Equatable {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String nationalCode;
  final String? avatar;
  final Gender gender;

  const UserInfo({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.nationalCode,
    required this.avatar,
    required this.gender,
  });

  UserInfo copyWith({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    Gender? gender,
    String? avatar,
  }) {
    return UserInfo(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatar: avatar ?? this.avatar,
      nationalCode: nationalCode,
      gender: gender ?? this.gender,
    );
  }

  @override
  String toString() {
    return 'UserInfo{avatar: $avatar, firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber, nationalCode: $nationalCode, gender: $gender}';
  }

  factory UserInfo.empty() => UserInfo(
        nationalCode: GetIt.instance<LoginApi>().getUserId(),
        firstName: "",
        lastName: "",
        phoneNumber: GetIt.instance<LoginApi>().getUserPhone(),
        avatar: null,
        gender: Gender.boy,
      );

  @override
  List<Object> get props => [nationalCode];
}
