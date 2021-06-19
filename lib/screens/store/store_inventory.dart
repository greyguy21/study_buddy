import 'package:flutter/material.dart';
import 'package:study_buddy/screens/homepage.dart';
import 'package:study_buddy/screens/store/accessories_page.dart';
import 'package:study_buddy/screens/store/clothes_page.dart';
import 'package:study_buddy/screens/store/furniture_page.dart';
import 'package:study_buddy/screens/store/items_page.dart';
import 'package:study_buddy/screens/store/wallpapers_page.dart';

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
    with SingleTickerProviderStateMixin{

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.home,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, "/");
          },
        ),
        title: Text(
          "Store/Inventory",
          style: TextStyle(
            color: Colors.white,
          )
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              // where the animal and things should be!!
              color: Colors.white60,
              height: MediaQuery.of(context).size.height/2.2,
              child: Stack(
                children: <Widget>[
                  Image(
                    image: AssetImage("assets/defaultBg.jpeg"),
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.height,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Image(
                        image: AssetImage("assets/cat0101.png"),
                      ),
                    ),
                  )
                ],
              ),
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
                        child: Text("furniture"),
                      ),
                      Tab(
                        child: Text("wallpaper"),
                      ),
                      Tab(
                        child: Text("accessories"),
                      ),
                    ]
                  ),
                  Container(
                    height: 250.0,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: TabBarView(
                      controller: _tabController,
                      children:[
                        ClothesPage(),
                        FurniturePage(),
                        WallpaperPage(),
                        AccessoriesPage(),
                      ]
                    )
                  ), 
                ]
              )
            )
          ],
        )
      )
    );
  }
}
