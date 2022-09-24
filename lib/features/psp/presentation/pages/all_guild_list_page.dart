import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/application/colors.dart';
import 'package:guilt_flutter/commons/fix_rtl_flutter_bug.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/utils.dart';
import 'package:guilt_flutter/features/psp/presentation/manager/update_state_of_guild_cubit.dart';
import 'package:guilt_flutter/features/psp/presentation/widgets/all_guilds_widget.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
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
            child: Row(
              children: <Widget>[
                const Icon(Icons.search, color: AppColor.blue, size: 25.0),
                Expanded(
                  child: TextField(
                    controller: controller,
                    onChanged: (value) => search(),
                    style: defaultTextStyle(context).c(Colors.black87),
                    onTap: () => setState(() => fixRtlFlutterBug(controller)),
                    cursorWidth: 0.2,
                    maxLines: 1,
                    minLines: 1,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(width: 0, color: Colors.transparent)),
                      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(width: 0, color: Colors.transparent)),
                      hintText: 'جستجو ...',
                      hintStyle: Theme.of(context).textTheme.headline4!.copyWith(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
              onTap: () => _showMultiSelect(context),
              child: AbsorbPointer(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.location_city, size: 25.0),
                      const SizedBox(width: 10.0),
                      Text(selectedCity.isEmpty ? "شهری انتخاب نشده است" : "${selectedCity.length} شهر انتخاب شده"),
                      const Spacer(),
                      const RotatedBox(quarterTurns: 1, child: Icon(Icons.arrow_back_ios_rounded, size: 15.0)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
              child: AllGuildsListWidget(
                  cities: selectedCity.isNotEmpty ? selectedCity : ["یاسوج"], isJustMine: widget.isJustMine, searchText: controller.text)),
        ],
      )),
    );
  }

  void _showMultiSelect(BuildContext context) async {
    final cities = await getCitiesOfOneProvince(context, 'یزد');
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(18.0),topLeft: Radius.circular(18.0))),
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

  void search() {}
}