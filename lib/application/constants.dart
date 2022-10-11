// ignore_for_file: constant_identifier_names

const int ONE_TIME_PASSWORD_LENGTH = 5;
const BASE_URL = 'https://test-af-data.pish.run';
const String BASE_URL_API = '$BASE_URL/api/v1/';
const String apiMapKey =
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjA0ZjBmODBlOTlhMjM1OWE5ZDgxMDgyNWE1YTIzYWNhZDM3YTFlZDg3ZTlhYjY4ZjAxN2ExYzg5OTZiZjdjMmNlNGI0ZjM5ZTllODdjNGQ5In0.eyJhdWQiOiIxOTE4OSIsImp0aSI6IjA0ZjBmODBlOTlhMjM1OWE5ZDgxMDgyNWE1YTIzYWNhZDM3YTFlZDg3ZTlhYjY4ZjAxN2ExYzg5OTZiZjdjMmNlNGI0ZjM5ZTllODdjNGQ5IiwiaWF0IjoxNjYxMTQyNDI0LCJuYmYiOjE2NjExNDI0MjQsImV4cCI6MTY2MzgyNDQyNCwic3ViIjoiIiwic2NvcGVzIjpbImJhc2ljIl19.nkd_nJzJljulSUZdl4t1VeSGl9-JhUeQqpllAp94sDRmBFidvBtCoypyaKmphBgdYe7B3B48WhzaFkTT4KCrqxxLlPaLtBRFIDVu24bXSkFKY-CkYaPVdtFW7Ik1yOCsj4h7sl6Q8shMwudIT1LAfjiB0fAt7EtSYq3cjtk7SMMFXSdNzp95Q4wZ4gyYzum9REMTOgxUKnL9CD8BkZqT0Ck8rai_FYnWbEbHxBmcukF3w-ZOsKB09GNHJshvQjF1X4YQAaE0oIYt0YjSqAZcVa-mnncqWq0Mc9D5_MH7ksoVy1xsWQr-5NxQMobZmDIAIOefgx1Xt4ut1Yxuvlo-UQ';

enum LocalKeys { userId, userPhone, token }

enum AppMode {
  psp('psp/guildList', "شما باید از نرم افزار مخصوص کاربران استفاده کنید"),
  normal('guild/dashboard', "شما باید از نرم افزار مخصوص psp استفاده کنید");

  final String initPath;
  final String forbiddenError;

  const AppMode(this.initPath, this.forbiddenError);
}

const appMode = AppMode.normal;

const List<String> monthNames = ["فروردین", "اردیبهشت", "خرداد", "تیر", "مرداد", "شهریور", "مهر", "آبان", "آذر", "دی", "بهمن", "اسفند"];
