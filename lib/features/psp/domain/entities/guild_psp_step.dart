enum GuildPspStep {
  normal(actionName: "پیگیری میکنم", stateTitle: "پیگیری نشده"),
  waitingForService(actionName: "در موقعیت هستم", stateTitle: "در مسیر"),
  edit(actionName: "ویرایش", stateTitle: "در موقعیتم"),
  processing(actionName: "در حال بررسی", stateTitle: "در حال بررسی"),
  finished(actionName: "تایید نهایی", stateTitle: "تایید شده");

  final String stateTitle;
  final String actionName;

  const GuildPspStep({required this.stateTitle, required this.actionName});
}
