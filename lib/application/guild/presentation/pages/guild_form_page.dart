import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:guilt_flutter/application/guild/domain/entities/guild.dart';
import 'package:guilt_flutter/application/guild/presentation/manager/guild_cubit.dart';
import 'package:guilt_flutter/application/guild/presentation/manager/guild_state.dart';
import 'package:guilt_flutter/application/guild/presentation/widgets/map_widget.dart';
import 'package:guilt_flutter/commons/fix_rtl_flutter_bug.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/utils.dart';
import 'package:guilt_flutter/commons/widgets/loading_widget.dart';
import 'package:guilt_flutter/commons/widgets/our_item_picker.dart';
import 'package:latlong2/latlong.dart' as lat_lng;

class GuildFormPage extends StatelessWidget {
  final bool isAddNew;

  const GuildFormPage({required this.isAddNew, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isAddNew
            ? GuildFormWidget(isAddNew: true, guild: Guild.fromEmpty())
            : BlocBuilder<GuildCubit, GuildState>(
                builder: (context, state) {
                  return state.when(
                    loading: () => LoadingWidget(),
                    error: (failure) => Center(child: Text(failure.message)),
                    loaded: (guild) => GuildFormWidget(isAddNew: false, guild: guild),
                  );
                },
              ),
      ),
    );
  }

  static Widget wrappedRoute(bool isAddNew) {
    return BlocProvider(create: (ctx) => GetIt.instance<GuildCubit>(), child: GuildFormPage(isAddNew: isAddNew));
  }
}

class GuildFormWidget extends StatefulWidget {
  final Guild guild;
  final bool isAddNew;

  const GuildFormWidget({required this.guild, required this.isAddNew, Key? key}) : super(key: key);

  @override
  _GuildFormWidgetState createState() => _GuildFormWidgetState();
}

class _GuildFormWidgetState extends State<GuildFormWidget> {
  late Guild guild;

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController addressController;
  late TextEditingController provinceController;
  late String isic;
  late TextEditingController cityController;
  late TextEditingController postalCodeController;
  late TextEditingController phoneController;
  late TextEditingController nationalCodeController;
  late lat_lng.LatLng? pinLocation;

  final GlobalKey<FormState> formKey = GlobalKey();
  bool isEditable = false;

