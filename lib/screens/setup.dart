import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_buddy/services/database.dart';

class SetUp extends StatefulWidget {
  @override
  _SetUpState createState() => _SetUpState();
}

// choose animals!
// update in database
// "dog", "cat", "rabbit", "hamster"
// clickable buttons!
// database :: updatePet
class _SetUpState extends State<SetUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(top: 150.0, left: 15.0, right: 15.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white30,
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 15.0,
          childAspectRatio: 0.8,
          children: [
            _buildPet("dog", "assets/dog/dog0000.png", context),
            _buildPet("cat", "assets/cat/cat0000.png", context),
            _buildPet("rabbit", "assets/rabbit/rabbit0000.png", context),
            _buildPet("hamster", "assets/hamster/hamster0000.png", context)
          ],
        ),
      )
    );
  }

  Widget _buildPet(String pet, String imgPath, context) {
    return PetTile(pet: pet, imgPath: imgPath);
  }
}

class PetTile extends StatefulWidget {
  String pet;
  String imgPath;
  PetTile({required this.pet, required this.imgPath});

  @override
  _PetTileState createState() => _PetTileState(this.pet, this.imgPath);
}

class _PetTileState extends State<PetTile> {
  late String pet;
  late String imgPath;

  _PetTileState(String pet, String imgPath) {
    this.pet = pet;
    this.imgPath = imgPath;
  }

  // var _selectButton;
  //
  // @override
  // void initState() {
  //   _selectButton = false;
  //   super.initState();
  // }
  //
  // select() {
  //   setState(() {
  //     _selectButton = !_selectButton;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
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
              tag: this.imgPath,
              child: Container(
                height: 100.0,
                width: 100.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(this.imgPath),
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
                this.pet,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 7.0,
            ),
            // Visibility(
            //   visible: _selectButton,
            //   child:
            FloatingActionButton.extended(
              heroTag: this.imgPath,
              onPressed: () async {
                // select();
                await DatabaseService().updatePet(this.pet);
                Navigator.pushReplacementNamed(context, "/");
              },
              icon: Icon(
                Icons.circle_outlined,
                color: Colors.white,
              ),
              label: Text(
                "Select",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              backgroundColor: Colors.lightBlue,
            ),
          ],
        ),
      ),
    );
  }
}


