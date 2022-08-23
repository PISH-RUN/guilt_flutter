import 'package:equatable/equatable.dart';

class Guild extends Equatable {
  final int id;
  final String nationalCode;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String isicCoding;
  final String organName;
  final String isicName;
  final String guildName;
  final String province;
  final String city;
  final String homeTelephone;
  final String address;
  final String postalCode;

  const Guild({
    required this.id,
    required this.nationalCode,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.isicCoding,
    required this.organName,
    required this.isicName,
    required this.guildName,
    required this.province,
    required this.city,
    required this.homeTelephone,
    required this.address,
    required this.postalCode,
  });

  Guild copyWith({
    String? nationalCode,
    String? phoneNumber,
    String? firstName,
    String? lastName,
    String? isicCoding,
    String? organName,
    String? isicName,
    String? guildName,
    String? province,
    String? city,
    String? homeTelephone,
    String? address,
    String? postalCode,
  }) {
    return Guild(
      id: id,
      nationalCode: nationalCode ?? this.nationalCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      isicCoding: isicCoding ?? this.isicCoding,
      organName: organName ?? this.organName,
      isicName: isicName ?? this.isicName,
      guildName: guildName ?? this.guildName,
      province: province ?? this.province,
      city: city ?? this.city,
      homeTelephone: homeTelephone ?? this.homeTelephone,
      address: address ?? this.address,
      postalCode: postalCode ?? this.postalCode,
    );
  }

  @override
  List<Object> get props => [id];
}