  @override
  void initState() {
    guild = widget.guild;
    firstNameController = TextEditingController(text: guild.firstName);
    lastNameController = TextEditingController(text: guild.lastName);
    addressController = TextEditingController(text: guild.address);
    provinceController = TextEditingController(text: guild.province);
    isic = guild.isicName;
    cityController = TextEditingController(text: guild.city);
    cityController = TextEditingController(text: guild.city);
    postalCodeController = TextEditingController(text: guild.postalCode);
    phoneController = TextEditingController(text: guild.phoneNumber);
    nationalCodeController = TextEditingController(text: guild.nationalCode);
    pinLocation = guild.location;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Form(
            key: formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 40.0),
                        baseInformationWidget(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: isEditable
          ? FloatingActionButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) {
                  return;
                }
                formKey.currentState!.save();
                widget.isAddNew ? BlocProvider.of<GuildCubit>(context).addGuild(guild) : BlocProvider.of<GuildCubit>(context).saveGuild(guild);
                isEditable = false;
                setState(() {});
              },
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              child: const Icon(Icons.save),
            )
          : null,
    );
  }

  double paddingBetweenTextFiled = 20.0;

  Widget baseInformationWidget(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 650),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      const SizedBox(width: 56.0),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text("اطلاعات صنف", style: defaultTextStyle(context, headline: 3)),
                      ),
                      const Spacer(),
                      isEditable
                          ? const SizedBox(width: 56.0)
                          : GestureDetector(
                              onTap: () async {
                                final isOK = await showDialog(
                                  context: context,
                                  builder: (dialogContext) => AlertDialog(
                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
                                    title: Text("ویرایش", style: defaultTextStyle(context, headline: 3)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                    content: Text("آیا مایل به ویرایش اطلاعات این صنف می باشید؟",
                                        style: defaultTextStyle(context, headline: 5).c(Colors.black.withOpacity(0.7))),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text("لغو", style: defaultTextStyle(context, headline: 5).c(Colors.grey)),
                                        onPressed: () {
                                          Navigator.pop(dialogContext, false);
                                        },
                                      ),
                                      TextButton(
                                        child: Text("ثبت", style: defaultTextStyle(context, headline: 5).c(Theme.of(context).primaryColor)),
                                        onPressed: () async {
                                          Navigator.pop(dialogContext, true);
                                        },
                                      ),
                                    ],
                                  ),
                                ) as bool;
                                if (isOK) {
                                  setState(() => isEditable = true);
                                }
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
                  AbsorbPointer(
                    absorbing: !isEditable,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        isEditable
                            ? TextFormField(
                                style: defaultTextStyle(context),
                                controller: firstNameController,
                                keyboardType: TextInputType.name,
                                onTap: () => setState(() => fixRtlFlutterBug(firstNameController)),
                                decoration: defaultInputDecoration().copyWith(labelText: "نام", prefixIcon: const Icon(Icons.person_outline)),
                                validator: (value) {
                                  if (value == null) return null;
                                  if (value.isEmpty) return "این فیلد الزامی است";
                                  if (value.length < 2) return "نام کوتاه است";
                                  return null;
                                },
                                onSaved: (value) => guild = guild.copyWith(firstName: value),
                              )
                            : labelWidget(Icons.person_outline, "نام", firstNameController.text),
                        SizedBox(height: paddingBetweenTextFiled),
                        isEditable
                            ? TextFormField(
                                style: defaultTextStyle(context),
                                controller: lastNameController,
                                keyboardType: TextInputType.name,
                                onTap: () => setState(() => fixRtlFlutterBug(lastNameController)),
                                decoration:
                                    defaultInputDecoration().copyWith(labelText: "نام خانوادگی", prefixIcon: const Icon(Icons.person_outline)),
                                validator: (value) {
                                  if (value == null) return null;
                                  if (value.isEmpty) return "این فیلد الزامی است";
                                  if (value.length < 2) return "نام خانوادگی کوتاه است";
                                  return null;
                                },
                                onSaved: (value) => guild = guild.copyWith(lastName: value),
                              )
                            : labelWidget(Icons.person_outline, "نام خانوادگی", lastNameController.text),
                        SizedBox(height: paddingBetweenTextFiled),
                        isEditable
                            ? TextFormField(
                                style: defaultTextStyle(context),
                                decoration: defaultInputDecoration().copyWith(
                                  labelText: "شماره تلفن",
                                  prefixIcon: const Icon(Icons.phone),
                                ),
                                textAlign: TextAlign.end,
                                keyboardType: TextInputType.number,
                                controller: phoneController,
                                validator: (value) {
                                  if (value == null) return null;
                                  if (value.isEmpty) return "وارد کردن شماره تلفن ضروری است";
                                  if (!validatePhoneNumber(value)) return "شماره تلفن معتبر نیست";
                                  return null;
                                },
                                onSaved: (value) => guild = guild.copyWith(phoneNumber: value),
                              )
                            : labelWidget(Icons.phone, "شماره تلفن", phoneController.text),
                        SizedBox(height: paddingBetweenTextFiled),
                        isEditable
                            ? TextFormField(
                                style: defaultTextStyle(context),
                                decoration: defaultInputDecoration().copyWith(labelText: "کد ملی", prefixIcon: const Icon(Icons.pin)),
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.end,
                                controller: nationalCodeController,
                                validator: (value) {
                                  if (value == null) return null;
                                  if (value.isEmpty) return "وارد کردن کد ملی ضروری است";
                                  if (value.length != 10) return "کد ملی باید ده رقم باشد";
                                  return null;
                                },
                                onSaved: (value) => guild = guild.copyWith(nationalCode: value),
                              )
                            : labelWidget(Icons.pin, "کد ملی", nationalCodeController.text),
                        SizedBox(height: paddingBetweenTextFiled),
                        isEditable
                            ? OurItemPicker(
                                hint: "شماره isic",
                                icon: Icons.pin,
                                items: null,
                                onFillParams: () async => (await getListOfIsic(context)).map((e) => e.name).toList(),
                                onChanged: (value) async {
                                  final isic = (await getListOfIsic(context)).firstWhere((element) => element.name == value);
                                  guild = guild.copyWith(isicCoding: isic.code, isicName: isic.name);
                                },
                                currentText: isic,
                                controller: provinceController,
                              )
                            : labelWidget(Icons.pin, "شماره isic", isic),
                        SizedBox(height: paddingBetweenTextFiled),
                        isEditable
                            ? OurItemPicker(
                                hint: "استان محل سکونت",
                                icon: Icons.pin_drop_outlined,
                                items: null,
                                onFillParams: () => getIranProvince(context),
                                onChanged: (value) {
                                  guild = guild.copyWith(province: value);
                                },
                                currentText: provinceController.text,
                                controller: provinceController,
                              )
                            : labelWidget(Icons.pin_drop_outlined, "استان محل سکونت", provinceController.text),
                        SizedBox(height: paddingBetweenTextFiled),
                        isEditable
                            ? OurItemPicker(
                                key: UniqueKey(),
                                hint: "شهر محل سکونت",
                                icon: Icons.pin_drop_outlined,
                                items: null,
                                onChanged: (value) async {
                                  guild = guild.copyWith(city: value);
                                },
                                onFillParams: () => getCitiesOfOneProvince(context, provinceController.text.trim()),
                                currentText: cityController.text,
                                controller: cityController,
                              )
                            : labelWidget(Icons.pin_drop_outlined, "شهر محل سکونت", provinceController.text),
                        SizedBox(height: paddingBetweenTextFiled),
                        isEditable
                            ? TextFormField(
                                style: defaultTextStyle(context),
                                decoration: defaultInputDecoration().copyWith(labelText: "کد پستی", prefixIcon: const Icon(Icons.map)),
                                textAlign: TextAlign.end,
                                keyboardType: TextInputType.number,
                                controller: postalCodeController,
                                validator: (value) {
                                  if (value == null) return null;
                                  if (value.isEmpty) return "وارد کردن کد پستی ضروری است";
                                  if (value.length != 10) return "کد پستی باید ده رقم باشد";
                                  return null;
                                },
                                onSaved: (value) => guild = guild.copyWith(postalCode: value),
                              )
                            : labelWidget(Icons.map, "کد پستی", postalCodeController.text),
                        SizedBox(height: paddingBetweenTextFiled),
                        isEditable
                            ? TextFormField(
                                style: defaultTextStyle(context),
                                controller: addressController,
                                keyboardType: TextInputType.streetAddress,
                                onTap: () => setState(() => fixRtlFlutterBug(addressController)),
                                decoration: defaultInputDecoration().copyWith(
                                  labelText: "نشانی کامل",
                                  prefixIcon: const Icon(Icons.pin_drop_rounded),
                                ),
                                onSaved: (value) => guild = guild.copyWith(address: value),
                                minLines: 4,
                                maxLines: 4,
                              )
                            : labelWidget(Icons.pin_drop_outlined, "نشانی کامل", addressController.text),
                        if (isEditable || pinLocation != null)
                          GestureDetector(
                            onTap: () => showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                contentPadding: EdgeInsets.zero,
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
                                content: MapWidget(
                                  key: UniqueKey(),
                                  defaultPinLocation: pinLocation,
                                  onChangePinLocation: (location) {
                                    pinLocation = location;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
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
                                          "موقعیت صنف را روی نقشه پیدا کنید",
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration defaultInputDecoration() {
    return const InputDecoration().copyWith(
      helperText: '',
      helperMaxLines: 1,
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(width: 1.2, color: isEditable ? const Color(0xd9848484) : Colors.transparent),
      ),
    );
  }

  Widget labelWidget(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Icon(icon, color: Colors.grey),
              ),
              const SizedBox(width: 8.0),
              Text(
                "$label:",
                style: defaultTextStyle(context, headline: 4).c(Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 0.0),
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: Text(
              value.isEmpty ? "هنوز وارد نکردید" : value,
              style: defaultTextStyle(context, headline: 3).c(value.isNotEmpty ? Colors.black : Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
