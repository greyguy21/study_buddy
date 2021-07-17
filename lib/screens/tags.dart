// import 'dart:html';

import '../globals.dart' as globals;
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
  List<String> tags = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tags"),
      ),
      body: StreamBuilder<List<TagModel>>(
          stream: DatabaseService().tags,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return _errorPopup(context);
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Loading();
            } else {
              snapshot.data!.forEach((element) {
                tags.add(element.title);
              });

              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    // globals.numOfTags = snapshot.data!.length;
                    // print(globals.numOfTags);
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
                          ListTile(
                            leading: Icon(
                              Icons.circle,
                              color: snapshot.data![index].color,
                            ),
                            title: Text(
                              snapshot.data![index].title,
                              textScaleFactor: 1.2,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            trailing: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Visibility(
                                  visible:
                                      snapshot.data![index].title != "Unset",
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                _editTagPopUp(
                                                    context,
                                                    snapshot.data![index].title,
                                                    snapshot
                                                        .data![index].color));
                                      });
                                    },
                                    icon: Icon(
                                      Icons.edit_rounded,
                                      color: Colors.lightBlue,
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      snapshot.data![index].title != "Unset",
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.cancel,
                                      color: Colors.lightBlue,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              _deleteTagPopup(context,
                                                  snapshot.data![index].title),
                                        );
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          )
                        ],
                      ),
                    );
                  });
            }
          }),
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
        content: new Column(children: [
          Form(
            key: _formKey,
            child: TextFormField(
              validator: (val) => val!.isEmpty
                  ? "Enter a valid Tag title"
                  : tags.contains(val)
                      ? "tag with the same name exists"
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
        ]),
        actions: [
          Center(
            child: FloatingActionButton.extended(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await DatabaseService().addTag(title, color.value);
                  await DatabaseService().updateNumOfTags(1);
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

  Widget _editTagPopUp(BuildContext context, String old, Color col) {
    final _formKey = GlobalKey<FormState>();
    String title = old;
    Color color = col;

    return SafeArea(
      child: new AlertDialog(
        title: const Text("Edit Tag"),
        content: new Column(children: [
          Form(
              key: _formKey,
              child: TextFormField(
                validator: (val) => val!.isEmpty
                    ? "Enter a valid Tag title"
                    : tags.contains(val)
                        ? "tag with the same name exists"
                        : null,
                controller: TextEditingController()..text = old,
                onChanged: (changed) {
                  title = changed;
                },
              )),
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
        ]),
        actions: [
          Center(
            child: FloatingActionButton.extended(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  if (title != old || color != col) {
                    await DatabaseService().removeTag(old, title, color.value);
                    await DatabaseService().addTag(title, color.value);
                  }
                  Navigator.pop(context);
                }
              },
              label: Text("Edit Tag"),
              heroTag: title,
            ),
          )
        ],
      ),
    );
  }

  Widget _deleteTagPopup(BuildContext context, String name) {
    final _formKey = GlobalKey<FormState>();
    Color color = Colors.blue;
    String title = "";

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Confirm deletion of tag?'),
          TextButton(
            onPressed: () async {
              // delete tag in firestore
              // await DatabaseService.deleteTag()
              await DatabaseService()
                  .removeTag(name, "Unset", Colors.grey.value);
              await DatabaseService().updateNumOfTags(-1);
              Navigator.pop(context);
            },
            child: Text('delete $name tag'),
          ),
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
