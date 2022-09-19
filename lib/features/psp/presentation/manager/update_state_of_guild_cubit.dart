import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guilt_flutter/features/psp/domain/entities/guild_psp.dart';
import '../../domain/use_cases/psp_main.dart';
import 'update_state_of_guild_state.dart';

class UpdateStateOfGuildCubit extends Cubit<UpdateStateOfGuildState> {
  final PspMain _main;

  UpdateStateOfGuildCubit({
    required PspMain main,
  })  : _main = main,
        super(const UpdateStateOfGuildState.readyToInput());

  Future<void> updateStateOfSpecialGuild(GuildPsp guild) async {
    emit(const UpdateStateOfGuildState.loading());
    final response = await _main.updateStateOfSpecialGuild(guild);
    response.fold(
      (failure) => emit(UpdateStateOfGuildState.error(failure: failure)),
      () => emit(const UpdateStateOfGuildState.success()),
    );
  }
}
