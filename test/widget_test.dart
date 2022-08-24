import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final json = {
      "Azerbaijan sharghi": {"Lat": 38.052468, "Lng": 46.284993},
      "Azerbaijan gharbi": {"Lat": 37.529607, "Lng": 45.046549},
      "Ardabil": {"Lat": 38.246471, "Lng": 48.295052},
      "Isfahan": {"Lat": 32.65139, "Lng": 51.679192},
      "Alborz": {"Lat": 35.821433, "Lng": 50.962486},
      "Ilam": {"Lat": 33.638531, "Lng": 46.422649},
      "Bushehr": {"Lat": 28.922041, "Lng": 50.833092},
      "Tehran": {"Lat": 35.699731, "Lng": 51.33805},
      "Chaharmahal va Bakhtiari": {"Lat": 32.355594, "Lng": 50.827427},
      "South Khorasan": {"Lat": 32.846216, "Lng": 59.291142},
      "Razavi Khorasan": {"Lat": 36.287961, "Lng": 59.615753},
      "North Khorasan": {"Lat": 37.452438, "Lng": 57.323518},
      "Khuzestan": {"Lat": 31.531716, "Lng": 49.880328},
      "Zanjan": {"Lat": 36.67094, "Lng": 48.485111},
      "Semnan": {"Lat": 35.572269, "Lng": 53.396049},
      "Sistan va Baluchestan": {"Lat": 29.454579, "Lng": 60.853647},
      "Fars": {"Lat": 29.617247, "Lng": 52.543422},
      "Qazvin": {"Lat": 36.266819, "Lng": 50.003811},
      "Qom": {"Lat": 34.643711, "Lng": 50.89064},
      "Kurdistan": {"Lat": 35.302942, "Lng": 47.002631},
      "Kerman": {"Lat": 30.28027, "Lng": 57.06702},
      "Kermanshah": {"Lat": 34.346481, "Lng": 46.420559},
      "Kohgiluyeh and Boyer-Ahmad": {"Lat": 30.657075, "Lng": 51.600294},
      "Golestan": {"Lat": 36.863391, "Lng": 54.448578},
      "Gilan": {"Lat": 37.223431, "Lng": 49.635509},
      "Lorestan": {"Lat": 33.466667, "Lng": 48.35},
      "Mazandaran": {"Lat": 36.565833, "Lng": 53.059722},
      "Markazi": {"Lat": 34.080011, "Lng": 49.677233},
      "Hormozgan": {"Lat": 27.183333, "Lng": 56.266667},
      "Hamadan": {"Lat": 34.798439, "Lng": 48.514939},
      "Yazd": {"Lat": 31.893664, "Lng": 54.369836}
    };
    String g =
        'آذربایجان شرقی‌،آذربایجان غربی،اردبیل،اصفهان،البرز،ایلام،بوشهر،تهران،چهارمهال و بختیاری،ساوت خراسان،رضوی خراسان،نرته خراسان،خوزستان،زنجان،سمنان،سیستان و بلوچستن،فارس،قزوین،قًم،کردستان،کرمان،کرمانشاه،کهگیلویه و بویر‌احمد،گلستان،گیلان،لرستان،مازندران،مرکزی،هرمزگان،همدان،یزد';

    final newJson = {};
    print("================================widget_test  main  ${g.split('،').length} ");
    for (int i = 0; i < json.keys.length; i++) {
      newJson['\"${g.split('،')[i]}\"'] = '\"${json.values.toList()[i]}\"';
    }

    print("================================widget_test  main  ${newJson} ");
  });
}
