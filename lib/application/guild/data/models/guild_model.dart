import 'dart:convert';

import 'package:guilt_flutter/application/guild/data/models/pos_model.dart';
import 'package:guilt_flutter/application/guild/domain/entities/icis.dart';
import 'package:guilt_flutter/application/guild/domain/entities/pos.dart';
import 'package:guilt_flutter/commons/data/model/json_parser.dart';
import 'package:guilt_flutter/commons/utils.dart';
import 'package:latlong2/latlong.dart' as lat_lng;
import 'package:logger/logger.dart';

import '../../domain/entities/guild.dart';

class GuildModel extends Guild {
  const GuildModel({
    required int id,
    required int userId,
    required String image,
    required String status,
    required String issueDate,
    required String licenseNumber,
    required String uuid,
    required String corporateId,
    required String boardTitle,
    required String zoneCode,
    required Isic isic,
    required String organName,
    required String guildName,
    required String province,
    required String city,
    required bool isCouponRequested,
    required String homeTelephone,
    required String address,
    required String postalCode,
    required List<Pos> poses,
    required lat_lng.LatLng? location,
  }) : super(
          id: id,
          userId: userId,
          image: image,
          status: status,
          issueDate: issueDate,
          licenseNumber: licenseNumber,
          uuid: uuid,
          corporateId: corporateId,
          boardTitle: boardTitle,
          zoneCode: zoneCode,
          isCouponRequested: isCouponRequested,
          poses: poses,
          isic: isic,
          organName: organName,
          title: guildName,
          province: province,
          city: city,
          homeTelephone: homeTelephone,
          address: address,
          postalCode: postalCode,
          location: location,
        );

  factory GuildModel.fromJson(Map<String, dynamic> json) {
    Logger().i("info=> ${json} ");
    return GuildModel(
      id: JsonParser.intParser(json, ['id']),
      userId: JsonParser.intParser(json, ['user_id']),
      image: JsonParser.stringParser(json, ['image']),
      status: JsonParser.stringParser(json, ['status']),
      issueDate: JsonParser.stringParser(json, ['issue_date']),
      licenseNumber: JsonParser.stringParser(json, ['license_number']),
      uuid: JsonParser.stringParser(json, ['uuid']),
      corporateId: JsonParser.stringParser(json, ['corporate_id']),
      boardTitle: JsonParser.stringParser(json, ['board_title']),
      zoneCode: JsonParser.stringParser(json, ['zone_code']),
      isic: getIsicWithCode(JsonParser.stringParser(json, ['isic_code'])),
      organName: JsonParser.stringParser(json, ['organ']),
      guildName: JsonParser.stringParser(json, ['guild_name']),
      poses: JsonParser.listParser(json, ['poses']).map((pos) => PosModel.fromJson(pos)).toList(),
      province: JsonParser.stringParser(json, ['province']),
      city: JsonParser.stringParser(json, ['city']),
      isCouponRequested: JsonParser.boolParser(json, ['coupon_req']),
      homeTelephone: JsonParser.stringParser(json, ['phone']),
      address: JsonParser.stringParser(json, ['address']),
      postalCode: JsonParser.stringParser(json, ['postal_code']),
      location: JsonParser.stringParser(json, ['location']).isEmpty
          ? null
          : lat_lng.LatLng(
              double.parse(JsonParser.listParser(json, ['location'])[0].toString()),
              double.parse(JsonParser.listParser(json, ['location'])[1].toString()),
            ),
    );
  }

  factory GuildModel.fromSuper(Guild guild) {
    return GuildModel(
      id: guild.id,
      userId: guild.userId,
      image: guild.image,
      status: guild.status,
      issueDate: guild.issueDate,
      licenseNumber: guild.licenseNumber,
      uuid: guild.uuid,
      corporateId: guild.corporateId,
      boardTitle: guild.boardTitle,
      zoneCode: guild.zoneCode,
      isic: guild.isic,
      poses: guild.poses,
      isCouponRequested: guild.isCouponRequested,
      organName: guild.organName,
      guildName: guild.title,
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
      'id': id,
      "user_id": userId,
      "image": image,
      'status': status.isEmpty ? 'waiting_confirmation' : status,
      'license_number': licenseNumber,
      'uuid': uuid,
      'corporate_id': corporateId,
      'board_title': boardTitle,
      'zone_code': zoneCode,
      'isic_code': isic.code,
      'organ': organName,
      'guild_name': title,
      'province': province,
      'coupon_req': isCouponRequested,
      'city': city,
      'poses': poses.map((e) => PosModel.fromSuper(e).toJson()).toList(),
      'phone': homeTelephone,
      'address': address,
      'postal_code': postalCode,
      'location': location == null ? null : [location!.latitude, location!.longitude],
    };
  }

  static List<Guild> convertStringToGuildList(String jsonString) => convertMapToGuildList(jsonDecode(jsonString) as List);

  static List<Guild> convertMapToGuildList(List<dynamic> json) => json.map((e) => GuildModel.fromJson(e)).toList();

  static String convertGuildListToString(List<Guild> guildList) {
    return guildList.map((e) => jsonEncode(GuildModel.fromSuper(e).toJson())).toList().toString();
  }
}
