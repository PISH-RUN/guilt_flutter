import 'package:flutter_test/flutter_test.dart';
import 'package:guilt_flutter/commons/utils.dart';
import 'package:persian_utils/persian_utils.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final nationalCode = '5610009227';
    print("".isNumber());
    print("hello".isNumber());
    print("123434324".isNumber());
    print("12343h324".isNumber());
    print("12343م324".isNumber());

  });
}


