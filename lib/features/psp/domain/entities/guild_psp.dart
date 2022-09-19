import 'package:equatable/equatable.dart';

import '../../../../application/guild/domain/entities/guild.dart';
import 'guild_psp_step.dart';

class GuildPsp extends Equatable {
  final Guild guild;
  final GuildPspStep guildPspStep;

  const GuildPsp({
    required this.guild,
    required this.guildPspStep,
  });

  GuildPsp copyWith({
    Guild? guild,
    GuildPspStep? guildPspStep,
  }) {
    return GuildPsp(
      guild: guild ?? this.guild,
      guildPspStep: guildPspStep ?? this.guildPspStep,
    );
  }

  @override
  List<Object> get props => [guild];
}
