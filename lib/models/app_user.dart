import 'package:study_buddy/globals.dart' as global;

class AppUser {
  final uid;
  int coins;
  String pet;
  String clothesInUse;
  String accessoryInUse;
  String wallpaper;

  AppUser(
      {required this.coins,
      this.uid,
      required this.pet,
      required this.clothesInUse,
      required this.accessoryInUse,
      required this.wallpaper});
}
