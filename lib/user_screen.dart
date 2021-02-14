import 'package:cloud_firestore/cloud_firestore.dart';

import 'main.dart';
import 'package:flutter/material.dart';
TextStyle ListFont = TextStyle(fontSize: 21);
TextStyle ListFontMini = TextStyle(fontSize: 16);


class UserScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: paletteLightGreen,
        appBar: AppBar(
          backgroundColor: paletteDarkBlue,
          title: Text("Select a Grocery Store", style: TextStyle(fontSize: 24,color: Colors.white)),
        ),
        body: ListView(
            children: [
              Card(
                color: paletteLightBlue,
                child: ListTile(
                  title: Text("Walmart", style: ListFont),
                  subtitle: Text("Brown Street No.2", style: ListFontMini),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SupermarketScreen())
                    );
                  },
                ),
              )
            ]
        )
    );
  }
}

class SupermarketScreen extends StatefulWidget {
  @override
  _SupermarketScreenState createState() => _SupermarketScreenState();
}

class _SupermarketScreenState extends State<SupermarketScreen> {
  final firestoreInstance = FirebaseFirestore.instance;
  List<Widget> foodList = [];
<<<<<<< HEAD

  Future getMenu(BuildContext context) async {
    final menu = await firestoreInstance.collection("foods").get();
    for(var item in menu.docs){
      var temp = item.data();
      foodList.add(itemTile(temp["foodName"], temp["foodAmount"], temp["foodExpiration"], temp["counter"], item.id));
    }
    return foodList;
  }

=======

  Future getMenu(BuildContext context) async {
    final menu = await firestoreInstance.collection("foods").get();
    for(var item in menu.docs){
      var temp = item.data();
      foodList.add(itemTile(temp["foodName"], temp["foodAmount"], temp["foodExpiration"], temp["counter"], item.id));
    }
    return foodList;
  }

>>>>>>> 65c9edd96ac0f777d881657d0d2ffb4258b37fd8
  Widget itemTile(var name, int amount, int days, int counter, var id){
    return Card(
      color: paletteLightBlue,
      child: ListTile(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 0.0, 15.0),
        title: Text(name, style: ListFont),
        subtitle: Text("Amount: $amount\nExpiring In $days days", style: ListFontMini),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: Icon(Icons.keyboard_arrow_left),onPressed: () {
              setState(() {
                if(counter > 0){
                  firestoreInstance.collection("foods").doc(id).update({"counter":counter-=1});
                }
                foodList = [];
              });
            },),
            Text("$counter", style: ListFont),
            IconButton(icon: Icon(Icons.keyboard_arrow_right),onPressed: () {
              setState(() {
                if(counter < amount) {
                  firestoreInstance.collection("foods").doc(id).update({"counter":counter+=1});
                }
                foodList = [];
              });
            },),
          ]
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: paletteLightGreen,
      appBar: AppBar(
        backgroundColor: paletteDarkBlue,
      ),
      body: FutureBuilder(
        future: getMenu(context),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            return ListView(
              children: foodList,
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
      )
    );
  }
}