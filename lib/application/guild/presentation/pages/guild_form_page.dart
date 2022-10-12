import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/application/colors.dart';
import 'package:guilt_flutter/application/constants.dart';
import 'package:guilt_flutter/application/guild/domain/entities/pos.dart';
import 'package:guilt_flutter/application/guild/presentation/widgets/guild_form_widget.dart';
import 'package:guilt_flutter/application/guild/presentation/widgets/guild_label_widget.dart';
import 'package:guilt_flutter/application/guild/presentation/widgets/pos_item.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/utils.dart';
import 'package:guilt_flutter/commons/widgets/our_button.dart';
import 'package:guilt_flutter/commons/widgets/simple_snake_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../../../commons/widgets/loading_widget.dart';
import '../../domain/entities/guild.dart';
import '../manager/guild_cubit.dart';
import '../manager/guild_state.dart';

bool isDialogOpen = false;

class GuildFormPage extends StatefulWidget {
  final bool isAddNew;
  final bool isEditable;

  const GuildFormPage({required this.isAddNew, this.isEditable = false, Key? key}) : super(key: key);

  @override
  State<GuildFormPage> createState() => _GuildFormPageState();

  static Widget wrappedRoute({required bool isAddNew, bool isEditable = false}) {
    return BlocProvider(create: (ctx) => GetIt.instance<GuildCubit>(), child: GuildFormPage(isAddNew: isAddNew, isEditable: isEditable));
  }
}

class _GuildFormPageState extends State<GuildFormPage> {
  late bool isEditable;
  bool isLoading = false;
  Guild? guild;

  @override
  void initState() {
    isLoading = false;
    widget.isAddNew
        ? BlocProvider.of<GuildCubit>(context).initialPageForNewGuild()
        : BlocProvider.of<GuildCubit>(context).initialPage(QR.params['guildUuid'].toString());
    isEditable = widget.isEditable;
    super.initState();
  }

