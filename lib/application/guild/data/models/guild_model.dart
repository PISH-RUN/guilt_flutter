import 'package:guilt_flutter/application/guild/data/models/pos_model.dart';
import 'package:guilt_flutter/application/guild/domain/entities/icis.dart';
import 'package:guilt_flutter/application/guild/domain/entities/pos.dart';
import 'package:guilt_flutter/commons/data/model/json_parser.dart';
import 'package:guilt_flutter/commons/utils.dart';
import 'package:guilt_flutter/features/profile/domain/entities/gender_type.dart';
import 'package:latlong2/latlong.dart' as lat_lng;
import '../../domain/entities/guild.dart';

class GuildModel extends Guild {
  const GuildModel({
    required int id,
    required String nationalCode,
    required String phoneNumber,
    required String firstName,
    required String lastName,
    required Isic isic,
    required String organName,
    required String guildName,
    required String province,
    required String city,
    required String? avatar,
    required bool isCouponRequested,
    required String homeTelephone,
    required String address,
    required String postalCode,
    required List<Pos> poses,
    required Gender gender,
    required lat_lng.LatLng? location,
  }) : super(
          id: id,
          nationalCode: nationalCode,
          phoneNumber: phoneNumber,
          isCouponRequested: isCouponRequested,
          firstName: firstName,
          poses: poses,
          avatar: avatar,
          lastName: lastName,
          isic: isic,
          organName: organName,
          title: guildName,
          province: province,
          city: city,
          homeTelephone: homeTelephone,
          address: address,
          postalCode: postalCode,
          location: location,
          gender: gender,
        );

  factory GuildModel.fromJson(Map<String, dynamic> json, int index) {
    return GuildModel(
      id: index,
      phoneNumber: JsonParser.stringParser(json, ['MobileNo']),
      firstName: JsonParser.stringParser(json, ['FirstName']),
      lastName: JsonParser.stringParser(json, ['LastName']),
      isic: getIsicWithCode(JsonParser.stringParser(json, ['IsicCoding'])),
      organName: JsonParser.stringParser(json, ['OrganName']),
      guildName: JsonParser.stringParser(json, ['GuildName']),
      avatar: JsonParser.stringTryParser(json, ['Image']),
      poses: JsonParser.listParser(json, ['Poses']).map((pos) => PosModel.fromJson(pos)).toList(),
      province: JsonParser.stringParser(json, ['OstanName']),
      city: JsonParser.stringParser(json, ['ShahrestanName']),
      isCouponRequested: JsonParser.boolParser(json, ['isCouponRequested']),
      homeTelephone: JsonParser.stringParser(json, ['PhoneNo']),
      gender: JsonParser.boolParser(json, ['Gender']) ? Gender.boy : Gender.girl,
      address: JsonParser.stringParser(json, ['Address']),
      postalCode: JsonParser.stringParser(json, ['PostalCode']),
      nationalCode: JsonParser.stringParser(json, ['NationalCode']),
      location: JsonParser.stringParser(json, ['Location']).isEmpty
          ? null
          : lat_lng.LatLng(
              double.parse(JsonParser.listParser(json, ['Location'])[0].toString()),
              double.parse(JsonParser.listParser(json, ['Location'])[1].toString()),
            ),
    );
  }

  factory GuildModel.fromSuper(Guild guild) {
    return GuildModel(
      id: guild.id,
      nationalCode: guild.nationalCode,
      phoneNumber: guild.phoneNumber,
      firstName: guild.firstName,
      lastName: guild.lastName,
      isic: guild.isic,
      poses: guild.poses,
      avatar: guild.avatar,
      isCouponRequested: guild.isCouponRequested,
      organName: guild.organName,
      guildName: guild.title,
      province: guild.province,
      city: guild.city,
      gender: guild.gender,
      homeTelephone: guild.homeTelephone,
      address: guild.address,
      postalCode: guild.postalCode,
      location: guild.location,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MobileNo': phoneNumber,
      'FirstName': firstName,
      'LastName': lastName,
      'IsicCoding': isic.code,
      'OrganName': organName,
      'GuildName': title,
      'Image': avatar,
      'OstanName': province,
      'isCouponRequested': isCouponRequested,
      'ShahrestanName': city,
      'Poses': poses.map((e) => PosModel.fromSuper(e).toJson()).toList(),
      'PhoneNo': homeTelephone,
      'Address': address,
      'PostalCode': postalCode,
      'NationalCode': nationalCode,
      'Gender': gender == Gender.boy,
      'Location': location == null ? null : [location!.latitude, location!.longitude],
    };
  }
}
