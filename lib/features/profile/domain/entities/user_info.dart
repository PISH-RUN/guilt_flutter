import 'package:equatable/equatable.dart';

class UserInfo extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String nationalCode;

  const UserInfo({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.nationalCode,
  });

  UserInfo copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? nationalCode,
  }) {
    return UserInfo(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      nationalCode: nationalCode ?? this.nationalCode,
    );
  }

  @override
  List<Object> get props => [id];
}
