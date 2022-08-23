import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    List<Hello> g = [
      Hello(text: "text", number: 1),
      Hello(text: "text2", number: 2),
      Hello(text: "text3", number: 3),
      Hello(text: "text4", number: 4),
    ];
    print("================================  main  ${g} ");

    List<Hello> gPlus = [
      Hello(text: "text11", number: 1),
      Hello(text: "text7", number: 7),
      Hello(text: "text33", number: 3),
      Hello(text: "text8", number: 8),
    ];
    g=[...gPlus,...g];
    print("\n\n\n");
    print("================================  main  ${g} ");
    print("\n\n\n");
    g=g.toSet().toList();
    print("================================  main  ${g} ");
  });
}

class Hello extends Equatable {
  final String text;
  final int number;

  const Hello({
    required this.text,
    required this.number,
  });

  @override
  String toString() {
    return 'Hello{text: $text, number: $number}';
  }

  @override
  List<Object> get props => [number];
}
