import 'package:guilt_flutter/commons/data/model/json_parser.dart';
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
      nationalCode: JsonParser.stringParser(json, ['nationalCode']),
      phoneNumber: JsonParser.stringParser(json, ['phoneNumber']),
      firstName: JsonParser.stringParser(json, ['firstName']),
      lastName: JsonParser.stringParser(json, ['lastName']),
      isicCoding: JsonParser.stringParser(json, ['isicCoding']),
      organName: JsonParser.stringParser(json, ['organName']),
      isicName: JsonParser.stringParser(json, ['isicName']),
      guildName: JsonParser.stringParser(json, ['guildName']),
      province: JsonParser.stringParser(json, ['province']),
      city: JsonParser.stringParser(json, ['city']),
      homeTelephone: JsonParser.stringParser(json, ['homeTelephone']),
      address: JsonParser.stringParser(json, ['address']),
      postalCode: JsonParser.stringParser(json, ['postalCode']),
      location: latLng.LatLng(324.0, 324.0), //todo fix this
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
