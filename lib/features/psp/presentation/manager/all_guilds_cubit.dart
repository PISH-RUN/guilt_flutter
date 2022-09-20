import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guilt_flutter/features/psp/domain/entities/guild_psp.dart';
import 'all_guilds_state.dart';
import '../../domain/use_cases/psp_main.dart';

class AllGuildsCubit extends Cubit<AllGuildsState> {
  final PspMain _main;

  AllGuildsCubit({
    required PspMain main,
  })  : _main = main,
        super(const AllGuildsState.loading());

  int currentPage = 1;
  int totalPage = 100;
  List<String> currentCities = [];
  List<GuildPsp> guildPspList = [];
  String currentSearchText = "";

  Future<void> initialPage(List<String> cities, {String? searchText}) async {
    if (searchText != null) {
      currentPage = 1;
      guildPspList = [];
      currentSearchText = searchText;
    }
    currentCities = cities;
    emit(const AllGuildsState.loading());
    final response = await _main.getAllGuildsByCities(cities, currentPage,  currentSearchText);
    response.fold((failure) => emit(AllGuildsState.error(failure: failure)), (guildList) {
      totalPage = guildList.totalPage;
      currentPage = guildList.currentPage;
      guildPspList = [...guildPspList, ...guildList.list];
      emit(AllGuildsState.loaded(guildList: guildList.copyWith(list: guildList.list)));
    });
  }

  Future<void> getMoreItem() async {
    if (currentPage >= totalPage) {
      return;
    }
    await Future.delayed(const Duration(seconds: 5));
    currentPage++;
    initialPage(currentCities);
  }
}
