import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/commons/data/model/json_parser.dart';
import 'package:guilt_flutter/features/login/api/login_api.dart';
import '../../domain/entities/guild.dart';
import 'package:latlong2/latlong.dart' as latLng;

class GuildModel extends Guild {
  const GuildModel({
    required int id,
    required String nationalCode,
    required String phoneNumber,
    required String firstName,
    required String lastName,
    required String isicCoding,
    required String organName,
    required String isicName,
    required String guildName,
    required String province,
    required String city,
    required String homeTelephone,
    required String address,
    required String postalCode,
    required latLng.LatLng? location,
  }) : super(
          id: id,
          nationalCode: nationalCode,
          phoneNumber: phoneNumber,
          firstName: firstName,
          lastName: lastName,
          isicCoding: isicCoding,
          organName: organName,
          isicName: isicName,
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
      nationalCode: JsonParser.stringParser(json, ['NationalCode']),
      phoneNumber: JsonParser.stringParser(json, ['MobileNo']),
      firstName: JsonParser.stringParser(json, ['FirstName']),
      lastName: JsonParser.stringParser(json, ['LastName']),
      isicCoding: JsonParser.stringParser(json, ['IsicCoding']),
      organName: JsonParser.stringParser(json, ['OrganName']),
      isicName: JsonParser.stringParser(json, ['isicName']),
      guildName: JsonParser.stringParser(json, ['GuildName']),
      province: JsonParser.stringParser(json, ['OstanName']),
      city: JsonParser.stringParser(json, ['ShahrestanName']),
      homeTelephone: JsonParser.stringParser(json, ['PhoneNo']),
      address: JsonParser.stringParser(json, ['Address']),
      postalCode: JsonParser.stringParser(json, ['PostalCode']),
      location: null,
    );
  }

  factory GuildModel.fromSuper(Guild guild) {
    return GuildModel(
      id: guild.id,
      nationalCode: guild.nationalCode,
      phoneNumber: guild.phoneNumber,
      firstName: guild.firstName,
      lastName: guild.lastName,
      isicCoding: guild.isicCoding,
      organName: guild.organName,
      isicName: guild.isicName,
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
      "IsicCoding": isicCoding,
      "OrganName": organName,
      "GuildName": name,
      "OstanName": province,
      "ShahrestanName": city,
      "PhoneNo": homeTelephone,
      "Address": address,
      "PostalCode": postalCode,
      "location": {"lat": location!.latitude, "lan": location!.longitude},
    };
  }
}
