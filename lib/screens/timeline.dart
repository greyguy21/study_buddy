import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:study_buddy/models/tag_model.dart';
import 'package:study_buddy/screens/loading.dart';
import 'package:study_buddy/services/database.dart';
import 'package:timeline_tile/timeline_tile.dart';

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseService().timeline,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        }

        List<QueryDocumentSnapshot> docRef = [];
        snapshot.data!.docs.forEach((doc) {
          docRef.add(doc);
        });
        return Scaffold(
          appBar: AppBar(
            title: Text("Timeline"),
          ),
          body: new ListView.builder(
              itemCount: docRef.length,
              itemBuilder: (context, index) {
                return TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineXY: 0.1,
                  isFirst: index == 0,
                  isLast: index == docRef.length - 1,
                  indicatorStyle: IndicatorStyle(
                    color: Color(docRef[index].get("color")),
                  ),
                  beforeLineStyle:
                      LineStyle(color: Colors.black.withOpacity(0.2)),
                  endChild: GestureDetector(
                    onDoubleTap: () {
                      // allow name change & tag change
                      setState(() {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => _editTaskPopUp(context, docRef[index].get("name"),
                              docRef[index].get("tag"), docRef[index].get("color")),
                        );
                      });
                    },
                    child: Card(
                      color: Color(docRef[index].get("color")),
                      child: Column(
                        children: [
                          Text(
                            docRef[index].get("tag") + ": " + docRef[index].get("name"),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "Duration: " +
                                docRef[index].get("duration").toString(),
                          ),
                          Text(
                            "Date: " + docRef[index].get("date"),
                          ),
                          Text(
                            "Start: " + docRef[index].get("start"),
                          ),
                          Text(
                            "End: " + docRef[index].get("end"),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        );
      },
    );
  }

  Widget _editTaskPopUp(BuildContext context, String name, String prevTag, int prevColor) {
    String tag = prevTag;
    int color = prevColor;

    return new AlertDialog(
      title: const Text("Edit Task"),
      content: new Column(children: [
        SizedBox(
          height: 20,
        ),
        StreamBuilder<List<TagModel>>(
          stream: DatabaseService().tags,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return _errorPopup(context);
            } else if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return Loading();
            } else {
              final GlobalKey<TagsState> _tagKey =
              GlobalKey<TagsState>();

              return Padding(
                padding: const EdgeInsets.only(
                    top: 20.0,
                    left: 30,
                    right: 30,
                    bottom: 20),
                child: Tags(
                  key: _tagKey,
                  itemCount: snapshot.data!.length,
                  columns: 5,
                  itemBuilder: (index) {
                    return ItemTags(
                      index: index,
                      title: snapshot.data![index].title,
                      activeColor:
                      snapshot.data![index].color,
                      color: Colors.black87,
                      textActiveColor: Colors.white,
                      textColor: Colors.white,
                      singleItem: true,
                      onPressed: (value) {
                       tag = snapshot.data![index].title;
                       color = snapshot.data![index].color.value;
                      },
                    );
                  },
                ),
              );
            }
          },
        ),
      ],
        mainAxisSize: MainAxisSize.min,
      ),
      actions: [
        Center(
          child: FloatingActionButton.extended(
            onPressed: () async {
                if (tag != prevTag || color != prevColor) {
                  await DatabaseService().updateTask(name, tag, color);
                }
                Navigator.pop(context);
            },
            label: Text("Edit Task"),
            heroTag: name,
          ),
        )
      ],
    );
  }

  Widget _errorPopup(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              'An error has occurred in retrieving user data, please try again later.'),
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
}