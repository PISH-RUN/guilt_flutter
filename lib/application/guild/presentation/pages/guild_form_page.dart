import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/application/colors.dart';
import 'package:guilt_flutter/application/constants.dart';
import 'package:guilt_flutter/commons/widgets/our_text_field.dart';
import 'package:latlong2/latlong.dart' as lat_lng;
import 'package:logger/logger.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../../../commons/fix_rtl_flutter_bug.dart';
import '../../../../commons/text_style.dart';
import '../../../../commons/utils.dart';
import '../../../../commons/widgets/loading_widget.dart';
import '../../../../commons/widgets/our_button.dart';
import '../../../../commons/widgets/our_item_picker.dart';
import '../../../../commons/widgets/warning_dialog.dart';
import '../../domain/entities/guild.dart';
import '../../domain/entities/pos.dart';
import '../manager/guild_cubit.dart';
import '../manager/guild_state.dart';
import '../widgets/map_widget.dart';
import '../widgets/pos_item.dart';

bool isLoading = false;
bool isDialogOpen = false;

class GuildFormPage extends StatelessWidget {
  final bool isAddNew;
  final bool isEditable;

  const GuildFormPage({required this.isAddNew, this.isEditable = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isAddNew) BlocProvider.of<GuildCubit>(context).initialPage(QR.params['guildUuid'].toString());
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: isAddNew
              ? BlocListener<GuildCubit, GuildState>(
                  listener: (context, state) {
                    if (state is Loaded) {
                      isLoading = false;
                      QR.navigator.replaceAll(appMode.initPath);
                    }
                  },
                  child: GuildFormWidget(isAddNew: true, guild: Guild.fromEmpty(), isEditable: isEditable),
                )
              : BlocBuilder<GuildCubit, GuildState>(
                  builder: (context, state) {
                    return state.when(
                      loading: () => LoadingWidget(),
                      error: (failure) => Center(child: Text(failure.message)),
                      loaded: (guild) {
                        return GuildFormWidget(isAddNew: false, guild: guild, isEditable: isEditable);
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }

  static Widget wrappedRoute({required bool isAddNew, bool isEditable = false}) {
    return BlocProvider(create: (ctx) => GetIt.instance<GuildCubit>(), child: GuildFormPage(isAddNew: isAddNew, isEditable: isEditable));
  }
}

class GuildFormWidget extends StatefulWidget {
  final Guild guild;
  final bool isAddNew;
  final bool isEditable;
  final bool isPsp;
  final void Function(Guild guild)? onSubmitFormInPsps;

  const GuildFormWidget(
      {required this.guild, required this.isAddNew, required this.isEditable, this.isPsp = false, this.onSubmitFormInPsps, Key? key})
      : super(key: key);

  @override
  _GuildFormWidgetState createState() => _GuildFormWidgetState();
}

class _GuildFormWidgetState extends State<GuildFormWidget> {
  late Guild guild;

  late TextEditingController addressController;
  late TextEditingController provinceController;
  late TextEditingController isicController;
  late String isic;
  late TextEditingController cityController;
  late TextEditingController postalCodeController;
  late TextEditingController homeTelephoneController;
  late TextEditingController organController;
  late TextEditingController guildNameController;
  late lat_lng.LatLng? pinLocation;

  final GlobalKey<FormState> formKey = GlobalKey();
  bool isEditable = false;

  @override
  void initState() {
    isEditable = widget.isEditable;
    guild = widget.guild;
    organController = TextEditingController(text: guild.organName);
    guildNameController = TextEditingController(text: guild.title);
    addressController = TextEditingController(text: guild.address);
    provinceController = TextEditingController(text: guild.province);
    isicController = TextEditingController(text: guild.isic.name);
    isic = guild.isic.name;
    cityController = TextEditingController(text: guild.city);
    postalCodeController = TextEditingController(text: guild.postalCode);
    homeTelephoneController = TextEditingController(text: guild.homeTelephone);
    pinLocation = guild.location;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: widget.isPsp
          ? formWidget(context)
          : Scaffold(
              body: Stack(
                children: [
                  formWidget(context),
                ],
              ),
              floatingActionButton: isEditable || widget.isAddNew
                  ? FloatingActionButton(
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        isLoading = true;
                        setState(() {});
                        formKey.currentState!.save();
                        widget.isAddNew
                            ? BlocProvider.of<GuildCubit>(context).addGuild(guild)
                            : await BlocProvider.of<GuildCubit>(context).saveGuild(guild);
                        if (isEditable) {
                          isLoading = false;
                          QR.navigator.replaceAll(appMode.initPath);
                        }
                      },
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      child: isLoading ? LoadingWidget(size: 16, color: Colors.white) : const Icon(Icons.save),
                    )
                  : null,
            ),
    );
  }

  Form formWidget(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 40.0),
            baseInformationWidget(context),
            const SizedBox(height: 10.0),
            if (!widget.isAddNew && !isEditable)
              guild.poses.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: addPoseButton(context),
                    )
                  : posesList(context),
            const SizedBox(height: 10.0),
            if (widget.isPsp) submitButton(context),
          ],
        ),
      ),
    );
  }

  bool isLoadingSubmit = false;

  Widget submitButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.onSubmitFormInPsps == null) return;
        if (!formKey.currentState!.validate()) {
          return;
        }
        formKey.currentState!.save();
        setState(() {isLoadingSubmit = true;});
        widget.onSubmitFormInPsps!(guild);
        setState(() {isLoadingSubmit = true;});
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        padding: const EdgeInsets.all(18),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: AppColor.blue, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(10)),
        child: isLoadingSubmit
            ? LoadingWidget(color: Colors.white, size: 20)
            : Text("اعمال تغییرات و تایید نهایی", style: defaultTextStyle(context, headline: 4).c(Colors.white)),
      ),
    );
  }

  double paddingBetweenTextFiled = 10.0;

  Widget baseInformationWidget(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 650),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      const SizedBox(width: 56.0),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text("اطلاعات کسب و کار", style: defaultTextStyle(context, headline: 3)),
                      ),
                      const Spacer(),
                      isEditable || widget.isAddNew
                          ? const SizedBox(width: 56.0)
                          : GestureDetector(
                              onTap: () async {
                                await showDialog(
                                  context: context,
                                  builder: (dialogContext) => WarningDialog(onResult: (isAccess) {
                                    if (isAccess) {
                                      setState(() => isEditable = true);
                                    }
                                  }),
                                );
                              },
                              child: AbsorbPointer(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      const Icon(Icons.edit, color: Colors.blueGrey, size: 15.0),
                                      const SizedBox(width: 4.0),
                                      Text("ویرایش", style: defaultTextStyle(context, headline: 5).c(Colors.blueGrey)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      isEditable || widget.isAddNew
                          ? OurTextField(
                              title: "نام کسب و کار",
                              textFormField: TextFormField(
                                style: defaultTextStyle(context).c(const Color(0xff2F3135)),
                                controller: guildNameController,
                                keyboardType: TextInputType.name,
                                onTap: () => setState(() => fixRtlFlutterBug(guildNameController)),
                                decoration: defaultInputDecoration(context).copyWith(
                                  hintText: 'نام کسب و کار',
                                  prefixIcon: const Icon(Icons.store, color: Color(0xffA0A8B1), size: 25.0),
                                ),
                                validator: (value) {
                                  if (value == null) return null;
                                  if (value.isEmpty) return "این فیلد الزامی است";
                                  return null;
                                },
                                onSaved: (value) => guild = guild.copyWith(title: value),
                              ),
                            )
                          : labelWidget(Icons.store, "نام کسب و کار", guildNameController.text),
                      SizedBox(height: paddingBetweenTextFiled),
                      isEditable || widget.isAddNew
                          ? OurTextField(
                              title: "نام ارگان",
                              textFormField: TextFormField(
                                style: defaultTextStyle(context).c(const Color(0xff2F3135)),
                                controller: organController,
                                keyboardType: TextInputType.name,
                                onTap: () => setState(() => fixRtlFlutterBug(organController)),
                                decoration: defaultInputDecoration(context).copyWith(
                                  hintText: 'نام ارگان',
                                  prefixIcon: const Icon(Icons.store, color: Color(0xffA0A8B1), size: 25.0),
                                ),
                                validator: (value) {
                                  if (value == null) return null;
                                  if (value.isEmpty) return "این فیلد الزامی است";
                                  return null;
                                },
                                onSaved: (value) => guild = guild.copyWith(organName: value),
                              ),
                            )
                          : labelWidget(Icons.store, "نام ارگان", organController.text),
                      SizedBox(height: paddingBetweenTextFiled),
                      isEditable || widget.isAddNew
                          ? OurTextField(
                              title: "شماره تلفن صنف",
                              textFormField: TextFormField(
                                style: defaultTextStyle(context).c(const Color(0xff2F3135)),
                                controller: homeTelephoneController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.end,
                                decoration: defaultInputDecoration(context).copyWith(
                                  hintText: 'شماره تلفن صنف',
                                  hintTextDirection: TextDirection.ltr,
                                  contentPadding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0, bottom: 20.0),
                                  prefixIcon: const Icon(Icons.phone, color: Color(0xffA0A8B1), size: 25.0),
                                ),
                                validator: (value) {
                                  if (value == null) return null;
                                  if (value.isEmpty) return "وارد کردن شماره تلفن ضروری است";
                                  return null;
                                },
                                onSaved: (value) => guild = guild.copyWith(homeTelephone: value),
                              ),
                            )
                          : labelWidget(Icons.phone, "شماره تلفن صنف", homeTelephoneController.text),
                      SizedBox(height: paddingBetweenTextFiled),
                      isEditable || widget.isAddNew
                          ? OurItemPicker(
                              hint: "رسته صنفی",
                              icon: Icons.store,
                              items: getListOfIsic().map((e) => e.name).toList(),
                              onChanged: (value) {
                                final isic = getIsicWithName(value);
                                guild = guild.copyWith(isic: isic);
                              },
                              currentText: isicController.text,
                              controller: isicController,
                            )
                          : labelWidget(Icons.store, "رسته صنفی", isic),
                      SizedBox(height: paddingBetweenTextFiled),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: isEditable || widget.isAddNew
                                ? OurItemPicker(
                                    hint: "استان",
                                    headlineSize: 6,
                                    icon: Icons.pin_drop_outlined,
                                    items: null,
                                    onFillParams: () => getIranProvince(context),
                                    onChanged: (value) {
                                      guild = guild.copyWith(province: value, city: '');
                                      cityController.text = '';
                                    },
                                    currentText: provinceController.text,
                                    controller: provinceController,
                                  )
                                : labelWidget(Icons.pin_drop_outlined, "استان", provinceController.text, headlineDescription: 4, headlineTitle: 5),
                          ),
                          SizedBox(width: paddingBetweenTextFiled),
                          Expanded(
                            child: isEditable || widget.isAddNew
                                ? OurItemPicker(
                                    key: UniqueKey(),
                                    hint: "شهرستان",
                                    headlineSize: 6,
                                    icon: Icons.pin_drop_outlined,
                                    items: null,
                                    onChanged: (value) async {
                                      final province = await getProvinceOfOneCity(context, value);
                                      provinceController.text = province;
                                      guild = guild.copyWith(city: value, province: province);
                                    },
                                    onFillParams: () => getCitiesOfOneProvince(context, provinceController.text.trim()),
                                    currentText: cityController.text,
                                    controller: cityController,
                                  )
                                : labelWidget(Icons.pin_drop_outlined, "شهرستان", cityController.text, headlineDescription: 4, headlineTitle: 5),
                          ),
                        ],
                      ),
                      SizedBox(height: paddingBetweenTextFiled),
                      isEditable || widget.isAddNew
                          ? OurTextField(
                              title: "کد پستی",
                              textFormField: TextFormField(
                                style: defaultTextStyle(context).c(const Color(0xff2F3135)),
                                controller: postalCodeController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.end,
                                decoration: defaultInputDecoration(context).copyWith(
                                  hintText: 'کد پستی',
                                  hintTextDirection: TextDirection.ltr,
                                  contentPadding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0, bottom: 20.0),
                                  prefixIcon: const Icon(Icons.map, color: Color(0xffA0A8B1), size: 25.0),
                                ),
                                validator: (value) {
                                  if (value == null) return null;
                                  if (value.isEmpty) return "وارد کردن کد پستی ضروری است";
                                  if (value.length != 10) return "کد پستی باید ده رقم باشد";
                                  return null;
                                },
                                onSaved: (value) => guild = guild.copyWith(postalCode: value),
                              ),
                            )
                          : labelWidget(Icons.map, "کد پستی", postalCodeController.text),
                      SizedBox(height: paddingBetweenTextFiled),
                      isEditable || widget.isAddNew
                          ? OurTextField(
                              title: "نشانی کامل",
                              textFormField: TextFormField(
                                style: defaultTextStyle(context).c(const Color(0xff2F3135)),
                                controller: addressController,
                                keyboardType: TextInputType.streetAddress,
                                onTap: () => setState(() => fixRtlFlutterBug(addressController)),
                                decoration: defaultInputDecoration(context).copyWith(
                                  hintText: 'نشانی کامل',
                                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                                  prefixIcon: const Icon(Icons.pin_drop_outlined, color: Color(0xffA0A8B1), size: 25.0),
                                ),
                                onSaved: (value) => guild = guild.copyWith(address: value),
                                minLines: 4,
                                maxLines: 4,
                              ),
                            )
                          : labelWidget(Icons.pin_drop_outlined, "نشانی کامل", addressController.text),
                      SizedBox(height: paddingBetweenTextFiled),
                      if (widget.isAddNew || isEditable || pinLocation != null)
                        GestureDetector(
                          onTap: () async {
                            if (!isEditable && !widget.isAddNew) {
                              return;
                            }
                            isDialogOpen = true;
                            await showDialog(
                              context: context,
                              builder: (_) => WillPopScope(
                                onWillPop: () async {
                                  isDialogOpen = false;
                                  return true;
                                },
                                child: AlertDialog(
                                  contentPadding: EdgeInsets.zero,
                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                                  content: MapWidget(
                                    key: UniqueKey(),
                                    defaultPinLocation: pinLocation,
                                    onChangePinLocation: (location) {
                                      pinLocation = location;
                                      guild = guild.copyWith(location: pinLocation);
                                      setState(() => isDialogOpen = false);
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                          child: AbsorbPointer(
                            child: Container(
                              width: double.infinity,
                              height: 180,
                              decoration: BoxDecoration(
                                color: Colors.blueGrey.withOpacity(0.4),
                                shape: BoxShape.rectangle,
                                borderRadius: const BorderRadius.all(Radius.circular(16)),
                              ),
                              child: pinLocation == null
                                  ? Center(
                                      child: Text(
                                        "موقعیت کسب و کار خود را روی نقشه پیدا کنید",
                                        style: defaultTextStyle(context, headline: 4).c(Colors.white),
                                      ),
                                    )
                                  : MapScreenShotWidget(pinLocation: pinLocation!),
                            ),
                          ),
                        ),
                      SizedBox(height: paddingBetweenTextFiled),
                      const SizedBox(height: 26.0),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget posesList(BuildContext context) {
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
                                    guild = guild.copyWith(poses: [...guild.poses, pos]);
                                    await BlocProvider.of<GuildCubit>(context).saveGuild(guild);
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

  Widget labelWidget(IconData icon, String label, String value, {int headlineDescription = 3, int headlineTitle = 4}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Padding(padding: const EdgeInsets.only(bottom: 4.0), child: Icon(icon, color: Colors.grey)),
              const SizedBox(width: 8.0),
              Text("$label:", style: defaultTextStyle(context, headline: headlineTitle).c(Colors.grey)),
            ],
          ),
          const SizedBox(height: 0.0),
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: Text(
              value.isEmpty ? "هنوز وارد نکردید" : value,
              style: defaultTextStyle(context, headline: headlineDescription).c(value.isNotEmpty ? Colors.black : Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}

InputDecoration defaultInputDecoration(BuildContext context) {
  return const InputDecoration().copyWith(
    helperText: '',
    helperMaxLines: 1,
    filled: true,
    fillColor: const Color(0xffF2F4F5),
    contentPadding: const EdgeInsets.symmetric(vertical: 20.0),
    hintStyle: defaultTextStyle(context).c(const Color(0xffA0A8B1)),
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(width: 0.0, color: Colors.transparent),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(width: 1.3, color: Color(0xffA0A8B1)),
    ),
  );
}
