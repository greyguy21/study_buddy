import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_buddy/models/app_user.dart';
import 'package:study_buddy/models/clothes.dart';
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
                      _buildClothes("clothes1", 10, "assets/kotaro1.jpg", context),
                      _buildClothes("clothes2", 10, "assets/kotaro2.jpg", context),
                      _buildClothes("clothes3", 10, "assets/kotaro3.jpg", context),
                      _buildClothes("clothes4", 10, "assets/kotaro4.jpg", context),
                      _buildClothes("clothes5", 10, "assets/kotaro5.jpg", context),
                      _buildClothes("clothes6", 10, "assets/kotaro6.jpg", context),
                      _buildClothes("clothes7", 10, "assets/kotaro7.jpg", context),
                      _buildClothes("clothes8", 10, "assets/kotaro8.jpg", context),
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
    Clothes clothing = Clothes(name: name, price: price, imgPath: imgPath);
    // AppUser appUser = Provider.of<AppUser>(context);
    return ClothesTile(clothing: clothing);
  }
}


// ignore: must_be_immutable
class ClothesTile extends StatefulWidget {
  Clothes clothing;
  ClothesTile({required this.clothing});

  @override
  _ClothesTileState createState() => _ClothesTileState(this.clothing);
}

class _ClothesTileState extends State<ClothesTile> {
  late Clothes clothing;

  _ClothesTileState(Clothes clothing) {
    this.clothing = clothing;
  }

  var _buyButton;
  var _applyButton;

  @override
  void initState() {
    _buyButton = true;
    _applyButton = false;
    super.initState();
  }

  void buy() {
    setState(() {
      _buyButton = false;
      _applyButton = true;
    });
  }

  void apply() {
    setState(() {
      _applyButton = !_applyButton;
    });
  }
  @override
  Widget build(BuildContext context) {
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
                  tag: clothing.imgPath,
                  child: Container(
                    height: 100.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(clothing.imgPath),
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
                      "${clothing.price}",
                      style: TextStyle(
                        color: Colors.black,
                      )
                  ),
                ),
                Text(
                    clothing.name,
                    style: TextStyle(
                      color: Colors.black,
                    )
                ),
                SizedBox(
                  height: 7.0,
                ),
                Visibility(
                  visible: _buyButton,
                  child: Expanded(
                    child: FloatingActionButton.extended(
                      onPressed: () async {
                        // check if coins > price first!!
                        // else return error message

                        // then need to change to use or remove!
                        // change buttons, new tiles, or gesture detectors
                        setState(() {
                          clothing.bought = true;
                        });
                        buy();
                        await DatabaseService().buyClothes(clothing);

                        // how to disable button!
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
                  visible: _applyButton,
                  child: Expanded(
                    child: FloatingActionButton.extended(
                      onPressed: () async {
                        // check if coins > price first!!
                        // else return error message

                        // then need to change to use or remove!
                        // change buttons, new tiles, or gesture detectors
                        setState(() {
                          clothing.inUse = true;
                        });
                        apply();
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
                  visible: !_applyButton && !_buyButton,
                  child: Expanded(
                    child: FloatingActionButton.extended(
                      onPressed: () async {
                        // check if coins > price first!!
                        // else return error message

                        // then need to change to use or remove!
                        // change buttons, new tiles, or gesture detectors
                        setState(() {
                          clothing.inUse = false;
                        });
                        apply();
                        await DatabaseService().removeClothes(clothing);
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
                )
              ],
            )
        )
    );
  }
}
