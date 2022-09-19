import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/widgets/loading_widget.dart';
import 'package:guilt_flutter/features/psp/presentation/widgets/guild_item.dart';

import '../manager/all_guilds_cubit.dart';
import '../manager/all_guilds_state.dart';

class AllGuildsListWidget extends StatefulWidget {
  final List<String> cities;

  const AllGuildsListWidget({required this.cities, Key? key}) : super(key: key);

  @override
  State<AllGuildsListWidget> createState() => _AllGuildsListWidgetState();
}

class _AllGuildsListWidgetState extends State<AllGuildsListWidget> {
  @override
  Widget build(BuildContext context) {
    _retry(context);
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<AllGuildsCubit, AllGuildsState>(
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
              loaded: (guildList) {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                  scrollDirection: Axis.vertical,
                  itemCount: guildList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GuildItem(guild: guildList[index]);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _retry(BuildContext context) {
    BlocProvider.of<AllGuildsCubit>(context).initialPage(widget.cities, 1);
  }
}
