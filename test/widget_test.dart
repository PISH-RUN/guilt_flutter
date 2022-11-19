import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final homeTelephone = "02187637";
    print("telephone  ${homeTelephone.length > 8 ? homeTelephone.substring(homeTelephone.length - 8, homeTelephone.length) : homeTelephone} ");
    print("code  ${homeTelephone.length > 8 ? homeTelephone.substring(0, homeTelephone.length - 8) : ""} ");
  });
}
