import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/commons/failures.dart';
import 'package:guilt_flutter/features/login/api/login_api.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/guild.dart';
import '../../domain/usecases/guild_main.dart';
import 'guild_state.dart';

class GuildCubit extends Cubit<GuildState> {
  final GuildMain main;

  GuildCubit({
    required this.main,
  }) : super(const GuildState.loading());

  Future<void> initialPage(String guildUuid) async {
    emit(const GuildState.loading());
    final response =
        await main.getFullDetailOfOneGuild(nationalCode: GetIt.instance<LoginApi>().getUserData().nationalCode, guildUuid: guildUuid);
    response.fold(
      (failure) => emit(GuildState.error(failure: failure)),
      (guild) => emit(GuildState.loaded(guild: guild)),
    );
  }

  Future<void> initialPageForNewGuild() async {
    emit(GuildState.loaded(guild: Guild.fromEmpty()));
  }

  Future<void> saveGuild(Guild guild) async {
    final response = await main.updateGuild(guild: guild);
    response.fold(
      (failure) => emit(GuildState.errorSave(failure: failure)),
      () => emit(GuildState.loaded(guild: guild)),
    );
  }

  Future<void> addGuild(Guild guild) async {
    final response = await main.addGuild(nationalCode: GetIt.instance<LoginApi>().getUserData().nationalCode, guild: guild);
    response.fold(
      (failure) => emit(GuildState.errorSave(failure: failure)),
      () => emit(GuildState.loaded(guild: guild)),
    );
  }

  Future<Either<Failure, String>> updateAvatar(Guild guild, XFile avatar) => main.updateAvatar(guild: guild, avatar: avatar);
}
