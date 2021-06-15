import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:study_buddy/models/accessory.dart';
import 'package:study_buddy/models/app_user.dart';
import 'package:study_buddy/models/clothes.dart';
import 'package:study_buddy/models/furniture.dart';
import 'package:study_buddy/models/wallpaper.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  Future newUser() async {
    return await _db
        .collection("user")
        .doc(uid).set(
        {
          "coins": 0,
          "pet": ""
        }
    ).then((value) {
      FirebaseFirestore.instance.collection("user")
          .doc(uid)
          .collection("clothes")
          .add({
        "name": "nothing",
      });
      FirebaseFirestore.instance.collection("user")
          .doc(uid)
          .collection("furniture")
          .add({
        "name": "nothing",
      });
      FirebaseFirestore.instance.collection("user")
          .doc(uid)
          .collection("wallpapers")
          .add({
        "name": "nothing",
      });
      FirebaseFirestore.instance.collection("user")
          .doc(uid)
          .collection("accessories")
          .add({
        "name": "nothing",
      });
      FirebaseFirestore.instance.collection("user")
          .doc(uid)
          .collection("tasks")
          .add({
        "name": "nothing",
      });
    });
  }

  AppUser _userFromFirestore(DocumentSnapshot snapshot) {
    return AppUser(coins: snapshot.get("coins"), uid: this.uid);
  }

  Stream<AppUser> get users {
    return _db.collection("user").doc(this.uid).snapshots().map(_userFromFirestore);
  }

  Future buyClothes(Clothes clothing) async {
    DocumentReference docRef = _db.collection("user").doc(this.uid);

    FirebaseFirestore.instance.runTransaction((transaction) async{
      DocumentSnapshot snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        throw Exception("user does not exist!");
      }
      int newCoinValue = snapshot.get("coins") - clothing.price;
      transaction.update(docRef, {"coins" : newCoinValue});
    }).then((value) {
      docRef
          .collection("clothes")
          .doc(clothing.name)
          .set({
        "name": clothing.name,
        "price": clothing.price,
        "imgPath": clothing.imgPath,
      });
    });
  }

  Future applyClothes(Clothes clothing) {
    return _db.collection("user").doc(this.uid)
        .update({"clothsInUse" : clothing})
        .then((value) {
          _db.collection("user")
              .doc(this.uid)
              .collection("clothes")
              .doc(clothing.name)
              .update({"inUse" : true});
        });
  }

  Future buyFurniture(Furniture furniture) async {
    DocumentReference docRef = _db.collection("user").doc(this.uid);

    FirebaseFirestore.instance.runTransaction((transaction) async{
      DocumentSnapshot snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        throw Exception("user does not exist!");
      }
      int newCoinValue = snapshot.get("coins") - furniture.price;
      transaction.update(docRef, {"coins" : newCoinValue});
    }).then((value) {
      docRef
          .collection("furniture")
          .doc(furniture.name)
          .set({
        "name": furniture.name,
        "price": furniture.price,
        "imgPath": furniture.imgPath,
      });
    });
  }

  Future buyWallpaper(Wallpaper wallpaper) async {
    DocumentReference docRef = _db.collection("user").doc(this.uid);

    FirebaseFirestore.instance.runTransaction((transaction) async{
      DocumentSnapshot snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        throw Exception("user does not exist!");
      }
      int newCoinValue = snapshot.get("coins") - wallpaper.price;
      transaction.update(docRef, {"coins" : newCoinValue});
    }).then((value) {
      docRef
          .collection("wallpapers")
          .doc(wallpaper.name)
          .set({
        "name": wallpaper.name,
        "price": wallpaper.price,
        "imgPath": wallpaper.imgPath,
      });
    });
  }

  Future buyAccessory(Accessory accessory) async {
    DocumentReference docRef = _db.collection("user").doc(this.uid);

    FirebaseFirestore.instance.runTransaction((transaction) async{
      DocumentSnapshot snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        throw Exception("user does not exist!");
      }
      int newCoinValue = snapshot.get("coins") - accessory.price;
      transaction.update(docRef, {"coins" : newCoinValue});
    }).then((value) {
      docRef
          .collection("accessories")
          .doc(accessory.name)
          .set({
        "name": accessory.name,
        "price": accessory.price,
        "imgPath": accessory.imgPath,
      });
    });
  }

  Future updateTimeline(String name, int time) async {
    DocumentReference docRef = _db.collection("user").doc(this.uid);

    FirebaseFirestore.instance.runTransaction((transaction) async{
      DocumentSnapshot snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        throw Exception("user does not exist!");
      }
      int newCoinValue = snapshot.get("coins") + time;
      transaction.update(docRef, {"coins" : newCoinValue});
    }).then((value) {
      docRef
          .collection("tasks")
          .doc(name)
          .set({
        "name": name,
        "time": time,
      });
    });
  }
}