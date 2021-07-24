import 'package:flutter/material.dart';
import 'package:study_buddy/models/accessory.dart';
import 'package:study_buddy/screens/loading.dart';
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
                  AccessoryTile(accessory: "01"),
                  AccessoryTile(accessory: "02"),
                  AccessoryTile(accessory: "03"),
                  AccessoryTile(accessory: "04"),
                ],
              ),
            )
          ],
        ));
  }
}

class AccessoryTile extends StatefulWidget {
  String accessory;
  AccessoryTile({required this.accessory});

  @override
  _AccessoryTileState createState() =>
      _AccessoryTileState(name: this.accessory);
}

class _AccessoryTileState extends State<AccessoryTile> {
  String name;
  _AccessoryTileState({required this.name});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Accessory>(
      stream: DatabaseService().accessories(name),
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
        Accessory accessory = Accessory(
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
                              await DatabaseService().buyAccessory(accessory);
                              String currAccessory =
                              await DatabaseService().currAccessory();
                              if (currAccessory != "00") {
                                await DatabaseService()
                                    .removeAccessory(currAccessory);
                              }
                              await DatabaseService().applyAccessory(accessory);
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
                            String currAccessory =
                                await DatabaseService().currAccessory();
                            if (currAccessory != "00") {
                              await DatabaseService()
                                  .removeAccessory(currAccessory);
                            }
                            await DatabaseService().applyAccessory(accessory);
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
                            await DatabaseService().removeAccessory(accessory.num);
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
