import 'package:flutter/material.dart';
import 'package:guilt_flutter/commons/text_style.dart';

class NumberPicker extends StatefulWidget {
  final int defaultValue;
  final int minValue;
  final int maxValue;
  final Widget? minButton;
  final Widget? maxButton;
  final Widget Function(int number)? numberText;
  final bool Function(int value)? validator;
  final void Function(int value) onChanged;

  const NumberPicker({
    required this.defaultValue,
    required this.onChanged,
    this.validator,
    required this.minValue,
    required this.maxValue,
    this.minButton,
    this.maxButton,
    this.numberText,
    Key? key,
  }) : super(key: key);

  @override
  _NumberPickerState createState() => _NumberPickerState();
}

class _NumberPickerState extends State<NumberPicker> {
  int currentValue = 0;

  @override
  void initState() {
    currentValue = widget.defaultValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Opacity(
          opacity: currentValue < widget.maxValue ? 1.0 : 0.4,
          child: AbsorbPointer(
            absorbing: currentValue >= widget.maxValue,
            child: GestureDetector(
              onTap: () {
                if (widget.validator == null || widget.validator!(currentValue)) {
                  currentValue++;
                  widget.onChanged(currentValue);
                  setState(() {});
                }
              },
              child: widget.maxButton ??
                  Container(
                    width: 27,
                    height: 27,
                    decoration:
                        const BoxDecoration(color: Colors.green, shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.circular(3))),
                    child: const Center(child: Icon(Icons.add, color: Colors.white, size: 19.0)),
                  ),
            ),
          ),
        ),
        const SizedBox(width: 5.0),
        SizedBox(width: 70, child: Center(child: Text(currentValue.toString(), style: defaultTextStyle(context).s(20)))),
        const SizedBox(width: 5.0),
        Opacity(
          opacity: currentValue > widget.minValue ? 1.0 : 0.4,
          child: AbsorbPointer(
            absorbing: currentValue <= widget.minValue,
            child: GestureDetector(
              onTap: () {
                if (widget.validator == null || widget.validator!(currentValue)) {
                  currentValue--;
                  widget.onChanged(currentValue);
                  setState(() {});
                }
              },
              child: widget.minButton ??
                  Container(
                    width: 27,
                    height: 27,
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.circular(3))),
                    child: const Center(child: Icon(Icons.remove, color: Colors.white, size: 19.0)),
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
