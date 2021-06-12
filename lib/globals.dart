library study_buddy.globals;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// var coins = FirebaseFirestore.instance.collection("user")
//     .doc(FirebaseAuth.instance.currentUser!.uid)
//     .get()
//     .then((DocumentSnapshot snapshot) {
//       if (snapshot.exists) {
//         int result = snapshot.get("coins");
//         return result;
//       } else {
//         return 888;
//       }
//     });

var coins = 0;
double timeSliderValue = 10;
var taskName = '';
