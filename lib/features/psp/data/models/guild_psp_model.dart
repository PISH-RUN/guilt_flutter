import 'package:guilt_flutter/application/guild/data/models/guild_model.dart';
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

  factory GuildPspModel.fromJson(Map<String, dynamic> json, {GuildPspStep guildPspStep = GuildPspStep.normal}) {
    return GuildPspModel(
      guild: GuildModel.fromJson(json),
      guildPspStep: JsonParser.stringParser(json, ['psp_guild_status']).isNotEmpty
          ? GuildPspStep.values.firstWhere((element) => element.name == JsonParser.stringParser(json, ['psp_guild_status']))
          : guildPspStep,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "guild": guild,
      "guildState": guildPspStep,
    };
  }
}
