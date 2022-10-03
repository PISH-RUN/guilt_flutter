import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/widgets/loading_widget.dart';
import 'package:guilt_flutter/features/psp/domain/entities/guild_psp.dart';
import 'package:guilt_flutter/features/psp/presentation/widgets/guild_item.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';

import '../manager/all_guilds_cubit.dart';
import '../manager/all_guilds_state.dart';

class AllGuildsListWidget extends StatefulWidget {
  final List<String> cities;
  final String searchText;
  final bool isJustMine;

  const AllGuildsListWidget({required this.cities, required this.isJustMine, required this.searchText, Key? key}) : super(key: key);

  @override
  State<AllGuildsListWidget> createState() => _AllGuildsListWidgetState();
}

class _AllGuildsListWidgetState extends State<AllGuildsListWidget> {
  final PagingController<int, GuildPsp> _pagingController = PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      BlocProvider.of<AllGuildsCubit>(context).getMoreItem();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AllGuildsCubit, AllGuildsState>(
          listener: (context, state) {},
          buildWhen: (previous, current) {
            return current.when(loading: () => false, error: (_) => false, empty: () => true, loaded: (_) => true);
          },
          builder: (context, state) {
            return state.when(
              loading: () => LoadingWidget(),
              error: (failure) => Center(child: Text(failure.message)),
              empty: () => Column(
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
              loaded: (data) {
                if (data.isLastPage) {
                  _pagingController.appendLastPage(data.list);
                } else {
                  final nextPageKey = ((data.currentPage - 1) * data.perPage) + data.list.length;
                  _pagingController.appendPage(data.list, nextPageKey);
                }
                return PagedListView<int, GuildPsp>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<GuildPsp>(
                  itemBuilder: (context, item, index) => GuildItem(guild: item),
                ),
              );
              },
            );
          },
        ),
      ),
    );
  }

  void _retry(BuildContext context) {
    BlocProvider.of<AllGuildsCubit>(context).initialPage(widget.cities, widget.isJustMine, searchText: widget.searchText);
  }
}
