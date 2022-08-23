import 'package:guilt_flutter/commons/data/model/json_parser.dart';
import '../../domain/entities/guild.dart';

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
  }) : super(
          id: id,
          nationalCode: nationalCode,
          phoneNumber: phoneNumber,
          firstName: firstName,
          lastName: lastName,
          isicCoding: isicCoding,
          organName: organName,
          isicName: isicName,
          guildName: guildName,
          province: province,
          city: city,
          homeTelephone: homeTelephone,
          address: address,
          postalCode: postalCode,
        );

  factory GuildModel.fromJson(Map<String, dynamic> json) {
    return GuildModel(
      id: JsonParser.intParser(json, ['id']),
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
      guildName: guild.guildName,
      province: guild.province,
      city: guild.city,
      homeTelephone: guild.homeTelephone,
      address: guild.address,
      postalCode: guild.postalCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "nationalCode": nationalCode,
      "phoneNumber": phoneNumber,
      "firstName": firstName,
      "lastName": lastName,
      "isicCoding": isicCoding,
      "organName": organName,
      "isicName": isicName,
      "guildName": guildName,
      "province": province,
      "city": city,
      "homeTelephone": homeTelephone,
      "address": address,
      "postalCode": postalCode,
    };
  }
}
