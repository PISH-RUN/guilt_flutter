import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/application/guild/domain/entities/icis.dart';
import 'package:guilt_flutter/features/login/api/login_api.dart';
import 'package:latlong2/latlong.dart' as latLng;

class Guild extends Equatable {
  final int id;
  final String nationalCode;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String organName;
  final Isic isic;
  final String name;
  final String province;
  final String city;
  final String homeTelephone;
  final String address;
  final String postalCode;
  final latLng.LatLng? location;

  const Guild({
    required this.id,
    required this.nationalCode,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.organName,
    required this.isic,
    required this.name,
    required this.province,
    required this.city,
    required this.homeTelephone,
    required this.address,
    required this.postalCode,
    required this.location,
  });

  @override
  String toString() {
    return 'Guild{nationalCode: $nationalCode, phoneNumber: $phoneNumber, firstName: $firstName, isicCoding: ${isic.code}, province: $province, city: $city, address: $address, location: $location}';
  }

  Guild copyWith({
    int? id,
    String? nationalCode,
    String? phoneNumber,
    String? firstName,
    String? lastName,
    String? organName,
    Isic? isic,
    String? guildName,
    String? province,
    String? city,
    String? homeTelephone,
    String? address,
    String? postalCode,
    latLng.LatLng? location,
  }) {
    return Guild(
      id: id ?? this.id,
      nationalCode: nationalCode ?? this.nationalCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      organName: organName ?? this.organName,
      isic: isic ?? this.isic,
      name: guildName ?? this.name,
      province: province ?? this.province,
      city: city ?? this.city,
      homeTelephone: homeTelephone ?? this.homeTelephone,
      address: address ?? this.address,
      postalCode: postalCode ?? this.postalCode,
      location: location ?? this.location,
    );
  }

  factory Guild.fromEmpty() {
    return Guild(
      nationalCode: GetIt.instance<LoginApi>().getUserId(),
      phoneNumber: '',
      firstName: '',
      lastName: '',
      city: '',
      province: '',
      name: '',
      address: '',
      homeTelephone: '',
      isic: const Isic(code: "", name: ""),
      location: null,
      organName: '',
      postalCode: '',
      id: 0,
    );
  }

  @override
  List<Object> get props => [id];
}
