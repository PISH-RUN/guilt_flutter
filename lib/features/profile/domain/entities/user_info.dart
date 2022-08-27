import 'package:equatable/equatable.dart';

UserInfo userInfo = UserInfo.empty();

class UserInfo extends Equatable {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String nationalCode;

  const UserInfo({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.nationalCode,
  });

  UserInfo copyWith({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? nationalCode,
  }) {
    return UserInfo(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      nationalCode: nationalCode ?? this.nationalCode,
    );
  }

  factory UserInfo.empty() => const UserInfo(nationalCode: "", firstName: "", lastName: "", phoneNumber: "");

  @override
  List<Object> get props => [nationalCode];
}
