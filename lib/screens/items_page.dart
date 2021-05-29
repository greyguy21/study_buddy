import 'package:flutter/material.dart';

// how to make this generic ?? or just make individual classes 
// how to add more items - is it manually add?
// update items - bought/not bought - each item need to be a class??
class ItemsPage extends StatefulWidget {
  @override
  _ItemsPageState createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white30,
        body: ListView(
          children: <Widget>[
            SizedBox(
              height: 15.0,
            ),
            Container(
                padding: EdgeInsets.only(left:15.0, right: 15.0),
                width: MediaQuery.of(context).size.width - 30.0,
                height: 220.0,
                color: Colors.white30,
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 15.0,
                  childAspectRatio: 0.8,
                  children: [
                    _buildItem("kotaro1", "\$0.00", "assets/kotaro1.jpg", false, context),
                    _buildItem("kotaro1", "\$0.00", "assets/kotaro2.jpg", false, context),
                    _buildItem("kotaro1", "\$0.00", "assets/kotaro3.jpg", false, context),
                    _buildItem("kotaro1", "\$0.00", "assets/kotaro4.jpg", false, context),
                    _buildItem("kotaro1", "\$0.00", "assets/kotaro5.jpg", false, context),
                    _buildItem("kotaro1", "\$0.00", "assets/kotaro6.jpg", false, context),
                    _buildItem("kotaro1", "\$0.00", "assets/kotaro7.jpg", false, context),
                    _buildItem("kotaro1", "\$0.00", "assets/kotaro8.jpg", false, context),
                  ],
                )
            ),
            SizedBox(
              height: 15.0,
            )
          ],
        )
    );
  }
}


Widget _buildItem(String name, String price, String imgPath, bool bought, context) {
  return Padding(
    padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
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
              )
            )
          )
        ],
      ),
    )
  );
}
