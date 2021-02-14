import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

final firestoreInstance = FirebaseFirestore.instance;

class Grocery extends StatefulWidget {
  @override
  _GroceryState createState() => _GroceryState();
}

class _GroceryState extends State<Grocery> {
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
  int quantity = 0;

  //Day num
  int days = 1;

  @override
  Widget build(BuildContext context) {
    void _onPressed() {
      firestoreInstance.collection("foods").add({
        'foodAmount':quantity,
        'foodExpiration':days,
        'foodName': nameCity,
      });
    }
    return Scaffold(
      appBar: AppBar(title: Text("Grocery")),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 10.0),
                child: Text(
                  "Food Item",
                  style: TextStyle(
                      fontFamily: 'Abril Fatface',
                      fontSize: 30.0,
                      color: Color(0xFF0f3044)),
                ),
              ),
              Container(
                width: 300.0,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    dropdownColor: Colors.grey,
                    elevation: 5,
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
              Container(
                margin: EdgeInsets.only(top: 10.0),
                child: Text(
                  "Quantity",
                  style: TextStyle(
                      fontFamily: 'Abril Fatface',
                      fontSize: 30.0,
                      color: Color(0xFF0f3044)),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                Container(
                  child: Text(
                    "$quantity",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 25.0,
                    ),
                  ),
                ),
                SizedBox(width: 50.0),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  alignment: Alignment.center,
                  child: FloatingActionButton(
                    heroTag: "1",
                    child: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        quantity += 1;
                      });
                    },
                  ),
                ),
              ]),
              Container(
                margin: EdgeInsets.only(top: 10.0),
                child: Text(
                  "How many days will it last?",
                  style: TextStyle(
                      fontFamily: 'Abril Fatface',
                      fontSize: 30.0,
                      color: Color(0xFF0f3044)),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                Container(
                  child: Text(
                    "$days",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 25.0,
                    ),
                  ),
                ),
                SizedBox(width: 50.0),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  alignment: Alignment.center,
                  child: FloatingActionButton(
                    heroTag: "2",
                    child: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        days += 1;
                      });
                    },
                  ),
                ),
              ]),
              RaisedButton(onPressed: (){
                _onPressed();
              }
              )
            ],
          ),
        ),
      ),
    );
  }
}
