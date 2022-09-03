import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/application/guild/domain/entities/guild.dart';
import 'package:guilt_flutter/application/guild/domain/usecases/guild_main.dart';
import 'package:guilt_flutter/application/guild/presentation/manager/guild_list_state.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/commons/request_result.dart';
import 'package:guilt_flutter/commons/utils.dart';
import 'package:guilt_flutter/features/login/api/login_api.dart';
import 'package:logger/logger.dart';

class GuildListCubit extends Cubit<GuildListState> {
  final GuildMain main;

  GuildListCubit({
    required this.main,
  }) : super(const GuildListState.loading());

  Future<void> initialPage(BuildContext context) async {
    emit(const GuildListState.loading());
    await Future.delayed(const Duration(milliseconds:300), () => "1");
    final response = await main.getListOfMyGuilds(nationalCode: GetIt.instance<LoginApi>().getUserId());
    response.fold(
      (failure) => emit(GuildListState.error(failure: failure)),
      (guildList) {
        if (guildList.isEmpty) {
          emit(GuildListState.empty());
        } else {
          emit(GuildListState.loaded(guildList: guildList));
        }
      },
    );
  }

  Future<RequestResult> saveGuild(Guild guild) {
    return main.updateGuild(nationalCode: GetIt.instance<LoginApi>().getUserId(), guild: guild);
  }
}
