import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

final firestoreInstance = FirebaseFirestore.instance;
const paletteLightGreen = const Color(0xff9cd7b4);
const paletteLightBlue = const Color(0xffdcf0e1);
const paletteYellow = const Color(0xfffbd969);
const paletteDarkGreen = const Color(0xff0f3044);
const paletteDarkBlue = const Color(0xff497a6e);
TextStyle ListFont = TextStyle(fontSize: 21);
TextStyle ListFontMini = TextStyle(fontSize: 16);

class RequestListScreen extends StatefulWidget {
  @override
  _RequestListScreenState createState() => _RequestListScreenState();
}

class _RequestListScreenState extends State<RequestListScreen> {
  void reloadList(){
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> foodList = [];

    Widget itemTile(var name, var time, var id){
      return Card(
        child: ListTile(
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 10.0),
            title: Text(name, style: ListFont),
            subtitle: Text(time),
            trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 12.0),
                    child: IconButton(icon: Icon(Icons.check_circle),onPressed: () {
                      setState(() {
                        firestoreInstance.collection("pickupDates").doc(id).delete();
                        foodList = [];
                      });
                    },),
                  )]
            )
        ),
      );
    }

    Future getMenu(BuildContext context) async {
      final menu = await firestoreInstance.collection("pickupDates").get();
      for(var item in menu.docs){
        var temp = item.data();
        foodList.add(itemTile(temp["name"], temp["time"], item.id));
      }
      return foodList;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0f3044),
        title: Text("Scheduled Pickup Times",style: TextStyle(fontSize: 24,color: Colors.white)),
      ),
      body: Column(
          children:[
            Expanded(
              child: FutureBuilder(
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
              ),
            )
          ]),
    );
  }
}


class Grocery extends StatefulWidget {
  @override
  GroceryState createState() => GroceryState();
}

class GroceryState extends State<Grocery> {

  void reloadList(){
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> foodList = [];

    Widget itemTile(var name, int amount, int days, var id){
      return Card(
        child: ListTile(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 0.0, 15.0),
            title: Text(name, style: ListFont),
            subtitle: Text("Amount: $amount\nExpiring In $days days", style: ListFontMini),
            trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 12.0),
                    child: IconButton(icon: Icon(Icons.cancel),onPressed: () {
                      setState(() {
                        firestoreInstance.collection("foods").doc(id).delete();
                        foodList = [];
                      });
                    },),
                  )]
            )
        ),
      );
    }

    Future getMenu(BuildContext context) async {
      final menu = await firestoreInstance.collection("foods").get();
      for(var item in menu.docs){
        var temp = item.data();
        foodList.add(itemTile(temp["foodName"], temp["foodAmount"], temp["foodExpiration"], item.id));
      }
      return foodList;
    }
    int _selectedIndex = 0;

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color(0xFF0f3044),
            title: Text("Food Items",style: TextStyle(fontSize: 24,color: Colors.white)),
          actions: [
            Padding(padding: EdgeInsets.only(right: 20.0),child:
            IconButton(icon: Icon(Icons.add_outlined), onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewFood())
              );
            })
            )
          ],
        ),
        body: Column(
          children:[
          Expanded(
            child: FutureBuilder(
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
            ),
          ),SizedBox(
              width: 300,
              child: RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RequestListScreen())
                  );
                },
                child: Text('Pickup Times', style: TextStyle(fontSize: 20)),
                elevation: 0.0,
                color: paletteYellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
        ]),
    );


  }
}

class NewFood extends StatefulWidget {
  @override
  _NewFoodState createState() => _NewFoodState();
}

class _NewFoodState extends State<NewFood> {
  //Drop down button 1
  final List numbers = [
    "Apple",
    "Banana",
    "Orange",
    "Pear",
    "Blueberries",
    "Watermelon",
    "Strawberries",
    "Cereal",
    "Crackers"
  ];
  String nameCity = "Apple";

  //Quantity number
  int quantity = 1;

  //Day num
  int days = 1;

  void _onPressed() {
    firestoreInstance.collection("foods").add({
      'foodAmount': quantity,
      'foodExpiration': days,
      'foodName': nameCity,
      'counter' : 0,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Food Items",style: TextStyle(fontSize: 24,color: Colors.white)),
        backgroundColor: Color(0xFF0f3044),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              ListTile(
                title: Text(
                  "Food Item",
                  style: TextStyle(
                    //fontFamily: 'Abril Fatface',
                      fontSize: 30.0,
                      color: Color(0xFF0f3044)),
                ),
                trailing: Container(
                  margin: EdgeInsets.only(right: 20),
                  width: 170.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      dropdownColor: Colors.white,
                      elevation: 16,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 30.0,
                      value: nameCity,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                      ),
                      onChanged: (value) {
                        setState(() {
                          nameCity = value;
                        });
                      },
                      items: numbers.map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem(
                          child: Center(child: Text(value)),
                          value: value,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              ListTile(
                title: Text(
                  "Quantity",
                  style: TextStyle(
                    //fontFamily: 'Abril Fatface',
                      fontSize: 30.0,
                      color: Color(0xFF0f3044)),
                ),
                trailing: Container(
                  padding: EdgeInsets.only(right:15),
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FloatingActionButton(
                          backgroundColor: Color(0xFF0f3044),
                          heroTag: "1",
                          child: Icon(Icons.remove),onPressed: () {
                          setState(() {
                            if(quantity > 1){
                              quantity -= 1;
                            }
                          }
                          );
                        },),
                        Container(
                          width: 60,
                          child: Center(
                              child: Text("$quantity", style: TextStyle(
                                decoration: TextDecoration.underline,fontSize: 25.0,))
                          ),
                        ),
                        FloatingActionButton(
                          backgroundColor: Color(0xFF0f3044),
                          heroTag: "2",
                          child: Icon(Icons.add),onPressed: () {
                          setState(() {
                            if(quantity < 99){
                              quantity += 1;
                            }
                          }
                          );
                        },),
                      ]
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ListTile(
                title: Text(
                  "Days until expiration",
                  style: TextStyle(
                    //fontFamily: 'Abril Fatface',
                      fontSize: 30.0,
                      color: Color(0xFF0f3044)),
                ),
                trailing: Container(
                  padding: EdgeInsets.only(right:15),
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FloatingActionButton(
                          backgroundColor: Color(0xFF0f3044),
                          heroTag: "3",
                          child: Icon(Icons.remove),onPressed: () {
                          setState(() {
                            if(days > 1){
                              days -= 1;
                            }
                          }
                          );
                        },),
                        Container(
                          width: 60,
                          child: Center(
                            child: Text("$days", style: TextStyle(
                              decoration: TextDecoration.underline,fontSize: 25.0,))
                          ),
                        ),
                        FloatingActionButton(
                          backgroundColor: Color(0xFF0f3044),
                          heroTag: "4",
                          child: Icon(Icons.add),onPressed: () {
                          setState(() {
                            if(days < 99){
                              days += 1;
                            }
                          }
                          );
                        },),
                      ]
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Center(
                child:
                  Container(
                    child: ButtonTheme(
                      minWidth: 195.0,
                      height: 50.0,
                      child: RaisedButton(
                          padding: EdgeInsets.all(10.0),
                          onPressed: () {
                            _onPressed();
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => Grocery(),
                            ));
                          },
                          elevation: 0.0,
                          color: Color(0xFF0f3044),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: BorderSide(
                                color: Color(0xFF0f3044), width: 2.0),
                          ),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "ADD",
                                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
                              )
                            ],
                          )),
                    ),
                  ),

              )
            ],
          ),
        ),
      ),
    );
  }
}

