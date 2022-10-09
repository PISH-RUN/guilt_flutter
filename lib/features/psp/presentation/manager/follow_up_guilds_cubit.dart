import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guilt_flutter/features/psp/domain/entities/guild_psp.dart';
import 'package:guilt_flutter/features/psp/presentation/manager/follow_up_guilds_state.dart';
import '../../domain/use_cases/psp_main.dart';

class FollowUpGuildsCubit extends Cubit<FollowUpGuildsState> {
  final PspMain _main;

  FollowUpGuildsCubit({
    required PspMain main,
  })  : _main = main,
        super(const FollowUpGuildsState.loading());

  int currentPage = 1;
  int totalPage = 100;
  List<String> currentCities = [];
  static List<GuildPsp> guildPspList = [];
  String currentSearchText = "";
  bool isJustMine = false;

  Future<void> initialPage(List<String> cities, {String? searchText}) async {
    this.isJustMine = isJustMine;
    if (searchText != null) {
      currentPage = 1;
      guildPspList = [];
      currentSearchText = searchText;
    }
    currentCities = cities;
    emit(const FollowUpGuildsState.loading());
    final response = await _main.getFollowUpGuildList(cities: cities, page: currentPage, searchText: currentSearchText);
    response.fold((failure) => emit(FollowUpGuildsState.error(failure: failure)), (guildList) {
      totalPage = guildList.totalPage;
      currentPage = guildList.currentPage;
      guildPspList = [...guildPspList, ...guildList.list];
      emit(FollowUpGuildsState.loaded(guildList: guildList.copyWith(list: guildList.list)));
    });
  }

  GuildPsp getGuildBuId(int guildId) {
    return guildPspList.firstWhere((element) => element.guild.id == guildId);
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
