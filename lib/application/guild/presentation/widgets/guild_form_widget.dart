import 'package:flutter/material.dart';
import 'package:guilt_flutter/application/guild/domain/entities/guild.dart';
import 'package:guilt_flutter/application/guild/presentation/pages/guild_form_page.dart';
import 'package:guilt_flutter/application/guild/presentation/widgets/map_widget.dart';
import 'package:guilt_flutter/commons/TextFieldConfig.dart';
import 'package:guilt_flutter/commons/fix_rtl_flutter_bug.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/utils.dart';
import 'package:guilt_flutter/commons/widgets/our_item_picker.dart';
import 'package:guilt_flutter/commons/widgets/our_text_field.dart';
import 'package:guilt_flutter/commons/widgets/text_form_field_wrapper.dart';
import 'package:latlong2/latlong.dart' as lat_lng;

class FormController {
  Guild? Function()? onSubmitButton;

  set onSubmit(Guild? Function() onSubmit) => onSubmitButton = onSubmit;
}

class GuildFormWidget extends StatefulWidget {
  final Guild defaultGuild;
  final FormController formController;

  const GuildFormWidget({required this.defaultGuild, required this.formController, Key? key}) : super(key: key);

  @override
  State<GuildFormWidget> createState() => _GuildFormWidgetState();
}

class _GuildFormWidgetState extends State<GuildFormWidget> {
  final GlobalKey<FormState> formKey = GlobalKey();
  late Guild guild;

  late TextEditingController addressController;
  late TextEditingController provinceController;
  late TextEditingController isicController;
  late String isic;
  late TextEditingController cityController;
  late TextEditingController postalCodeController;
  late TextEditingController homeTelephoneController;
  late TextEditingController provinceCodeController;
  late TextEditingController organController;
  late TextEditingController guildNameController;
  late lat_lng.LatLng? pinLocation;

  double paddingBetweenTextFiled = 10.0;

  @override
  void initState() {
    widget.formController.onSubmitButton = () => onSubmit();
    guild = widget.defaultGuild;
    initController();
    super.initState();
  }

  void initController() {
    organController = TextEditingController(text: guild.organName);
    guildNameController = TextEditingController(text: guild.title);
    addressController = TextEditingController(text: guild.address);
    provinceController = TextEditingController(text: guild.province);
    isicController = TextEditingController(text: guild.isic.name);
    isic = guild.isic.name;
    cityController = TextEditingController(text: guild.city);
    postalCodeController = TextEditingController(text: guild.postalCode);
    final homeTelephone = guild.homeTelephone;
    homeTelephoneController = TextEditingController(
        text: homeTelephone.length > 8 ? homeTelephone.substring(homeTelephone.length - 8, homeTelephone.length) : homeTelephone);
    provinceCodeController = TextEditingController(text: homeTelephone.length > 8 ? homeTelephone.substring(0, homeTelephone.length - 8) : "");
    pinLocation = guild.location;
  }

  bool isLocationAlarmActive = false;

  Guild? onSubmit() {
    setState(() => isLocationAlarmActive = false);
    if (!formKey.currentState!.validate()) {
      return null;
    }
    if (pinLocation == null) {
      setState(() => isLocationAlarmActive = true);
      return null;
    }
    formKey.currentState!.save();
    return guild;
  }

  @override
  Widget build(BuildContext context) {
    return baseInformationWidget(context);
  }

