import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/application/colors.dart';
import 'package:guilt_flutter/application/constants.dart';
import 'package:guilt_flutter/application/guild/presentation/widgets/guild_form_widget.dart';
import 'package:guilt_flutter/application/guild/presentation/widgets/guild_label_widget.dart';
import 'package:guilt_flutter/application/guild/presentation/widgets/poses_list_widget.dart';
import 'package:guilt_flutter/commons/utils.dart';
import 'package:guilt_flutter/commons/widgets/simple_snake_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
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
        child: BlocConsumer<GuildCubit, GuildState>(
          listener: (context, state) {
            Logger().i("info=> ${state} ");
            state.maybeWhen(errorSave: (failure) => showSnakeBar(context, failure.message), orElse: () {});
          },
          listenWhen: (previous, current) {
            return current.maybeWhen(errorSave: (_) => true, orElse: () => false);
          },
          buildWhen: (previous, current) {
            return current.maybeWhen(errorSave: (_) => false, orElse: () => true);
          },
          builder: (context, state) {
            return state.when(
              loading: () => LoadingWidget(),
              error: (failure) => Center(child: Text(failure.message)),
              errorSave: (failure) => Center(child: Text(failure.message)),
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
                          formController: formController,
                        ),
                      ],
                    ),
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () async {
                      setState(() => isLoading = true);
                      final guildChanged = formController.onSubmitButton!();
                      if (guildChanged==null) {
                        setState(() => isLoading = false);
                        showSnakeBar(context, "فرم شما ایراد دارد");
                        return;
                      }
                      setState(() => isLoading = true);
                      guild = guildChanged.copyWith(image: guild!.image);
                      await widget.isAddNew
                          ? BlocProvider.of<GuildCubit>(context).addGuild(guild!)
                          : BlocProvider.of<GuildCubit>(context).saveGuild(guild!);
                      await Future.delayed(const Duration(seconds: 2), () => "1");
                      setState(() => isLoading = false);
                      QR.navigator.replaceAll(appMode.initPath);
                    },
                    backgroundColor: Theme
                        .of(context)
                        .primaryColor,
                    foregroundColor: Colors.white,
                    child: isLoading ? LoadingWidget(size: 16, color: Colors.white) : const Icon(Icons.save),
                  ),
                )
                    : SingleChildScrollView(
                  child: Column(
                    children: [
                      Opacity(
                        opacity: isProgressAvatarHide ? 0.0 : 1.0,
                        child:
                        LinearProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme
                            .of(context)
                            .primaryColor), minHeight: 4.0),
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
                      PosesListWidget(
                        posesList: guild!.poses,
                        addedNewPose: (pos) async {
                          guild = guild!.copyWith(poses: [...guild!.poses, pos]);
                          setState(() {});
                          await BlocProvider.of<GuildCubit>(context).saveGuild(guild!);
                        },
                        deletedOnePose: (pos) async {
                          final listTemp = guild!.poses;
                          listTemp.remove(pos);
                          guild = guild!.copyWith(poses: listTemp);
                          setState(() {});
                          await BlocProvider.of<GuildCubit>(context).saveGuild(guild!);
                        },
                      ),
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
}
