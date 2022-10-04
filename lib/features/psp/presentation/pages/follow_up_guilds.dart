import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/application/colors.dart';
import 'package:guilt_flutter/application/error_page.dart';
import 'package:guilt_flutter/commons/fix_rtl_flutter_bug.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/utils.dart';
import 'package:guilt_flutter/commons/widgets/loading_widget.dart';
import 'package:guilt_flutter/features/psp/domain/entities/guild_psp.dart';
import 'package:guilt_flutter/features/psp/presentation/manager/follow_up_guilds_cubit.dart';
import 'package:guilt_flutter/features/psp/presentation/manager/follow_up_guilds_state.dart';
import 'package:guilt_flutter/features/psp/presentation/manager/update_state_of_guild_cubit.dart';
import 'package:guilt_flutter/features/psp/presentation/widgets/guild_item.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class FollowUpGuildsListPage extends StatefulWidget {
  const FollowUpGuildsListPage({Key? key}) : super(key: key);

  @override
  State<FollowUpGuildsListPage> createState() => _FollowUpGuildsListPageState();

  static Widget wrappedRoute() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (ctx) => GetIt.instance<FollowUpGuildsCubit>()),
        BlocProvider(create: (ctx) => GetIt.instance<UpdateStateOfGuildCubit>()),
      ],
      child: const FollowUpGuildsListPage(),
    );
  }
}

class _FollowUpGuildsListPageState extends State<FollowUpGuildsListPage> {
  TextEditingController controller = TextEditingController(text: '');

  List<String> selectedCity = [];
  final PagingController<int, GuildPsp> _pagingController = PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      BlocProvider.of<FollowUpGuildsCubit>(context).getMoreItem();
    });
    BlocProvider.of<FollowUpGuildsCubit>(context).initialPage([], searchText: "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: BlocBuilder<FollowUpGuildsCubit, FollowUpGuildsState>(
        builder: (context, state) {
          return state.when(
              loading: () => LoadingWidget(),
              error: (failure) => ErrorPage(failure: failure),
              empty: () => defaultTemplate(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 15.0),
                            const Image(image: AssetImage('images/empty.webp'), height: 150, width: 150),
                            const SizedBox(height: 10.0),
                            Text("کسب و کاری با مشخصات زیر موجود نمی باشد", style: defaultTextStyle(context)),
                          ],
                        ),
                      ],
                    ),
                  ),
              loaded: (data) {
                if (data.isLastPage) {
                  _pagingController.appendLastPage(data.list);
                } else {
                  final nextPageKey = ((data.currentPage - 1) * data.perPage) + data.list.length;
                  _pagingController.appendPage(data.list, nextPageKey);
                }
                return defaultTemplate(
                    child: PagedListView<int, GuildPsp>(
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<GuildPsp>(
                    itemBuilder: (context, item, index) => GuildItem(guild: item),
                  ),
                ));
              });
        },
      )),
    );
  }

  Widget defaultTemplate({required Widget child}) {
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
        Expanded(child: child),
      ],
    );
  }

  void _showMultiSelect(BuildContext context) async {
    final cities = await getCitiesOfOneProvince(context, 'یزد');
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(18.0), topLeft: Radius.circular(18.0))),
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
