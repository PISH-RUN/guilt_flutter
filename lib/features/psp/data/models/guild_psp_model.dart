import 'package:guilt_flutter/application/guild/domain/entities/guild.dart';
import 'package:guilt_flutter/commons/data/model/json_parser.dart';
import 'package:guilt_flutter/features/psp/domain/entities/guild_psp_step.dart';

import '../../domain/entities/guild_psp.dart';

class GuildPspModel extends GuildPsp {
  const GuildPspModel({
    required Guild guild,
    required GuildPspStep guildPspStep,
  }) : super(
          guild: guild,
          guildPspStep: guildPspStep,
        );

  factory GuildPspModel.fromJson(Map<String, dynamic> json) {
    //todo replace this field
    return GuildPspModel(
      guild: JsonParser.parser(json, ['id']),
      guildPspStep: JsonParser.parser(json, ['id']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "guild": guild,
      "guildState": guildPspStep,
    };
  }
}
