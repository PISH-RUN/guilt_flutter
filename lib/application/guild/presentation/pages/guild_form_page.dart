import 'package:flutter/material.dart';
import 'package:guilt_flutter/application/guild/presentation/widgets/map_widget.dart';
import 'package:guilt_flutter/commons/fix_rtl_flutter_bug.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:guilt_flutter/commons/utils.dart';
import 'package:guilt_flutter/commons/widgets/our_item_picker.dart';
import 'package:latlong2/latlong.dart' as latLng;

class GuildFormPage extends StatefulWidget {
  const GuildFormPage({Key? key}) : super(key: key);

  @override
  _GuildFormPageState createState() => _GuildFormPageState();
}

class _GuildFormPageState extends State<GuildFormPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController province = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nationalCodeController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey();

  latLng.LatLng? pinLocation;

  bool isEditable = false;

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
    );
  }

  Widget avatarWidget(BuildContext context) {
    return GestureDetector(
      onTap: () async {},
      child: AbsorbPointer(
        child: SizedBox(
          height: 140,
          width: 140,
          child: Stack(
            children: [
              const Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 130,
                  width: 130,
                  child: Image(image: AssetImage('images/avatar.png')),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: CircleAvatar(
                  radius: 23,
                  backgroundColor: Colors.grey.withOpacity(0.3),
                  child: const Icon(Icons.camera_alt_rounded, color: Colors.black, size: 25.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double paddingBetweenTextFiled = 0.0;

  Widget baseInformationWidget(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 650),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20.0),
              Row(
                children: [
                  const SizedBox(width: 56.0),
                  const Spacer(),
                  Text("اطلاعات صنف", style: defaultTextStyle(context, headline: 3)),
                  const Spacer(),
                  isEditable
                      ? const SizedBox(width: 56.0)
                      : GestureDetector(
                          onTap: () => setState(() => isEditable = true),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Icon(Icons.edit, color: Colors.blueGrey, size: 15.0),
                              const SizedBox(width: 4.0),
                              Text("ویرایش", style: defaultTextStyle(context, headline: 5).c(Colors.blueGrey)),
                            ],
                          ),
                        ),
                ],
              ),
              const SizedBox(height: 20.0),
              AbsorbPointer(
                absorbing: !isEditable,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
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
                    ),
                    SizedBox(height: paddingBetweenTextFiled),
                    TextFormField(
                      style: defaultTextStyle(context),
                      controller: lastNameController,
                      keyboardType: TextInputType.name,
                      onTap: () => setState(() => fixRtlFlutterBug(lastNameController)),
                      decoration: defaultInputDecoration().copyWith(labelText: "نام خانوادگی", prefixIcon: const Icon(Icons.person_outline)),
                      validator: (value) {
                        if (value == null) return null;
                        if (value.isEmpty) return "این فیلد الزامی است";
                        if (value.length < 2) return "نام خانوادگی کوتاه است";
                        return null;
                      },
                    ),
                    SizedBox(height: paddingBetweenTextFiled),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: TextFormField(
                        style: defaultTextStyle(context),
                        decoration: defaultInputDecoration().copyWith(
                          labelText: "شماره تلفن",
                          suffixIcon: const Icon(Icons.phone),
                        ),
                        keyboardType: TextInputType.number,
                        controller: phoneController,
                        validator: (value) {
                          if (value == null) return null;
                          if (value.isEmpty) return "وارد کردن شماره تلفن ضروری است";
                          if (!validatePhoneNumber(value)) return "شماره تلفن معتبر نیست";
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: paddingBetweenTextFiled),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: TextFormField(
                        style: defaultTextStyle(context),
                        decoration: defaultInputDecoration().copyWith(
                          labelText: "کد ملی",
                          suffixIcon: const Icon(Icons.map),
                        ),
                        keyboardType: TextInputType.number,
                        controller: nationalCodeController,
                        validator: (value) {
                          if (value == null) return null;
                          if (value.isEmpty) return "وارد کردن کد ملی ضروری است";
                          if (value.length != 10) return "کد ملی باید ده رقم باشد";
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: paddingBetweenTextFiled),
                    OurItemPicker(
                      hint: "شماره isic",
                      icon: Icons.pin,
                      items: null,
                      onFillParams: () async => (await getListOfIsic(context)).map((e) => e.name).toList(),
                      onChanged: (value) async {
                        final isic = (await getListOfIsic(context)).firstWhere((element) => element.name == value);
                      },
                      currentText: province.text,
                      controller: province,
                    ),
                    SizedBox(height: paddingBetweenTextFiled),
                    OurItemPicker(
                      hint: "استان محل سکونت",
                      icon: Icons.pin_drop_outlined,
                      items: null,
                      onFillParams: () => getIranProvince(context),
                      onChanged: (value) {},
                      currentText: province.text,
                      controller: province,
                    ),
                    SizedBox(height: paddingBetweenTextFiled),
                    OurItemPicker(
                      key: UniqueKey(),
                      hint: "شهر محل سکونت",
                      icon: Icons.pin_drop_outlined,
                      items: null,
                      onChanged: (value) async {},
                      onFillParams: () => getCitiesOfOneProvince(context, province.text.trim()),
                      currentText: city.text,
                      controller: city,
                    ),
                    SizedBox(height: paddingBetweenTextFiled),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: TextFormField(
                        decoration: defaultInputDecoration().copyWith(labelText: "کد پستی", suffixIcon: const Icon(Icons.map)),
                        keyboardType: TextInputType.number,
                        controller: postalCodeController,
                        validator: (value) {
                          if (value == null) return null;
                          if (value.isEmpty) return "وارد کردن کد پستی ضروری است";
                          if (value.length != 10) return "کد پستی باید ده رقم باشد";
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: paddingBetweenTextFiled),
                    // OurItemPicker(
                    //   hint: "آخرین مدرک تحصیلی",
                    //   icon: Icons.document_scanner_outlined,
                    //   items: const ['حالت اول', 'حالت دوم', 'حالت سوم', 'حالت چهارم'],
                    //   onChanged: (value) {},
                    //   currentText: degree.text,
                    //   controller: degree,
                    // ),
                    // SizedBox(height: paddingBetweenTextFiled),
                    TextFormField(
                      style: defaultTextStyle(context),
                      controller: addressController,
                      keyboardType: TextInputType.streetAddress,
                      onTap: () => setState(() => fixRtlFlutterBug(addressController)),
                      decoration: defaultInputDecoration().copyWith(
                        labelText: "نشانی کامل",
                        prefixIcon: const Icon(Icons.pin_drop_rounded),
                      ),
                      minLines: 4,
                      maxLines: 4,
                    ),
                    if (isEditable || pinLocation != null)
                      GestureDetector(
                        onTap: () => showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            contentPadding: EdgeInsets.zero,
                            backgroundColor: Colors.transparent,
                            content: Scaffold(
                              backgroundColor: Colors.transparent,
                              body: MapWidget(
                                key: UniqueKey(),
                                defaultPinLocation: pinLocation ?? latLng.LatLng(35.700869, 51.391141),
                                onChangePinLocation: (location) {
                                  pinLocation = location;
                                  setState(() {});
                                },
                              ),
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
    );
  }

  InputDecoration defaultInputDecoration() {
    return const InputDecoration().copyWith(
      helperText: '',
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(width: 1.2, color: isEditable ? const Color(0xd9848484) : Colors.transparent),
      ),
    );
  }
}
