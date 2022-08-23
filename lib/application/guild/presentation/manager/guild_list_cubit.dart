import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guilt_flutter/application/guild/domain/usecases/guild_main.dart';
import 'package:guilt_flutter/application/guild/presentation/manager/guild_list_state.dart';

class GuildListCubit extends Cubit<GuildListState> {
  final GuildMain main;

  GuildListCubit({
    required this.main,
  }) : super(const GuildListState.loading());

  Future<void> initialPage(int userId) async {
    emit(const GuildListState.loading());
    final response = await main.getListOfMyGuilds(userId: userId);
    response.fold(
      (failure) => emit(GuildListState.error(failure: failure)),
      (guildList) => emit(GuildListState.loaded(guildList: guildList)),
    );
  }
}
