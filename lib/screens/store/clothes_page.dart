import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ClothesPage extends StatefulWidget {
  @override
  _ClothesPageState createState() => _ClothesPageState();
}

class _ClothesPageState extends State<ClothesPage> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
            backgroundColor: Colors.white30,
            body: ListView(
              children: [
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  width: MediaQuery.of(context).size.width - 30.0,
                  height: 220.0,
                  color: Colors.white30,
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 15.0,
                    childAspectRatio: 0.8,
                    children: [
                      _buildClothes("Kotaro1", 10, "assets/kotaro1.jpg", context),
                      _buildClothes("Kotaro2", 10, "assets/kotaro2.jpg", context),
                      _buildClothes("Kotaro3", 10, "assets/kotaro3.jpg", context),
                      _buildClothes("Kotaro4", 10, "assets/kotaro4.jpg", context),
                      _buildClothes("Kotaro5", 10, "assets/kotaro5.jpg", context),
                      _buildClothes("Kotaro6", 10, "assets/kotaro6.jpg", context),
                      _buildClothes("Kotaro7", 10, "assets/kotaro7.jpg", context),
                      _buildClothes("Kotaro8", 10, "assets/kotaro8.jpg", context),
                    ],
                  ),
                )
              ],
            )
        );
    //   },
    // );
  }

  // should be clothes function?
  // just the build function ?
  Widget _buildClothes(String name, int price, String imgPath, context) {
    return Padding(
        padding: EdgeInsets.all(5.0),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3.0,
                  blurRadius: 5.0,
                )
              ],
              color: Colors.white,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 7.0,
                ),
                Hero(
                  tag: imgPath,
                  child: Container(
                    height: 100.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(imgPath),
                          fit: BoxFit.fill,
                        )
                    ),
                  ),
                ),
                SizedBox(
                  height: 7.0,
                ),
                Center(
                  child: Text(
                      "${price}",
                      style: TextStyle(
                        color: Colors.black,
                      )
                  ),
                ),
                Text(
                    name,
                    style: TextStyle(
                      color: Colors.black,
                    )
                ),
                SizedBox(
                  height: 7.0,
                ),
                Expanded(
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      // check if coins > price first!!
                      // else return error message

                      DocumentReference docRef = FirebaseFirestore.instance.collection("user")
                          .doc(FirebaseAuth.instance.currentUser!.uid);

                      FirebaseFirestore.instance.runTransaction((transaction) async{
                        DocumentSnapshot snapshot = await transaction.get(docRef);

                        if (!snapshot.exists) {
                          throw Exception("user does not exist!");
                        }

                        int newCoinValue = snapshot.get("coins") - price;
                        transaction.update(docRef, {"coins" : newCoinValue});
                      })
                          .then((value) {
                            docRef
                            .collection("clothes")
                            .doc(name)
                            .set({
                              "name": name,
                              "price": price,
                              "imgPath": imgPath,
                            });
                          });
                      // then need to change to use or remove!
                      // change buttons, new tiles, or gesture detectors
                      },
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Buy",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.lightBlue,
                  ),
                )
              ],
            )
        )
    );
  }
}

