import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/application/colors.dart';
import 'package:guilt_flutter/application/guild/domain/entities/guild.dart';
import 'package:guilt_flutter/application/guild/presentation/manager/guild_list_cubit.dart';
import 'package:guilt_flutter/application/guild/presentation/manager/guild_list_state.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/widgets/loading_widget.dart';
import 'package:logger/logger.dart';
import 'package:qlevar_router/qlevar_router.dart';

class GuildPage extends StatelessWidget {
  const GuildPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GetIt.instance<GuildListCubit>().initialPage();
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<GuildListCubit, GuildListState>(
          builder: (context, state) {
            Logger().e("info=> ${state.toString()}");
            return state.when(
              loading: () => LoadingWidget(),
              error: (failure) => Center(child: Text(failure.message)),
              empty: () => const Center(child: Text("خالی است")),
              loaded: (guildList) => GuildListPage(guildList: guildList),
            );
          },
        ),
      ),
    );
  }

  static Widget wrappedRoute() {
    return BlocProvider(create: (ctx) => GetIt.instance<GuildListCubit>(), child: const GuildPage());
  }
}

class GuildListPage extends StatefulWidget {
  final List<Guild> guildList;

  GuildListPage({required this.guildList, Key? key}) : super(key: key);

  @override
  _GuildListPageState createState() => _GuildListPageState();
}

class _GuildListPageState extends State<GuildListPage> {
  late List<Guild> guildList;

  @override
  void initState() {
    guildList = widget.guildList;
    super.initState();
  }

  TextEditingController controller = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            child: Row(
              children: <Widget>[
                const Icon(Icons.search, color: AppColor.blue, size: 25.0),
                Expanded(
                  child: TextField(
                    controller: controller,
                    onChanged: (value) => search(),
                    style: defaultTextStyle(context).c(Colors.black87),
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
          const SizedBox(height: 8.0),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: guildList
                    .map(
                      (guild) => Card(
                        elevation: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
                        child: ListTile(
                          title: AutoSizeText(guild.name, style: defaultTextStyle(context, headline: 3), maxLines: 1, minFontSize: 2),
                          subtitle: Text(guild.city, style: defaultTextStyle(context, headline: 5).c(Colors.grey)),
                          onTap: () => QR.to('guild/${guild.id}'),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  void search() {
    guildList = widget.guildList.where((element) => element.name.contains(controller.text)).toList();
    setState(() {});
  }
}
