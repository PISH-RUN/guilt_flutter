import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/application/guild/domain/usecases/guild_main.dart';
import 'package:guilt_flutter/application/guild/presentation/manager/guild_list_state.dart';
import 'package:guilt_flutter/features/login/api/login_api.dart';
import 'package:logger/logger.dart';

class GuildListCubit extends Cubit<GuildListState> {
  final GuildMain main;

  GuildListCubit({
    required this.main,
  }) : super(const GuildListState.loading());

  Future<void> initialPage() async {
    emit(const GuildListState.loading());
    final response = await main.getListOfMyGuilds(nationalCode: GetIt.instance<LoginApi>().getUserId());
    response.fold(
      (failure) => emit(GuildListState.error(failure: failure)),
      (guildList) {
        Logger().i("info=> ${guildList} ");
        emit(GuildListState.loaded(guildList: guildList));
      },
    );
  }
}
