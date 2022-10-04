enum GuildPspStep {
  normal(id: 1, actionName: "پیگیری میکنم", stateTitle: "پیگیری نشده", isGuildEditable: false, isEnd: false),
  follow_up(id: 2, actionName: "در موقعیت هستم", stateTitle: "اقدام برای پیگیری", isGuildEditable: false, isEnd: false),
  in_location(id: 3, actionName: "ویرایش", stateTitle: "در حال بررسی", isGuildEditable: true, isEnd: true),
  done(id: 4, actionName: "تایید نهایی", stateTitle: "تایید شده", isGuildEditable: false, isEnd: true);

  final String stateTitle;
  final String actionName;
  final bool isGuildEditable;
  final bool isEnd;
  final int id;

  const GuildPspStep({required this.id, required this.isEnd, required this.stateTitle, required this.isGuildEditable, required this.actionName});
}
