class AppUser {
  final uid;
  int coins;
  String pet;
  String clothesInUse;
  String accessoryInUse;
  String wallpaper;
  int numOfTags;
  bool notification;

  AppUser(
      {required this.coins,
      this.uid,
      required this.pet,
      required this.clothesInUse,
      required this.accessoryInUse,
      required this.wallpaper,
      required this.numOfTags,
      required this.notification});
}
