import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final homeTelephone = [3, 4, 7, 6, 1, 5, 4];
    print("========widget_test  main  ${homeTelephone.any((element) => element > 8)} ");
  });
}
