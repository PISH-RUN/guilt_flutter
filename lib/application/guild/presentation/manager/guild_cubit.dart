import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/features/login/api/login_api.dart';
import '../../domain/entities/guild.dart';
import '../../domain/usecases/guild_main.dart';
import 'guild_state.dart';

class GuildCubit extends Cubit<GuildState> {
  final GuildMain main;

  GuildCubit({
    required this.main,
  }) : super(const GuildState.loading());

  Future<void> initialPage(String nationalCode, int guildId) async {
    emit(const GuildState.loading());
    final response = await main.getFullDetailOfOneGuild(nationalCode: nationalCode, guildId: guildId);
    response.fold(
      (failure) => emit(GuildState.error(failure: failure)),
      (guild) => emit(GuildState.loaded(guild: guild)),
    );
  }

  Future<void> saveGuild(Guild guild) async {
    final response = await main.updateGuild(nationalCode: GetIt.instance<LoginApi>().getUserId(), guild: guild);
    response.fold(
      (failure) => emit(GuildState.error(failure: failure)),
      () => emit(GuildState.loaded(guild: guild)),
    );
  }

  Future<void> addGuild(Guild guild) async {
    final response = await main.addGuild(nationalCode: GetIt.instance<LoginApi>().getUserId(), guild: guild);
    response.fold(
      (failure) => emit(GuildState.error(failure: failure)),
      () => emit(GuildState.loaded(guild: guild)),
    );
  }
}
