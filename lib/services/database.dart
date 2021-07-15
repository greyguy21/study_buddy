// import 'package:charts_flutter/flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_buddy/models/accessory.dart';
import 'package:study_buddy/models/app_user.dart';
import 'package:study_buddy/models/clothes.dart';
import 'package:study_buddy/models/furniture.dart';
import 'package:study_buddy/models/tag_model.dart';
import 'package:study_buddy/models/wallpaper.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  Future newUser() async {
    return await _db.collection("user").doc(uid).set({
      "coins": 0,
      "pet": "",
      "wallpaper": "1",
      "numOfTags": "1",
    }).then((value) {
      DatabaseService().addClothes();
      DatabaseService().addWallpapers();
      DatabaseService().addAccessories();
      DatabaseService().addTag("Unset", Colors.grey.value);
      // _db.collection("user").doc(this.uid).collection("tasks").doc("pls").set({
      //   "name":"nothing",
      // _db.collection("user").doc(this.uid)
      //     .collection("sessions")
      //     .doc("welcome")
      //     .set({
      //   "name": "welcome",
      //   "duration": 0,
      //   "date": "8/7",
      //   "start": "",
      //   "end": "",
      //   "tagName": "",
      //   "color": "",
      // });
      // });
    });
  }

  Future updatePet(String pet) {
    return _db.collection("user").doc(this.uid).update({
      "pet": pet,
      "clothesInUse": "00",
      "accessoryInUse": "00",
    });
  }

  AppUser _userFromFirestore(DocumentSnapshot snapshot) {
    return AppUser(
        coins: snapshot.get("coins"),
        uid: this.uid,
        pet: snapshot.get("pet"),
        wallpaper: snapshot.get("wallpaper"),
        clothesInUse: snapshot.get("clothesInUse"),
        accessoryInUse: snapshot.get("accessoryInUse"),
        numOfTags: snapshot.get("numOfTags"));
  }

  Stream<AppUser> get users {
    return _db
        .collection("user")
        .doc(this.uid)
        .snapshots()
        .map(_userFromFirestore);
  }

  Future coins() {
    return _db.collection("user").doc(this.uid).get().then((value) {
      return value.get("coins");
    });
  }

  Future numOfTags() {
    return _db.collection("user").doc(this.uid).get().then((value) {
      return value.get("numOfTags");
    });
  }

  Future currClothes() async {
    return _db.collection("user").doc(this.uid).get().then((value) {
      return value.get("clothesInUse");
    });
  }

  Future currAccessory() async {
    return _db.collection("user").doc(this.uid).get().then((value) {
      return value.get("accessoryInUse");
    });
  }

  Clothes _clothesFromFirestore(DocumentSnapshot snapshot) {
    return Clothes(
        name: snapshot.get("name"),
        price: snapshot.get("price"),
        imgPath: snapshot.get("imgPath"),
        num: snapshot.get("num"),
        bought: snapshot.get("bought"),
        inUse: snapshot.get("inUse"));
  }

  Stream<Clothes> clothes(String name) {
    // query snapshots
    return _db
        .collection("user")
        .doc(this.uid)
        .collection("clothes")
        .doc(name)
        .snapshots()
        .map(_clothesFromFirestore);
  }

  Future addClothes() {
    return _db.collection("user").doc(this.uid).update({}).then((value) {
      _db.collection("user").doc(this.uid).collection("clothes").doc("01").set({
        "name": "Bee",
        "price": 10,
        "imgPath": "assets/store/beeClothes.png",
        "num": "01",
        "bought": false,
        "inUse": false,
      });
      _db.collection("user").doc(this.uid).collection("clothes").doc("02").set({
        "name": "Overall",
        "price": 10,
        "imgPath": "assets/store/overallClothes.png",
        "num": "02",
        "bought": false,
        "inUse": false,
      });
      _db.collection("user").doc(this.uid).collection("clothes").doc("03").set({
        "name": "Egg",
        "price": 10,
        "imgPath": "assets/store/eggClothes.png",
        "num": "03",
        "bought": false,
        "inUse": false,
      });
      _db.collection("user").doc(this.uid).collection("clothes").doc("04").set({
        "name": "Bandanna",
        "price": 10,
        "imgPath": "assets/store/bandannaClothes.png",
        "num": "04",
        "bought": false,
        "inUse": false,
      });
    });
  }

  Future buyClothes(Clothes clothing) async {
    DocumentReference docRef = _db.collection("user").doc(this.uid);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        throw Exception("user does not exist!");
      }
      int newCoinValue = snapshot.get("coins") - clothing.price;
      transaction.update(docRef, {"coins": newCoinValue});
    }).then((value) {
      docRef.collection("clothes").doc(clothing.num).update({
        "bought": true,
        "inUse": false,
      });
    });
  }

  Future applyClothes(Clothes clothing) async {
    return _db
        .collection("user")
        .doc(this.uid)
        .update({"clothesInUse": clothing.num}).then((value) {
      _db
          .collection("user")
          .doc(this.uid)
          .collection("clothes")
          .doc(clothing.num)
          .update({"inUse": true});
    });
  }

  Future removeClothes(String clothing) {
    return _db
        .collection("user")
        .doc(this.uid)
        .update({"clothesInUse": "00"}).then((value) {
      _db
          .collection("user")
          .doc(this.uid)
          .collection("clothes")
          .doc(clothing)
          .update({"inUse": false});
    });
  }

  Wallpaper _wallpapersFromFirestore(DocumentSnapshot snapshot) {
    return Wallpaper(
        name: snapshot.get("name"),
        price: snapshot.get("price"),
        imgPath: snapshot.get("imgPath"),
        num: snapshot.get("num"),
        bought: snapshot.get("bought"),
        inUse: snapshot.get("inUse"));
  }

  Stream<Wallpaper> wallpapers(String name) {
    return _db
        .collection("user")
        .doc(this.uid)
        .collection("wallpapers")
        .doc(name)
        .snapshots()
        .map(_wallpapersFromFirestore);
  }

  Future addWallpapers() {
    return _db.collection("user").doc(this.uid).update({}).then((value) {
      _db
          .collection("user")
          .doc(this.uid)
          .collection("wallpapers")
          .doc("1")
          .set({
        "name": "Default",
        "price": 10,
        "imgPath": "assets/wallpaper/1.png",
        "num": "1",
        "bought": true,
        "inUse": true,
      });
      _db
          .collection("user")
          .doc(this.uid)
          .collection("wallpapers")
          .doc("2")
          .set({
        "name": "Window",
        "price": 10,
        "imgPath": "assets/wallpaper/2.png",
        "num": "2",
        "bought": false,
        "inUse": false,
      });
      _db
          .collection("user")
          .doc(this.uid)
          .collection("wallpapers")
          .doc("3")
          .set({
        "name": "Garden",
        "price": 10,
        "imgPath": "assets/wallpaper/3.png",
        "num": "3",
        "bought": false,
        "inUse": false,
      });
      _db
          .collection("user")
          .doc(this.uid)
          .collection("wallpapers")
          .doc("4")
          .set({
        "name": "Living Room",
        "price": 10,
        "imgPath": "assets/wallpaper/4.png",
        "num": "4",
        "bought": false,
        "inUse": false,
      });
    });
  }

  Future buyWallpaper(Wallpaper wallpaper) async {
    DocumentReference docRef = _db.collection("user").doc(this.uid);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        throw Exception("user does not exist!");
      }
      int newCoinValue = snapshot.get("coins") - wallpaper.price;
      transaction.update(docRef, {"coins": newCoinValue});
    }).then((value) {
      docRef.collection("wallpapers").doc(wallpaper.num).update({
        "name": wallpaper.name,
        "price": wallpaper.price,
        "imgPath": wallpaper.imgPath,
        "bought": true,
      });
    });
  }

  Future applyWallpaper(Wallpaper wallpaper) async {
    // update inUse of prev wallpaper to false
    String currWallpaper =
        await _db.collection("user").doc(this.uid).get().then((value) {
      return value.get("wallpaper");
    });

    return _db
        .collection("user")
        .doc(this.uid)
        .update({"wallpaper": wallpaper.num}).then((value) {
      _db
          .collection("user")
          .doc(this.uid)
          .collection("wallpapers")
          .doc(currWallpaper)
          .update({"inUse": false});
      _db
          .collection("user")
          .doc(this.uid)
          .collection("wallpapers")
          .doc(wallpaper.num)
          .update({"inUse": true});
    });
  }

  Accessory _accessoryFromFirestore(DocumentSnapshot snapshot) {
    return Accessory(
        name: snapshot.get("name"),
        price: snapshot.get("price"),
        imgPath: snapshot.get("imgPath"),
        num: snapshot.get("num"),
        bought: snapshot.get("bought"),
        inUse: snapshot.get("inUse"));
  }

  Stream<Accessory> accessories(String name) {
    return _db
        .collection("user")
        .doc(this.uid)
        .collection("accessories")
        .doc(name)
        .snapshots()
        .map(_accessoryFromFirestore);
  }

  Future addAccessories() {
    return _db.collection("user").doc(this.uid).update({}).then((value) {
      _db
          .collection("user")
          .doc(this.uid)
          .collection("accessories")
          .doc("01")
          .set({
        "name": "Bee",
        "price": 10,
        "imgPath": "assets/store/beeAccessory.png",
        "num": "01",
        "bought": false,
        "inUse": false,
      });
      _db
          .collection("user")
          .doc(this.uid)
          .collection("accessories")
          .doc("02")
          .set({
        "name": "Beret",
        "price": 10,
        "imgPath": "assets/store/beretAccessory.png",
        "num": "02",
        "bought": false,
        "inUse": false,
      });
      _db
          .collection("user")
          .doc(this.uid)
          .collection("accessories")
          .doc("03")
          .set({
        "name": "Bread",
        "price": 10,
        "imgPath": "assets/store/breadAccessory.png",
        "num": "03",
        "bought": false,
        "inUse": false,
      });
      _db
          .collection("user")
          .doc(this.uid)
          .collection("accessories")
          .doc("04")
          .set({
        "name": "Party Hat",
        "price": 10,
        "imgPath": "assets/store/partyhatAccessory.png",
        "num": "04",
        "bought": false,
        "inUse": false,
      });
    });
  }

  Future buyAccessory(Accessory accessory) async {
    DocumentReference docRef = _db.collection("user").doc(this.uid);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        throw Exception("user does not exist!");
      }
      int newCoinValue = snapshot.get("coins") - accessory.price;
      transaction.update(docRef, {"coins": newCoinValue});
    }).then((value) {
      docRef.collection("accessories").doc(accessory.num).update({
        "name": accessory.name,
        "price": accessory.price,
        "imgPath": accessory.imgPath,
        "bought": true,
      });
    });
  }

  Future applyAccessory(Accessory accessory) {
    return _db.collection("user").doc(this.uid).update({
      "accessoryInUse": accessory.num,
      "accessory": accessory.name
    }).then((value) {
      _db
          .collection("user")
          .doc(this.uid)
          .collection("accessories")
          .doc(accessory.num)
          .update({"inUse": true});
    });
  }

  Future removeAccessory(String accessory) {
    return _db
        .collection("user")
        .doc(this.uid)
        .update({"accessoryInUse": "00"}).then((value) {
      _db
          .collection("user")
          .doc(this.uid)
          .collection("accessories")
          .doc(accessory)
          .update({"inUse": false});
    });
  }

  Future addCoins(int coins) async {
    DocumentReference docRef = _db.collection("user").doc(this.uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        throw Exception("user does not exist!");
      }
      int newCoinValue = snapshot.get("coins") + coins;
      transaction.update(docRef, {"coins": newCoinValue});
    });
  }

  Future updateNumOfTags(int x) async {
    DocumentReference docRef = _db.collection("user").doc(this.uid);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        throw Exception("user does not exist!");
      }
      int newTagNum = snapshot.get("numOfTags") + x;
      transaction.update(docRef, {"coins": newTagNum});
    });
  }

  Future addNewTask(String name, int duration, String date, String start,
      String end, String tag, int color, int day, int month) {
    return _db.collection("user").doc(this.uid).update({}).then((value) {
      _db
          .collection("user")
          .doc(this.uid)
          .collection("sessions")
          .doc(name)
          .set({
        "name": name,
        "duration": duration,
        "date": date,
        "day": day,
        "month": month,
        "start": start,
        "end": end,
        "tag": tag,
        "color": color,
        "extension": false,
      });
    });
  }

  Future updateTask(String name, String tag, int color) {
    return _db.collection("user").doc(this.uid).update({}).then((value) {
      _db
          .collection("user")
          .doc(this.uid)
          .collection("sessions")
          .doc(name)
          .update({
        "tag": tag,
        "color": color,
      });
    });
  }

  Future updateExtension(String name, int extended, String end) {
    return _db.collection("user").doc(this.uid).update({}).then((value) {
      _db
          .collection("user")
          .doc(this.uid)
          .collection("sessions")
          .doc(name)
          .update({
        "extended": extended,
        "end": end,
        "extension": true,
      });
    });
  }

  Stream<QuerySnapshot> get timeline {
    return _db
        .collection("user")
        .doc(this.uid)
        .collection("sessions")
        .orderBy("month", descending: true)
        .orderBy("day", descending: true)
        .orderBy("start", descending: true)
        .snapshots();
  }

  Future addTag(String title, int color) {
    return _db.collection("user").doc(this.uid).update({}).then((value) {
      _db.collection("user").doc(this.uid).collection("tags").doc(title).set({
        "title": title,
        "color": color,
      });
    });
  }

  Future removeTag(String old, String newTitle, int color) {
    return _db.collection("user").doc(this.uid).update({}).then((value) {
      _db.collection("user").doc(this.uid).collection("tags").doc(old).delete();
      _db
          .collection("user")
          .doc(this.uid)
          .collection("sessions")
          .where("tag", isEqualTo: old)
          .snapshots()
          .forEach((snapshot) async {
        List<DocumentSnapshot> docs = snapshot.docs;
        for (var doc in docs) {
          await doc.reference.update({
            "tag": newTitle,
            "color": color,
          });
        }
      });
    });
  }

  List<TagModel> _tagsFromFirestore(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return TagModel(
        doc.get("title"),
        doc.get("color"),
      );
    }).toList();
  }

  Stream<List<TagModel>> get tags {
    return _db
        .collection("user")
        .doc(this.uid)
        .collection("tags")
        .snapshots()
        .map(_tagsFromFirestore);
  }
}
