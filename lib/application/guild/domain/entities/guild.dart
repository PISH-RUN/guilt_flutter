import 'package:equatable/equatable.dart';
import 'package:guilt_flutter/application/guild/domain/entities/isic.dart';
import 'package:guilt_flutter/application/guild/domain/entities/pos.dart';
import 'package:latlong2/latlong.dart' as lat_lng;

class Guild extends Equatable {
  final int id;
  final int userId;
  final String image;
  final String status;
  final String issueDate;
  final String licenseNumber;
  final String uuid;
  final String corporateId;
  final String boardTitle;
  final String zoneCode;
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
    required this.userId,
    required this.image,
    required this.status,
    required this.issueDate,
    required this.licenseNumber,
    required this.uuid,
    required this.corporateId,
    required this.boardTitle,
    required this.zoneCode,
    required this.poses,
    required this.organName,
    required this.isic,
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
    int? userId,
    String? image,
    String? status,
    String? issueDate,
    String? licenseNumber,
    String? uuid,
    String? corporateId,
    String? zoneCode,
    String? boardTitle,
    String? organName,
    Isic? isic,
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
      userId: userId ?? this.userId,
      image: image ?? this.image,
      status: status ?? this.status,
      issueDate: issueDate ?? this.issueDate,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      uuid: uuid ?? this.uuid,
      corporateId: corporateId ?? this.corporateId,
      boardTitle: boardTitle ?? this.boardTitle,
      zoneCode: zoneCode ?? this.zoneCode,
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
    return const Guild(
      city: '',
      boardTitle: '',
      corporateId: '',
      image: '',
      issueDate: '',
      licenseNumber: '',
      status: '',
      userId: 0,
      uuid: '',
      zoneCode: '',
      province: '',
      title: '',
      poses: [],
      isCouponRequested: false,
      address: '',
      homeTelephone: '',
      isic: Isic(code: "", name: ""),
      location: null,
      organName: '',
      postalCode: '',
      id: 0,
    );
  }

  @override
  String toString() {
    return '{organName: $organName}';
  }

  @override
  List<Object> get props => [id];
}
