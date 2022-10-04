import 'package:equatable/equatable.dart';

class PspUser extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String organ;
  final String province;
  final String mobile;
  final String nationalCode;

  const PspUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.organ,
    required this.province,
    required this.mobile,
    required this.nationalCode,
  });

  PspUser copyWith({
    String? firstName,
    String? lastName,
    String? organ,
    String? province,
    String? mobile,
    String? nationalCode,
  }) {
    return PspUser(
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      organ: organ ?? this.organ,
      province: province ?? this.province,
      mobile: mobile ?? this.mobile,
      nationalCode: nationalCode ?? this.nationalCode,
    );
  }

  @override
  List<Object> get props => [nationalCode];
}
