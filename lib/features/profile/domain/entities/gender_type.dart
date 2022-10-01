enum Gender {
  boy("آقا", 1),
  girl("خانم", 0);

  final String persianName;
  final int code;

  const Gender(this.persianName, this.code);
}
