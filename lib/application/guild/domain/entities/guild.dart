import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/application/guild/domain/entities/icis.dart';
import 'package:guilt_flutter/application/guild/domain/entities/pos.dart';
import 'package:guilt_flutter/features/login/api/login_api.dart';
import 'package:guilt_flutter/features/profile/domain/entities/gender_type.dart';
import 'package:latlong2/latlong.dart' as lat_lng;

class Guild extends Equatable {
  final int id;
  final Gender gender;
  final String nationalCode;
  final String? avatar;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String organName;
  final Isic isic;
  final bool isCouponRequested;
  final String title;
  final String province;
  final String city;
  final String homeTelephone;
  final String address;
  final String postalCode;
  final List<Pos> poses;
  final lat_lng.LatLng? location;

  const Guild({
    required this.id,
    required this.nationalCode,
    required this.phoneNumber,
    required this.poses,
    required this.firstName,
    required this.gender,
    required this.lastName,
    required this.organName,
    required this.isic,
    required this.avatar,
    required this.isCouponRequested,
    required this.title,
    required this.province,
    required this.city,
    required this.homeTelephone,
    required this.address,
    required this.postalCode,
    required this.location,
  });

  Guild copyWith({
    int? id,
    String? phoneNumber,
    String? firstName,
    String? lastName,
    String? organName,
    String? avatar,
    Isic? isic,
    Gender? gender,
    String? title,
    String? province,
    String? city,
    List<Pos>? poses,
    String? homeTelephone,
    bool? isCouponRequested,
    String? address,
    String? postalCode,
    lat_lng.LatLng? location,
  }) {
    return Guild(
      id: id ?? this.id,
      nationalCode: nationalCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatar: avatar ?? this.avatar,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      isCouponRequested: isCouponRequested ?? this.isCouponRequested,
      organName: organName ?? this.organName,
      isic: isic ?? this.isic,
      poses: poses ?? this.poses,
      title: title ?? this.title,
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
      title: '',
      avatar: null,
      poses: const [],
      gender: Gender.girl,
      isCouponRequested: false,
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
