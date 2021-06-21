import 'package:study_buddy/globals.dart' as global;
import 'package:study_buddy/models/clothes.dart';

class AppUser {
  final uid;
  int coins;
  String pet;
  String clothesInUse;
  String accessoryInUse;

  AppUser({required this.coins,this.uid, required this.pet, required this.clothesInUse, required this.accessoryInUse});
}