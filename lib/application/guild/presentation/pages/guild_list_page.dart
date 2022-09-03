import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/application/colors.dart';
import 'package:guilt_flutter/application/guild/domain/entities/guild.dart';
import 'package:guilt_flutter/application/guild/presentation/manager/guild_list_cubit.dart';
import 'package:guilt_flutter/application/guild/presentation/manager/guild_list_state.dart';
import 'package:guilt_flutter/application/guild/presentation/pages/guild_form_page.dart';
import 'package:guilt_flutter/commons/fix_rtl_flutter_bug.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/utils.dart';
import 'package:guilt_flutter/commons/widgets/loading_widget.dart';
import 'package:guilt_flutter/commons/widgets/our_button.dart';
import 'package:qlevar_router/qlevar_router.dart';

class GuildPage extends StatelessWidget {
  const GuildPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<GuildListCubit>(context).initialPage(context);
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<GuildListCubit, GuildListState>(
          builder: (context, state) {
            return state.when(
              loading: () => LoadingWidget(),
              error: (failure) => Center(child: Text(failure.message)),
              empty: () => Column(
                children: [
                  const IntroduceWidget(),
                  Center(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 15.0),
                      const Image(
                        image: AssetImage('images/empty.webp'),
                        height: 150,
                        width: 150,
                      ),
                      const SizedBox(height: 10.0),
                      Text("شما هنوز کسب و کاری ثبت نکرده اید", style: defaultTextStyle(context)),
                      const SizedBox(height: 30.0),
                      SizedBox(
                        width: 140,
                        child: OurButton(onTap: () => QR.to('/guild/add'), title: 'افزودن کسب و کار', isLoading: false),
                      )
                    ],
                  )),
                ],
              ),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const IntroduceWidget(),
            const SizedBox(height: 2.0),
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
            const SizedBox(height: 0.0),
            Column(
              children: guildList
                  .map(
                    (guild) => Card(
                      elevation: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: AutoSizeText(guild.title, style: defaultTextStyle(context, headline: 3), maxLines: 1, minFontSize: 2),
                            subtitle: Text(guild.city, style: defaultTextStyle(context, headline: 5).c(Colors.grey)),
                            onTap: () {
                              QR.to('guild/${guild.id}').then((v) => BlocProvider.of<GuildListCubit>(context).initialPage(context));
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            child: guild.isCouponRequested
                                ? GestureDetector(
                              onTap: ()async{
                                final g = guild.copyWith(isCouponRequested: false);
                                await BlocProvider.of<GuildListCubit>(context).saveGuild(g);
                                BlocProvider.of<GuildListCubit>(context).initialPage(context);
                              },
                                  child: Container(
                                      width: double.infinity,
                                      height: 45,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.rectangle,
                                        border: Border.all(color: Colors.green, width: 2),
                                        borderRadius: const BorderRadius.all(Radius.circular(6)),
                                      ),
                                      child: Text(
                                        "درخواست کالا برگ شما ثبت شد",
                                        style: defaultTextStyle(context, headline: 4).c(Colors.green).w(FontWeight.w600),
                                      ),
                                    ),
                                )
                                : OurButton(
                                    onTap: () async {
                                      isDialogOpen = true;
                                      final isOK = await showDialog(
                                        context: context,
                                        builder: (dialogContext) => AlertDialog(
                                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
                                          title: Text("درخواست کالابرگ", style: defaultTextStyle(context, headline: 3)),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                          content: Text("اینجانب ضمن تایید اطلاعات خود، توافق خود را جهت استفاده از کالابرگ و رعایت شرایط مربوطه اعلام می دارم.",
                                              style: defaultTextStyle(context, headline: 5).c(Colors.black.withOpacity(0.7))),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text("انصراف", style: defaultTextStyle(context, headline: 5).c(Colors.grey)),
                                              onPressed: () {
                                                isDialogOpen = false;
                                                Navigator.pop(dialogContext, false);
                                              },
                                            ),
                                            TextButton(
                                              child: Text("تایید", style: defaultTextStyle(context, headline: 5).c(Theme.of(context).primaryColor)),
                                              onPressed: () async {
                                                isDialogOpen = false;
                                                Navigator.pop(dialogContext, true);
                                              },
                                            ),
                                          ],
                                        ),
                                      ) as bool;
                                      isDialogOpen = false;
                                      if (isOK) {
                                        final g = guild.copyWith(isCouponRequested: true);
                                        await BlocProvider.of<GuildListCubit>(context).saveGuild(g);
                                        BlocProvider.of<GuildListCubit>(context).initialPage(context);
                                      }
                                    },
                                    title: 'درخواست کالا برگ',
                                    isLoading: false,
                                  ),
                          ),
                          const SizedBox(height: 10.0),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => QR.to('/guild/add'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  void search() {
    guildList = widget.guildList.where((element) => element.title.contains(controller.text)).toList();
    setState(() {});
  }
}

class IntroduceWidget extends StatelessWidget {
  const IntroduceWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              "به صنفینو خوش آمدید",
              style: defaultTextStyle(context, headline: 3).w(FontWeight.w900),
            ),
          ),
          const SizedBox(height: 10.0),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14.0),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              boxShadow: simpleShadow(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "سامانه صنفینو، با هدف تکمیل و ویرایش اطلاعات اصناف محترم جمهوری اسلامی ایران طراحی و پیاده سازی گردیده است",
                    textAlign: TextAlign.justify,
                    style: defaultTextStyle(context, headline: 5).h(1.9).w(FontWeight.w900),
                  ),
                ),
                const SizedBox(height: 4.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "متقاضیان ثبت نام کالابرگ، می توانند با مراجعه به سایت یا اپلیکشین صنفینو، اقدام به ثبت درخواست خود نمایند. ثبت نام و ویرایش اطلاعات در این سامانه از طریق وارد کردن شماره صنفی و کد ملی است و برای پیگیری درخواست،می توانید از قسمت پیگیری سایت، اقدام نمایید.",
                    textAlign: TextAlign.justify,
                    style: defaultTextStyle(context, headline: 5).h(1.9).w(FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
