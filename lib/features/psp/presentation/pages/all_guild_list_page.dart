import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/application/colors.dart';
import 'package:guilt_flutter/application/error_page.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/utils.dart';
import 'package:guilt_flutter/commons/widgets/loading_widget.dart';
import 'package:guilt_flutter/features/psp/presentation/manager/all_guilds_state.dart';
import 'package:guilt_flutter/features/psp/presentation/manager/update_state_of_guild_cubit.dart';
import 'package:guilt_flutter/features/psp/presentation/widgets/all_guilds_widget.dart';
import 'package:guilt_flutter/main.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../manager/all_guilds_cubit.dart';

class AllGuildsListPage extends StatefulWidget {
  final bool isJustMine;

  const AllGuildsListPage({required this.isJustMine, Key? key}) : super(key: key);

  @override
  State<AllGuildsListPage> createState() => _AllGuildsListPageState();

  static Widget wrappedRoute(bool isJustMine) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (ctx) => GetIt.instance<AllGuildsCubit>()),
        BlocProvider(create: (ctx) => GetIt.instance<UpdateStateOfGuildCubit>()),
      ],
      child: AllGuildsListPage(isJustMine: isJustMine),
    );
  }
}

class _AllGuildsListPageState extends State<AllGuildsListPage> {
  TextEditingController controller = TextEditingController(text: '');

  List<String> selectedCity = [];

  @override
  void initState() {
    BlocProvider.of<AllGuildsCubit>(context).initialPage([], searchText: "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: BlocBuilder<AllGuildsCubit, AllGuildsState>(
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => _basePage(LoadingWidget()),
            error: (failure) => ErrorPage(failure: failure, tryAgain: () => BlocProvider.of<AllGuildsCubit>(context).initialPage(selectedCity, searchText: "")),
            orElse: () => _basePage(AllGuildsListWidget(cities: selectedCity.isNotEmpty ? selectedCity : [], searchText: controller.text)),
          );
        },
      )),
    );
  }

  Future<void> _showMultiSelect(BuildContext context) async {
    final cities = await getCitiesOfOneProvince(context, province);
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: MultiSelectBottomSheet(
            initialValue: selectedCity,
            searchable: true,
            itemsTextStyle: defaultTextStyle(context),
            selectedItemsTextStyle: defaultTextStyle(context),
            cancelText: Text("لغو", style: defaultTextStyle(context, headline: 4).c(AppColor.blue)),
            searchHint: "جستجو",
            confirmText: Text("تایید", style: defaultTextStyle(context, headline: 4).c(AppColor.blue)),
            title: Text("انتخاب شهر", style: defaultTextStyle(context, headline: 4)),
            items: cities.map((e) => MultiSelectItem(e, e)).toList(),
            onConfirm: (values) {
              if (selectedCity == values) return;
              selectedCity = values.map((e) => e.toString()).toList();
              setState(() {});
            },
            maxChildSize: 0.7,
            minChildSize: 0.4,
            initialChildSize: 0.4,
          ),
        );
      },
    );
  }

  Widget _basePage(Widget child) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(Radius.circular(9)),
            boxShadow: simpleShadow(),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
          child: GestureDetector(
            onTap: () async => await showDialogOfCitySelected(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async => await showDialogOfCitySelected(),
                      child: AbsorbPointer(
                        child: Row(
                          children: <Widget>[
                            const Icon(Icons.location_city, size: 25.0),
                            const SizedBox(width: 10.0),
                            Text(selectedCity.isEmpty ? "شهری انتخاب نشده است" : "${selectedCity.length} شهر انتخاب شده"),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() => selectedCity.clear());
                      BlocProvider.of<AllGuildsCubit>(context).initialPage(selectedCity, searchText: controller.text);
                    },
                    child: const Padding(padding: EdgeInsets.symmetric(horizontal: 8.0), child: Icon(Icons.close, size: 20.0)),
                  ),
                  GestureDetector(
                    onTap: () async => await showDialogOfCitySelected(),
                    child: AbsorbPointer(
                      child: Row(
                        children: const <Widget>[
                          SizedBox(width: 2.0),
                          RotatedBox(quarterTurns: 1, child: Icon(Icons.arrow_back_ios_rounded, size: 20.0)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }

  Future<void> showDialogOfCitySelected() async {
    await _showMultiSelect(context);
    if (BlocProvider.of<AllGuildsCubit>(context).currentCities == selectedCity) return;
    if ((BlocProvider.of<AllGuildsCubit>(context).currentCities.isEmpty) && (selectedCity.isEmpty)) return;
    BlocProvider.of<AllGuildsCubit>(context).initialPage(selectedCity, searchText: controller.text);
  }

  void search(String value) {
    //todo fix search
    if (value == BlocProvider.of<AllGuildsCubit>(context).currentSearchText) return;
    BlocProvider.of<AllGuildsCubit>(context).initialPage(selectedCity, searchText: value);
  }
}
