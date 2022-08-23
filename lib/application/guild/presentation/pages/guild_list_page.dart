import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guilt_flutter/application/colors.dart';
import 'package:guilt_flutter/commons/text_style.dart';
import 'package:qlevar_router/qlevar_router.dart';

class GuildListPage extends StatefulWidget {
  GuildListPage({Key? key}) : super(key: key);

  @override
  _GuildListPageState createState() => _GuildListPageState();

  final List<String> guildNames = [
    "خرده فروشی مرغ ، ماهی و تخم مرغ",
    "خرده فروشی ابزارآلات ساختمانی",
    "خرده فروشی کود،سم و داروهای شیمیایی برای محصولات کشاورزی",
    "تراشکاری وفلزکاری",
  ];
}

class _GuildListPageState extends State<GuildListPage> {
  List<String> guildNames = [];

  @override
  void initState() {
    guildNames = widget.guildNames;
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
                children: guildNames
                    .map(
                      (guildName) => Card(
                        elevation: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
                        child: ListTile(
                          title: AutoSizeText(guildName, style: defaultTextStyle(context, headline: 3), maxLines: 1, minFontSize: 2),
                          subtitle: Text("شهرکرد", style: defaultTextStyle(context, headline: 5).c(Colors.grey)),
                          onTap: () => QR.to('guild/1'),
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
    guildNames = widget.guildNames.where((element) => element.contains(controller.text)).toList();
    setState(() {});
  }
}
