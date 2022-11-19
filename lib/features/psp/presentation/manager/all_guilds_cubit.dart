import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guilt_flutter/features/psp/domain/entities/guild_psp.dart';
import 'package:logger/logger.dart';

import '../../domain/use_cases/psp_main.dart';
import 'all_guilds_state.dart';

class AllGuildsCubit extends Cubit<AllGuildsState> {
  final PspMain _main;

  AllGuildsCubit({
    required PspMain main,
  })  : _main = main,
        super(const AllGuildsState.loading());

  int currentPage = 1;
  int totalPage = 100;
  List<String> currentCities = [];
  static List<GuildPsp> guildPspList = [];
  String currentSearchText = "";
  bool isJustMine = false;

  Future<void> initialPage(List<String> cities, {String? searchText}) async {
    if (searchText != null) {
      currentPage = 1;
      guildPspList = [];
      currentSearchText = searchText;
    }
    if (currentCities != cities) {
      emit(const AllGuildsState.loading());
      currentPage = 1;
      guildPspList = [];
      currentCities = cities;
    }
    final response = await _main.getAllGuildsByCities(cities: cities, page: currentPage, searchText: currentSearchText);
    response.fold((failure) => emit(AllGuildsState.error(failure: failure)), (guildList) {
      totalPage = guildList.totalPage;
      currentPage = guildList.currentPage;
      guildPspList = [...guildPspList, ...guildList.list];
      if (guildList.list.isEmpty) {
        emit(const AllGuildsState.empty());
      } else {
        emit(AllGuildsState.loaded(guildList: guildList.copyWith(list: guildList.list)));
      }
    });
  }

  Future<void> getMoreItem() async {
    if (currentPage >= totalPage) {
      return;
    }
    await Future.delayed(const Duration(milliseconds: 200));
    currentPage++;
    initialPage(currentCities);
  }
}
