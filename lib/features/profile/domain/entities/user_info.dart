import 'package:equatable/equatable.dart';
import 'gender_type.dart';

UserInfo userInfo = UserInfo.empty();

class UserInfo extends Equatable {
  final String imageUrl;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String nationalCode;
  final Gender gender;

  const UserInfo({
    required this.imageUrl,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.nationalCode,
    required this.gender,
  });

  UserInfo copyWith({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    Gender? gender,
    String? imageUrl,
  }) {
    return UserInfo(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      nationalCode: nationalCode,
      gender: gender ?? this.gender,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory UserInfo.empty() => const UserInfo(nationalCode: "", firstName: "", lastName: "", phoneNumber: "", imageUrl: "", gender: Gender.boy);

  @override
  List<Object> get props => [nationalCode];
}
