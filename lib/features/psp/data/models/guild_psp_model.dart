import 'package:guilt_flutter/application/guild/data/models/guild_model.dart';
import 'package:guilt_flutter/application/guild/domain/entities/guild.dart';
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
      guildPspStep: guildPspStep,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "guild": guild,
      "guildState": guildPspStep,
    };
  }
}
