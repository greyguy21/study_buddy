import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  // different methods and properties used to interact with firestore database

  // collection reference
  // when code runs and collection doesnt exist
  // firestore will go ahead and create it
  final CollectionReference collectionReference = FirebaseFirestore.instance.collection("collection");

  final uid;
  DatabaseService({this.uid});
  // when they first sign up
  // update settings
  // update store inventory
  // update coins
  // update pets & pets home

  // get reference to document and update data
  // document with specific id
  Future updateUserData(String name) async {
    return await collectionReference.doc(uid).set({
      "name": name,
    });
  }

  // set up stream to listen to database
  Stream<QuerySnapshot> get collection {
    return collectionReference.snapshots();
  }

  // want to store data
  // num of coins, items owned, pet

  // new user -> create new record in collection for user
  // each user will have their own document

  // how to link firebase user to firestore document

  // firebase automatically creates a unique user id for new user
  // always remains the same
  // each firestore document can also have a new user id
  // we can specify what the id should be
  // take uid to create new firestore doc !
  // link them tgt - know which data belong to which user
}