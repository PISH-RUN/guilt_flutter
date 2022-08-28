import 'package:guilt_flutter/application/guild/domain/entities/icis.dart';
import 'package:guilt_flutter/commons/data/model/json_parser.dart';
import 'package:guilt_flutter/commons/utils.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:logger/logger.dart';

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
    required bool isCouponRequested,
    required String homeTelephone,
    required String address,
    required String postalCode,
    required latLng.LatLng? location,
  }) : super(
          id: id,
          nationalCode: nationalCode,
          phoneNumber: phoneNumber,
          isCouponRequested: isCouponRequested,
          firstName: firstName,
          lastName: lastName,
          isic: isic,
          organName: organName,
          name: guildName,
          province: province,
          city: city,
          homeTelephone: homeTelephone,
          address: address,
          postalCode: postalCode,
          location: location,
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
      province: JsonParser.stringParser(json, ['OstanName']),
      city: JsonParser.stringParser(json, ['ShahrestanName']),
      isCouponRequested: JsonParser.boolParser(json, ['isCouponRequested']),
      homeTelephone: JsonParser.stringParser(json, ['PhoneNo']),
      address: JsonParser.stringParser(json, ['Address']),
      postalCode: JsonParser.stringParser(json, ['PostalCode']),
      nationalCode: JsonParser.stringParser(json, ['NationalCode']),
      location: JsonParser.stringParser(json, ['location']).isEmpty
          ? null
          : latLng.LatLng(JsonParser.doubleParser(json, ['location', 'lat']), JsonParser.doubleParser(json, ['location', 'lon'])),
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
      isCouponRequested: guild.isCouponRequested,
      organName: guild.organName,
      guildName: guild.name,
      province: guild.province,
      city: guild.city,
      homeTelephone: guild.homeTelephone,
      address: guild.address,
      postalCode: guild.postalCode,
      location: guild.location,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "MobileNo": phoneNumber,
      "FirstName": firstName,
      "LastName": lastName,
      "IsicCoding": isic.code,
      "OrganName": organName,
      "GuildName": name,
      "OstanName": province,
      "isCouponRequested": isCouponRequested,
      "ShahrestanName": city,
      "PhoneNo": homeTelephone,
      "Address": address,
      "PostalCode": postalCode,
      "NationalCode": nationalCode,
      "location": location == null
          ? null
          : {
              'lat': location!.latitude,
              'lon': location!.longitude,
            },
    };
  }
}