  Widget baseInformationWidget(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 650),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text("اطلاعات کسب و کار", style: defaultTextStyle(context, headline: 3)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          OurTextField(
                            title: "نام صنف",
                            textFormField: TextFormField(
                              inputFormatters: TextFieldConfig.inputFormattersGuildName(),
                              style: defaultTextStyle(context).c(const Color(0xff2F3135)),
                              controller: guildNameController,
                              keyboardType: TextInputType.name,
                              onTap: () => setState(() => fixRtlFlutterBug(guildNameController)),
                              decoration: defaultInputDecoration(context).copyWith(
                                hintText: 'مثال: فروشندگان مواد پروتئینی',
                                prefixIcon: const Icon(Icons.store, color: Color(0xffA0A8B1), size: 25.0),
                              ),
                              validator: (value) => TextFieldConfig.validateGuildName(value),
                              onSaved: (value) => guild = guild.copyWith(title: value),
                            ),
                          ),
                          SizedBox(height: paddingBetweenTextFiled),
                          OurTextField(
                            title: "نام سازمان",
                            textFormField: TextFormField(
                              inputFormatters: TextFieldConfig.inputFormattersOrganName(),
                              style: defaultTextStyle(context).c(const Color(0xff2F3135)),
                              controller: organController,
                              keyboardType: TextInputType.name,
                              onTap: () => setState(() => fixRtlFlutterBug(organController)),
                              decoration: defaultInputDecoration(context).copyWith(
                                hintText: 'مثال:سازمان،معدن و تجارت زنجان',
                                prefixIcon: const Icon(Icons.store, color: Color(0xffA0A8B1), size: 25.0),
                              ),
                              validator: (value) => TextFieldConfig.validateOrganName(value),
                              onSaved: (value) => guild = guild.copyWith(organName: value),
                            ),
                          ),
                          SizedBox(height: paddingBetweenTextFiled),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: OurTextField(
                                  title: "شماره تلفن",
                                  textFormField: TextFormField(
                                    inputFormatters: TextFieldConfig.inputFormattersHomeTelephone(),
                                    style: defaultTextStyle(context).c(const Color(0xff2F3135)),
                                    controller: homeTelephoneController,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.end,
                                    decoration: defaultInputDecoration(context).copyWith(
                                      hintText: 'شماره تلفن',
                                      hintTextDirection: TextDirection.ltr,
                                      contentPadding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0, bottom: 20.0),
                                      prefixIcon: const Icon(Icons.phone, color: Color(0xffA0A8B1), size: 25.0),
                                    ),
                                    validator: (value) {
                                      if (value == null) return null;
                                      if (value.isEmpty) return "وارد کردن شماره تلفن ضروری است";
                                      if (provinceCodeController.text.isEmpty) return "وارد کردن کد ضروری است";
                                      if (!provinceCodeController.text.startsWith('0')) return "کد با صفر شروع میشود";
                                      if (provinceCodeController.text.length != 3) return "کد معتبر نمی باشد";
                                      if (value.length != 8) return "شماره تلفن معتبر نمی باشد";
                                      return null;
                                    },
                                    onSaved: (value) => guild = guild.copyWith(homeTelephone: "${provinceCodeController.text}$value"),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                flex: 1,
                                child: OurTextField(
                                  title: "کد استان",
                                  textFormField: TextFormField(
                                    inputFormatters: TextFieldConfig.inputFormattersProvinceCode(),
                                    style: defaultTextStyle(context).c(const Color(0xff2F3135)),
                                    controller: provinceCodeController,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.end,
                                    decoration: defaultInputDecoration(context).copyWith(
                                      hintText: 'کد استان',
                                      hintTextDirection: TextDirection.ltr,
                                      contentPadding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0, bottom: 20.0),
                                    ),
                                    validator: (value) {
                                      if (value == null) return null;
                                      if (value.isEmpty) return "";
                                      if (!value.startsWith('0')) return "";
                                      if (value.length != 3) return "";
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: paddingBetweenTextFiled),
                          OurItemPicker(
                            hint: "رسته صنفی",
                            icon: Icons.store,
                            items: getListOfIsic().map((e) => e.name).toList(),
                            onChanged: (value) {
                              final isic = getIsicWithName(value);
                              guild = guild.copyWith(isic: isic);
                            },
                            currentText: isicController.text,
                            controller: isicController,
                          ),
                          SizedBox(height: paddingBetweenTextFiled),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: OurItemPicker(
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
                                ),
                              ),
                              SizedBox(width: paddingBetweenTextFiled),
                              Expanded(
                                child: OurItemPicker(
                                  hint: "شهرستان",
                                  headlineSize: 6,
                                  icon: Icons.pin_drop_outlined,
                                  items: null,
                                  onFillParams: () => getCitiesOfOneProvince(context, provinceController.text.trim()),
                                  onChanged: (value) async {
                                    final province = await getProvinceOfOneCity(context, value);
                                    provinceController.text = province;
                                    guild = guild.copyWith(city: value, province: province);
                                  },
                                  currentText: cityController.text,
                                  controller: cityController,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: paddingBetweenTextFiled),
                          OurTextField(
                            title: "کد پستی",
                            textFormField: TextFormField(
                              inputFormatters: TextFieldConfig.inputFormattersNationalCode(),
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
                              validator: (value) => TextFieldConfig.validateNationalCode(value),
                              onSaved: (value) => guild = guild.copyWith(postalCode: value),
                            ),
                          ),
                          SizedBox(height: paddingBetweenTextFiled),
                          OurTextField(
                            title: "نشانی کامل",
                            textFormField: TextFormField(
                              inputFormatters: TextFieldConfig.inputFormattersEmpty(),
                              style: defaultTextStyle(context).c(const Color(0xff2F3135)),
                              controller: addressController,
                              keyboardType: TextInputType.streetAddress,
                              onTap: () => setState(() => fixRtlFlutterBug(addressController)),
                              decoration: defaultInputDecoration(context).copyWith(
                                hintText: "نشانی کامل",
                                contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                                prefixIcon: const Icon(Icons.pin_drop_outlined, color: Color(0xffA0A8B1), size: 25.0),
                              ),
                              validator: (value) => TextFieldConfig.validateAddress(value),
                              onSaved: (value) => guild = guild.copyWith(address: value),
                              minLines: 4,
                              maxLines: 4,
                            ),
                          ),
                          SizedBox(height: paddingBetweenTextFiled),
                          GestureDetector(
                            onTap: () async {
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
                                  color: isLocationAlarmActive ? Colors.red.withOpacity(0.6) : Colors.blueGrey.withOpacity(0.4),
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
        ),
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
