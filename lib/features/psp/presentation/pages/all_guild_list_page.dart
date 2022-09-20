import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/application/colors.dart';
import 'package:guilt_flutter/commons/fix_rtl_flutter_bug.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/utils.dart';
import 'package:guilt_flutter/features/psp/presentation/manager/update_state_of_guild_cubit.dart';
import 'package:guilt_flutter/features/psp/presentation/widgets/all_guilds_widget.dart';
import '../manager/all_guilds_cubit.dart';

class AllGuildsListPage extends StatefulWidget {
  const AllGuildsListPage({Key? key}) : super(key: key);

  @override
  State<AllGuildsListPage> createState() => _AllGuildsListPageState();

  static Widget wrappedRoute() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (ctx) => GetIt.instance<AllGuildsCubit>()),
        BlocProvider(create: (ctx) => GetIt.instance<UpdateStateOfGuildCubit>()),
      ],
      child: const AllGuildsListPage(),
    );
  }
}

class _AllGuildsListPageState extends State<AllGuildsListPage> {
  TextEditingController controller = TextEditingController(text: '');

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
          Expanded(child: AllGuildsListWidget(cities: ["یاسوج"], searchText: controller.text)),
        ],
      )),
    );
  }

  void search() {}
}
