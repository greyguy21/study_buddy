import 'package:flutter/material.dart';
import 'package:study_buddy/models/app_user.dart';
import 'package:study_buddy/screens/homepage.dart';
import 'package:study_buddy/screens/loading.dart';
import 'package:study_buddy/screens/store/accessories_page.dart';
import 'package:study_buddy/screens/store/clothes_page.dart';
import 'package:study_buddy/screens/store/items_page.dart';
import 'package:study_buddy/screens/store/wallpapers_page.dart';
import 'package:study_buddy/services/database.dart';

// buttons: on press : only display bought / not bought
// how to update bought or not bought ** need backend?
// implement stack : animals trying on clothes

// on press, show animal trying on clothes, & (buy?) button
// pop up card (item, buy or go back) - on bottom half of screen

// should this be stateful or stateless ??

// below app bar display cash
class StoreInventory extends StatefulWidget {
  @override
  _StoreInventoryState createState() => _StoreInventoryState();
}

class _StoreInventoryState extends State<StoreInventory>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Store/Inventory"),
        ),
        body: SafeArea(
            child: Column(
          children: <Widget>[
            StreamBuilder<AppUser>(
              stream: DatabaseService().users,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("something went wrong");
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Loading();
                }

                String clothes = snapshot.data!.clothesInUse;
                String accessory = snapshot.data!.accessoryInUse;
                String pet = snapshot.data!.pet;
                String imgPath = "assets/$pet/${pet + clothes + accessory}.png";
                String wallpaper = snapshot.data!.wallpaper;
                String aaa = "-square";

                return Container(
                  // where the animal and things should be!!
                  color: Colors.white60,
                  height: MediaQuery.of(context).size.height / 2.2,
                  child: Stack(
                    children: <Widget>[
                      // wallpaper
                      // shift the wallpaper so the floor is higher
                      Image(
                        image: AssetImage(
                            "assets/wallpaper/${wallpaper + aaa}.png"),
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                      // coin display
                      Positioned(
                        top: 10,
                        right: 30,
                        child: Row(
                          children: [
                            Icon(Icons.attach_money),
                            Text(
                              "${snapshot.data!.coins}",
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      // animal
                      Positioned(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Image.asset(imgPath),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
            PreferredSize(
                preferredSize: Size.fromHeight(50.0),
                child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    children: <Widget>[
                      SizedBox(
                        height: 15.0,
                      ),
                      TabBar(
                          controller: _tabController,
                          indicatorColor: Colors.transparent,
                          labelColor: Colors.lightBlue,
                          isScrollable: true,
                          labelPadding: EdgeInsets.only(right: 45.0),
                          unselectedLabelColor: Colors.blueGrey,
                          tabs: [
                            Tab(
                              child: Text("clothes"),
                            ),
                            Tab(
                              child: Text("accessories"),
                            ),
                            Tab(
                              child: Text("wallpaper"),
                            ),
                          ]),
                      Container(
                          height: 250.0,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child:
                              TabBarView(controller: _tabController, children: [
                            ClothesPage(),
                            AccessoriesPage(),
                            WallpaperPage(),
                          ])),
                    ]))
          ],
        )));
  }
}
