import 'package:flutter/material.dart';
import 'package:guilt_flutter/commons/text_style.dart';

class StatePicker extends StatefulWidget {
  final String? defaultValue;
  final List<String> values;
  final void Function(int value) onChanged;

  const StatePicker({required this.defaultValue, required this.values, required this.onChanged, Key? key}) : super(key: key);

  @override
  _StatePickerState createState() => _StatePickerState();
}

class _StatePickerState extends State<StatePicker> {
  String currentValue = "";

  @override
  void initState() {
    currentValue = widget.defaultValue ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            int currentIndex = currentValue == null ? -1 : widget.values.indexOf(currentValue);
            currentValue = widget.values[(currentIndex + 1) % widget.values.length];
            widget.onChanged((currentIndex + 1) % widget.values.length);
            setState(() {});
          },
          child: Container(
            width: 27,
            height: 27,
            decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.circular(3))),
            child: const Center(
              child: Icon(Icons.arrow_back_ios_outlined, color: Colors.white, size: 14.0),
            ),
          ),
        ),
        const SizedBox(width: 5.0),
        SizedBox(
            width: 70,
            child: Center(
                child: Text(
              currentValue == null ? "انتخاب کنید" : currentValue,
              style: defaultTextStyle(context).s(currentValue == null ? 8 : 16),
            ))),
        const SizedBox(width: 5.0),
        GestureDetector(
          onTap: () {
            int currentIndex = currentValue == null ? widget.values.length : widget.values.indexOf(currentValue);
            currentValue = widget.values[(currentIndex - 1) % widget.values.length];
            widget.onChanged((currentIndex - 1) % widget.values.length);
            setState(() {});
          },
          child: Container(
            width: 27,
            height: 27,
            decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.circular(3))),
            child: const Center(
              child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14.0),
            ),
          ),
        ),
      ],
    );
  }
}
