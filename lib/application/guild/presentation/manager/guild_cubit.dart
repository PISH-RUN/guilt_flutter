import 'package:bloc/bloc.dart';
import '../../domain/entities/guild.dart';
import '../../domain/usecases/guild_main.dart';
import 'guild_state.dart';

class GuildCubit extends Cubit<GuildState> {
  final GuildMain main;

  GuildCubit({
    required this.main,
  }) : super(const GuildState.loading());

  Future<void> initialPage(int userId, int guildId) async {
    emit(const GuildState.loading());
    final response = await main.getFullDetailOfOneGuild(userId: userId, guildId: guildId);
    response.fold(
      (failure) => emit(GuildState.error(failure: failure)),
      (guild) => emit(GuildState.loaded(guild: guild)),
    );
  }

  Future<void> saveGuild(int userId, Guild guild) async {
    final response = await main.updateGuild(userId: userId, guild: guild);
    response.fold(
      (failure) => emit(GuildState.error(failure: failure)),
      () => emit(GuildState.loaded(guild: guild)),
    );
  }
}
