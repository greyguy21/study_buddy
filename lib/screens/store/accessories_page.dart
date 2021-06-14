import 'package:flutter/material.dart';
import 'package:study_buddy/models/accessory.dart';
import 'package:study_buddy/services/database.dart';

class AccessoriesPage extends StatefulWidget {
  @override
  _AccessoriesPageState createState() => _AccessoriesPageState();
}

class _AccessoriesPageState extends State<AccessoriesPage> {
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
                  _buildAccessory("accessory1", 10, "assets/kotaro1.jpg", context),
                  _buildAccessory("accessory2", 10, "assets/kotaro2.jpg", context),
                  _buildAccessory("accessory3", 10, "assets/kotaro3.jpg", context),
                  _buildAccessory("accessory4", 10, "assets/kotaro4.jpg", context),
                  _buildAccessory("accessory5", 10, "assets/kotaro5.jpg", context),
                  _buildAccessory("accessory6", 10, "assets/kotaro6.jpg", context),
                  _buildAccessory("accessory7", 10, "assets/kotaro7.jpg", context),
                  _buildAccessory("accessory8", 10, "assets/kotaro8.jpg", context),
                ],
              ),
            )
          ],
        )
    );
  }

  Widget _buildAccessory(String name, int price, String imgPath, context) {
    Accessory accessory = Accessory(name: name, price: price, imgPath: imgPath);
    // AppUser appUser = Provider.of<AppUser>(context);
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
                    onPressed: () async {
                      // check if coins > price first!!
                      // else return error message

                      // then need to change to use or remove!
                      // change buttons, new tiles, or gesture detectors
                      setState(() {
                        accessory.bought = true;
                      });
                      await DatabaseService().buyAccessory(accessory);
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