  final FormController formController = FormController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: BlocBuilder<GuildCubit, GuildState>(
            builder: (context, state) {
              return state.when(
                loading: () => LoadingWidget(),
                error: (failure) => Center(child: Text(failure.message)),
                loaded: (data) {
                  guild ??= data;
                  if (widget.isAddNew) {
                    isEditable = true;
                  }
                  return isEditable
                      ? Scaffold(
                          body: SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(height: 10.0),
                                GuildFormWidget(
                                  defaultGuild: guild!,
                                  onSubmit: (guildChanged) async {
                                    guild = guildChanged.copyWith(image: guild!.image);
                                    await widget.isAddNew
                                        ? BlocProvider.of<GuildCubit>(context).addGuild(guild!)
                                        : BlocProvider.of<GuildCubit>(context).saveGuild(guild!);
                                    setState(() => isLoading = false);
                                    QR.navigator.replaceAll(appMode.initPath);
                                  },
                                  formController: formController,
                                ),
                              ],
                            ),
                          ),
                          floatingActionButton: FloatingActionButton(
                            onPressed: () async {
                              if (!formController.onSubmitButton!()) {
                                showSnakeBar(context, "فرم شما ایراد دارد"); //todo replace with good sentence
                                return;
                              }
                              setState(() => isLoading = true);
                            },
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            child: isLoading ? LoadingWidget(size: 16, color: Colors.white) : const Icon(Icons.save),
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              Opacity(
                                opacity: isProgressAvatarHide ? 0.0 : 1.0,
                                child: LinearProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor), minHeight: 4.0),
                              ),
                              const SizedBox(height: 10.0),
                              GestureDetector(
                                onTap: () async {
                                  final ImagePicker picker = ImagePicker();
                                  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                                  if (image == null) return;
                                  setState(() => isProgressAvatarHide = false);
                                  final response = await BlocProvider.of<GuildCubit>(context).updateAvatar(guild!, image);
                                  response.fold(
                                    (l) => showSnakeBar(context, l.message),
                                    (url) => guild = guild!.copyWith(image: url),
                                  );
                                  setState(() => isProgressAvatarHide = true);
                                },
                                child: avatarWidget(context, guild!),
                              ),
                              const SizedBox(height: 10.0),
                              GuildLabelWidget(guild: guild!, onEditPressed: () => setState(() => isEditable = true)),
                              posesList(context, guild!),
                            ],
                          ),
                        );
                },
              );
            },
          ),
        ),
      
    );
  }

  bool isProgressAvatarHide = true;

  Widget avatarWidget(BuildContext context, Guild guild) {
    return AbsorbPointer(
      key: UniqueKey(),
      child: Container(
        height: 150,
        width: 150,
        alignment: Alignment.center,
        color: Colors.transparent,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 130,
                width: 130,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColor.blue, width: 2)),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(200)),
                  child: !isUrlValid(guild.image.trim())
                      ? const Image(image: AssetImage('images/avatar.png'), fit: BoxFit.cover)
                      : CachedNetworkImage(
                          imageUrl: guild.image.trim(),
                          placeholder: (_, __) => LoadingWidget(size: 50, color: AppColor.blue),
                          errorWidget: (_, __, ___) {
                            return const Image(image: AssetImage('images/avatar.png'), fit: BoxFit.cover);
                          },
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            const Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Color(0xffdddddd),
                  child: Icon(Icons.camera_alt, color: Colors.black, size: 25.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget posesList(BuildContext context, Guild guild) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 650),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ...guild.poses
                  .map((pos) => Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: PosItem(
                            pos: pos,
                            onDeletePressed: () async {
                              final listTemp = guild.poses;
                              listTemp.remove(pos);
                              guild = guild.copyWith(poses: listTemp);
                              await BlocProvider.of<GuildCubit>(context).saveGuild(guild);
                              setState(() {});
                            }),
                      ))
                  .toList(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: addPoseButton(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget addPoseButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: DottedBorder(
        color: const Color(0xff4ADE80),
        strokeWidth: 2,
        padding: EdgeInsets.zero,
        dashPattern: const [6, 6],
        borderType: BorderType.RRect,
        radius: const Radius.circular(10),
        child: GestureDetector(
          onTap: () async {
            GlobalKey<FormState> formKeyDialog = GlobalKey();
            TextEditingController pspController = TextEditingController();
            TextEditingController terminalController = TextEditingController();
            TextEditingController accountController = TextEditingController();
            isDialogOpen = true;
            await showDialog(
              context: context,
              builder: (context) => BlocProvider(
                create: (context) => GetIt.instance<GuildCubit>(),
                child: Builder(builder: (context) {
                  return AlertDialog(
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
                    content: SingleChildScrollView(
                      child: Form(
                        key: formKeyDialog,
                        onWillPop: () async => true,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              style: defaultTextStyle(context),
                              controller: terminalController,
                              keyboardType: TextInputType.name,
                              textAlign: TextAlign.end,
                              decoration: defaultInputDecoration(context).copyWith(
                                labelText: "شماره ترمینال:",
                                hintTextDirection: TextDirection.ltr,
                                contentPadding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0, bottom: 20.0),
                              ),
                              validator: (value) => posValidatorCheck(value),
                              maxLines: 1,
                            ),
                            const SizedBox(height: 10.0),
                            TextFormField(
                              style: defaultTextStyle(context),
                              controller: pspController,
                              keyboardType: TextInputType.name,
                              textAlign: TextAlign.end,
                              decoration: defaultInputDecoration(context).copyWith(
                                labelText: "psp:",
                                hintTextDirection: TextDirection.ltr,
                                contentPadding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0, bottom: 20.0),
                              ),
                              validator: (value) => posValidatorCheck(value),
                              maxLines: 1,
                            ),
                            const SizedBox(height: 10.0),
                            TextFormField(
                              style: defaultTextStyle(context),
                              controller: accountController,
                              keyboardType: TextInputType.name,
                              textAlign: TextAlign.end,
                              decoration: defaultInputDecoration(context).copyWith(
                                labelText: "شماره حساب:",
                                hintTextDirection: TextDirection.ltr,
                                contentPadding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0, bottom: 20.0),
                              ),
                              validator: (value) => posValidatorCheck(value),
                              maxLines: 1,
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              children: [
                                Expanded(
                                    child: OurButton(
                                  onTap: () {
                                    isDialogOpen = false;
                                    Navigator.pop(context);
                                  },
                                  title: "انصراف",
                                  isLoading: false,
                                  color: Colors.grey,
                                )),
                                const SizedBox(width: 12.0),
                                Expanded(
                                    child: OurButton(
                                  onTap: () async {
                                    isDialogOpen = false;
                                    if (!formKeyDialog.currentState!.validate()) {
                                      return;
                                    }
                                    final pos = Pos(
                                      terminalId: terminalController.text,
                                      accountNumber: accountController.text,
                                      psp: pspController.text,
                                    );
                                    guild = guild!.copyWith(poses: [...guild!.poses, pos]);
                                    await BlocProvider.of<GuildCubit>(context).saveGuild(guild!);
                                    Navigator.pop(context);
                                  },
                                  title: "ثبت",
                                  isLoading: false,
                                )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
            isDialogOpen = false;
            setState(() {});
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
              color: Color(0xffDCFCE7),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(Icons.add, color: Color(0xff166534), size: 25.0),
                const SizedBox(width: 10.0),
                Text("افزودن دستگاه پوز", style: defaultTextStyle(context, headline: 4).c(const Color(0xff166534)))
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? posValidatorCheck(String? value) {
    if (value == null) return null;
    if (value.isEmpty) return 'این فیلد خالی است';
    return null;
  }
}
