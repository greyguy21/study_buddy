import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_buddy/models/app_user.dart';
import 'package:study_buddy/models/clothes.dart';
import 'package:study_buddy/screens/loading.dart';
import 'package:study_buddy/services/database.dart';

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
                  ClothesTile(
                    clothing: "01",
                  ),
                  ClothesTile(clothing: "02"),
                  ClothesTile(clothing: "03"),
                  ClothesTile(
                    clothing: "04",
                  )
                ],
              ),
            )
          ],
        ));
    //   },
    // );
  }

  // should be clothes function?
  // just the build function ?
  // Widget _buildClothes(String name, int price, String imgPath, String num, context) {
  //   Clothes clothing = Clothes(name: name, price: price, imgPath: imgPath, num: num, bought: false, inUse: false);
  //   return ClothesTile(clothing: clothing);
}

// ignore: must_be_immutable
class ClothesTile extends StatefulWidget {
  String clothing;
  ClothesTile({required this.clothing});

  @override
  _ClothesTileState createState() => _ClothesTileState(this.clothing);
}

class _ClothesTileState extends State<ClothesTile> {
  late String name;

  _ClothesTileState(String name) {
    this.name = name;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Clothes>(
      stream: DatabaseService().clothes(name),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        }

        bool bought = snapshot.data!.bought;
        bool inUse = snapshot.data!.inUse;
        String name = snapshot.data!.name;
        int price = snapshot.data!.price;
        String imgPath = snapshot.data!.imgPath;
        String num = snapshot.data!.num;
        Clothes clothing = Clothes(
            name: name,
            price: price,
            imgPath: imgPath,
            num: num,
            bought: bought,
            inUse: inUse);

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
                        )),
                      ),
                    ),
                    SizedBox(
                      height: 7.0,
                    ),
                    Center(
                      child: Text("${price}",
                          style: TextStyle(
                            color: Colors.black,
                          )),
                    ),
                    Text(name,
                        style: TextStyle(
                          color: Colors.black,
                        )),
                    SizedBox(
                      height: 7.0,
                    ),
                    Visibility(
                      visible: !bought,
                      child: Expanded(
                        child: FloatingActionButton.extended(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          heroTag: name,
                          onPressed: () async {
                            // check if coins > price first!!
                            // else return error message

                            // then need to change to use or remove!
                            // change buttons, new tiles, or gesture detectors
                            int coins = await DatabaseService().coins();
                            if (coins < price) {
                              // pop up for not enough coins
                              setState(() {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _errorPopup(context));
                              });
                            } else {
                              await DatabaseService().buyClothes(clothing);
                              String currClothes =
                              await DatabaseService().currClothes();
                              if (currClothes != "00") {
                                await DatabaseService()
                                    .removeClothes(currClothes);
                              }
                              await DatabaseService().applyClothes(clothing);
                            } // how to disable button!
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
                      ),
                    ),
                    Visibility(
                      visible: !inUse && bought,
                      child: Expanded(
                        child: FloatingActionButton.extended(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          heroTag: name,
                          onPressed: () async {
                            // check if coins > price first!!
                            // else return error message

                            // then need to change to use or remove!
                            // change buttons, new tiles, or gesture detectors

                            // must remove then can apply!
                            String currClothes =
                                await DatabaseService().currClothes();
                            if (currClothes != "00") {
                              await DatabaseService()
                                  .removeClothes(currClothes);
                            }
                            await DatabaseService().applyClothes(clothing);
                            // how to disable button!
                          },
                          icon: Icon(
                            Icons.check_circle_outline_rounded,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Apply",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: Colors.lightBlue,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: inUse && bought,
                      child: Expanded(
                        child: FloatingActionButton.extended(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          heroTag: name,
                          onPressed: () async {
                            // check if coins > price first!!
                            // else return error message

                            // then need to change to use or remove!
                            // change buttons, new tiles, or gesture detectors
                            await DatabaseService().removeClothes(clothing.num);
                            // how to disable button!
                          },
                          icon: Icon(
                            Icons.cancel_outlined,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Remove",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: Colors.lightBlue,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 3.0,
                    )
                  ],
                )));
      },
    );
  }
}

Widget _errorPopup(BuildContext context) {
  return AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Not enough coins!"),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('ok'),
        ),
      ],
    ),
  );
}
