import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:study_buddy/models/tag_model.dart';
import 'package:study_buddy/screens/loading.dart';
import 'package:study_buddy/services/database.dart';


class TagsPage extends StatefulWidget {
  const TagsPage({Key? key}) : super(key: key);

  @override
  _TagsPageState createState() => _TagsPageState();
}

class _TagsPageState extends State<TagsPage> {
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
              Navigator.pushNamed(context, "/");
            },
          ),
          title: Text(
              "Tags",
              style: TextStyle(
                color: Colors.white,
              )),
        ),
        body: StreamBuilder<List<TagModel>>(
            stream: DatabaseService().tags,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return _errorPopup(context);
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Loading();
              } else {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 1.2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15.0,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 5.0,
                                ),
                                Icon(
                                  Icons.circle,
                                  color: snapshot.data![index].color,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  snapshot.data![index].title,
                                  textScaleFactor: 1.2,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 15.0,
                            )
                          ],
                        ),
                      );
                    }
                );
              }
            }
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // allow users to add tags
            setState(() {
              showDialog(
                context: context,
                builder: (BuildContext context) => _tagPopup(context),
              );
            });
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Colors.lightBlue,
          heroTag: "add tag",
        ),
    );
  }

  Widget _tagPopup(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    Color color = Colors.blue;
    String title = "";

    return SafeArea(
      child: new AlertDialog(
        title: const Text("Add Tag"),
        content: new Column(
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                validator: (val) => val!.isEmpty
                    ? "Enter a valid Tag title"
                    : null,
                onChanged: (val) {
                  setState(() {
                    title = val;
                  });
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ColorPicker(
              pickerAreaHeightPercent: 0.8,
              pickerColor: color,
              onColorChanged: (changed) {
                setState(() {
                  color = changed;
                });
              },
              paletteType: PaletteType.hsv,
            ),
          ]
        ),
        actions: [
          Center(
            child: FloatingActionButton.extended(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await DatabaseService().addTag(title, color.value);
                  Navigator.pop(context);
                }
              },
              label: Text("Add Tag"),
              heroTag: title,
            ),
          )
        ],
      ),
    );
  }
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


// stream of tags in database
// user has a list of tags -> collection?
// tag doc is name and color
// streambuilder --> need a tag stream!

// Tag Collection
// -> build the tags in database (retrieve data)
// -> add new tag (update data)
// -> remove tag (update data)

// User field
// need to get current user
// -> onPressed -> tag chosen -> update

// Tasks
// need to get current task -> another global variable??
// need to add

// figure out how to add & choose color palette