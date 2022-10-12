import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/application/error_page.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/widgets/loading_widget.dart';
import 'package:guilt_flutter/features/psp/domain/entities/guild_psp.dart';
import 'package:guilt_flutter/features/psp/presentation/manager/follow_up_guilds_cubit.dart';
import 'package:guilt_flutter/features/psp/presentation/manager/follow_up_guilds_state.dart';
import 'package:guilt_flutter/features/psp/presentation/manager/update_state_of_guild_cubit.dart';
import 'package:guilt_flutter/features/psp/presentation/widgets/guild_item.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';
import 'package:qlevar_router/qlevar_router.dart';

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
        // Container(
        //   margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        //   decoration: BoxDecoration(
        //     color: Colors.white,
        //     shape: BoxShape.rectangle,
        //     borderRadius: const BorderRadius.all(Radius.circular(9)),
        //     boxShadow: simpleShadow(),
        //   ),
        //   padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
        //   child: Row(
        //     children: <Widget>[
        //       const Icon(Icons.search, color: AppColor.blue, size: 25.0),
        //       Expanded(
        //         child: TextField(
        //           controller: controller,
        //           onChanged: (value) => search(value),
        //           style: defaultTextStyle(context).c(Colors.black87),
        //           onTap: () => setState(() => fixRtlFlutterBug(controller)),
        //           cursorWidth: 0.2,
        //           maxLines: 1,
        //           minLines: 1,
        //           decoration: InputDecoration(
        //             enabledBorder: const OutlineInputBorder(borderSide: BorderSide(width: 0, color: Colors.transparent)),
        //             focusedBorder: const OutlineInputBorder(borderSide: BorderSide(width: 0, color: Colors.transparent)),
        //             hintText: 'جستجو ...',
        //             hintStyle: Theme.of(context).textTheme.headline4!.copyWith(color: Colors.grey),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        const SizedBox(height: 10.0),
        Expanded(child: child),
      ],
    );
  }

  void search(String value) {
    if (value == BlocProvider.of<FollowUpGuildsCubit>(context).currentSearchText) return;
    BlocProvider.of<FollowUpGuildsCubit>(context).initialPage(selectedCity, searchText: value);
  }
}
