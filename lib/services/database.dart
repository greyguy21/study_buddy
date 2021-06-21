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
        .doc(uid)
        .set({"coins": 0, "pet": "", "wallpaper": "1"}).then((value) {
      FirebaseFirestore.instance
          .collection("user")
          .doc(uid)
          .collection("clothes")
          .add({
        "name": "nothing",
        "num": "00",
      });
      DatabaseService().addClothes();
      FirebaseFirestore.instance.collection("user")
          .doc(uid)
          .collection("wallpapers")
          .add({
        "name": "nothing",
        "num": "00",
      });
      FirebaseFirestore.instance
          .collection("user")
          .doc(uid)
          .collection("accessories")
          .add({
        "name": "nothing",
        "num": "00",
      });
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
        accessoryInUse: snapshot.get("accessoryInUse"));
  }

  Stream<AppUser> get users {
    return _db
        .collection("user")
        .doc(this.uid)
        .snapshots()
        .map(_userFromFirestore);
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

  Stream<Clothes> clothes(String name){
    // query snapshots
    return _db.collection("user").doc(this.uid).collection("clothes")
        .doc(name).snapshots().map(_clothesFromFirestore);
  }

  Future addClothes() {
    return _db.collection("user").doc(this.uid).update({})
        .then((value) {
          _db.collection("user").doc(this.uid).collection("clothes").doc("Bee")
              .set({
                "name": "Bee",
                "price": 10,
                "imgPath": "assets/store/beeClothes.png",
                "num": "01",
                "bought": false,
                "inUse": false,
              });
          _db.collection("user").doc(this.uid).collection("clothes").doc("Overall")
              .set({
            "name": "Overall",
            "price": 10,
            "imgPath": "assets/store/overallClothes.png",
            "num": "02",
            "bought": false,
            "inUse": false,
          });
          _db.collection("user").doc(this.uid).collection("clothes").doc("Egg")
              .set({
            "name": "Egg",
            "price": 10,
            "imgPath": "assets/store/eggClothes.png",
            "num": "03",
            "bought": false,
            "inUse": false,
          });
          _db.collection("user").doc(this.uid).collection("clothes").doc("Bandanna")
              .set({
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
      docRef
          .collection("clothes")
          .doc(clothing.name)
          .update({
        "bought": true,
        "inUse": false,
      });
    });
  }

  Future applyClothes(Clothes clothing) {
    return _db
        .collection("user")
        .doc(this.uid)
        .update({"clothesInUse": clothing.num}).then((value) {
      _db
          .collection("user")
          .doc(this.uid)
          .collection("clothes")
          .doc(clothing.name)
          .update({"inUse": true});
    });
  }

  Future removeClothes(Clothes clothing) {
    return _db
        .collection("user")
        .doc(this.uid)
        .update({"clothesInUse": "00"}).then((value) {
      _db
          .collection("user")
          .doc(this.uid)
          .collection("clothes")
          .doc(clothing.name)
          .update({"inUse": false});
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
      docRef.collection("wallpapers").doc(wallpaper.name).set({
        "name": wallpaper.name,
        "price": wallpaper.price,
        "imgPath": wallpaper.imgPath,
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
      docRef.collection("accessories").doc(accessory.name).set({
        "name": accessory.name,
        "price": accessory.price,
        "imgPath": accessory.imgPath,
      });
    });
  }

  Future updateTimeline(String name, int time) async {
    DocumentReference docRef = _db.collection("user").doc(this.uid);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        throw Exception("user does not exist!");
      }
      int newCoinValue = snapshot.get("coins") + time;
      transaction.update(docRef, {"coins": newCoinValue});
    }).then((value) {
      docRef.collection("tasks").doc(name).set({
        "name": name,
        "time": time,
      });
    });
  }

  Stream<QuerySnapshot> get timeline {
    return _db.collection("user").doc(this.uid).collection("tasks").snapshots();
  }
}
