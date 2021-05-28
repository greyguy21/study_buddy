import 'package:flutter/material.dart';
import 'package:study_buddy/screens/items_page.dart';

// buttons: on press : only display bought / not bought
// how to update bought or not bought
// implement stack

// understand how to use media query
// tabview
// listview
// gridview
// pageview
// inkwell
// hero
// nested scroll view
// silver

// questions how to scroll more??

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
          onPressed: () {},
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
              color: Colors.white60,
              height: MediaQuery.of(context).size.height/2.2,
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
                        ItemsPage(),
                        ItemsPage(),
                        ItemsPage(),
                        ItemsPage(),
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
