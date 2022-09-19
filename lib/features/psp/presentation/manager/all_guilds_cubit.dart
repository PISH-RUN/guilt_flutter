import 'package:flutter_bloc/flutter_bloc.dart';
import 'all_guilds_state.dart';
import '../../domain/use_cases/psp_main.dart';

class AllGuildsCubit extends Cubit<AllGuildsState> {
  final PspMain _main;

  AllGuildsCubit({
    required PspMain main,
  })  : _main = main,
        super(const AllGuildsState.loading());

  Future<void> initialPage(List<String> cities, int page) async {
    emit(const AllGuildsState.loading());
    final response = await _main.getAllGuildsByCities(cities, page);
    response.fold((failure) => emit(AllGuildsState.error(failure: failure)), (guildList) {
      emit(AllGuildsState.loaded(guildList: guildList));
    });
  }


}
