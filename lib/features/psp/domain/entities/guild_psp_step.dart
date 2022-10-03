enum GuildPspStep {
  normal(actionName: "پیگیری میکنم", stateTitle: "پیگیری نشده"),
  follow_up(actionName: "در موقعیت هستم", stateTitle: "اقدام برای پیگیری"),
  in_location(actionName: "ویرایش", stateTitle: "در حال بررسی"),
  done(actionName: "تایید نهایی", stateTitle: "تایید شده");

  final String stateTitle;
  final String actionName;

  const GuildPspStep({required this.stateTitle, required this.actionName});
}
