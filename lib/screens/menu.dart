import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx < 0) {
          Navigator.pop(context);
        }
      },
      child: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue.shade200,
              ),
              child: Text('Menu'),
            ),
            ListTile(
              leading: Icon(Icons.home_outlined),
              title: Text('Homepage'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/");
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart_outlined),
              title: Text('Store/Inventory'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/store");
              },
            ),
            ListTile(
              leading: Icon(Icons.auto_graph),
              title: Text('Statistics'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/statistics");
              },
            ),
            ListTile(
              leading: Icon(Icons.timeline),
              title: Text('Timeline'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/timeline');
              },
            ),
            ListTile(
              leading: Icon(Icons.label_important_outline_rounded),
              title: Text("Tags"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/tags");
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: ListTile(
                tileColor: Colors.grey.shade100,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Back'),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward),
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
