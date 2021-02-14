import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

final firestoreInstance = FirebaseFirestore.instance;
const paletteLightGreen = const Color(0xff9cd7b4);
const paletteLightBlue = const Color(0xffdcf0e1);
const paletteYellow = const Color(0xfffbd969);
const paletteDarkGreen = const Color(0xff0f3044);
const paletteDarkBlue = const Color(0xff497a6e);

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
    final firestoreInstance = FirebaseFirestore.instance;
    void _onPressed() {
      firestoreInstance.collection("foods").add({
        'foodAmount': quantity,
        'foodExpiration': days,
        'foodName': nameCity,
        'counter' : 0,
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Grocery"),
        backgroundColor: Color(0xFF0f3044),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 60.0),
                child: Text(
                  "Food Item",
                  style: TextStyle(
                      //fontFamily: 'Abril Fatface',
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
                margin: EdgeInsets.only(top: 60.0),
                child: Text(
                  "Quantity",
                  style: TextStyle(
                      //fontFamily: 'Abril Fatface',
                      fontSize: 30.0,
                      color: Color(0xFF0f3044)),
                ),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
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
                        backgroundColor: Color(0xFF0f3044),
                        heroTag: "1",
                        child: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            quantity += 1;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 40.0),
                    Container(
                      margin: EdgeInsets.only(top: 10.0),
                      alignment: Alignment.center,
                      child: FloatingActionButton(
                        backgroundColor: Color(0xFF0f3044),
                        heroTag: "2",
                        child: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            quantity -= 1;
                          });
                        },
                      ),
                    ),
                  ]),
              Container(
                margin: EdgeInsets.only(top: 60.0),
                child: Text(
                  "How many days will it last?",
                  style: TextStyle(
                      //fontFamily: 'Abril Fatface',
                      fontSize: 30.0,
                      color: Color(0xFF0f3044)),
                ),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
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
                        backgroundColor: Color(0xFF0f3044),
                        heroTag: "3",
                        child: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            days += 1;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 50.0),
                    Container(
                      margin: EdgeInsets.only(top: 10.0),
                      alignment: Alignment.center,
                      child: FloatingActionButton(
                        backgroundColor: Color(0xFF0f3044),
                        heroTag: "4",
                        child: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            days -= 1;
                          });
                        },
                      ),
                    ),
                  ]),
              SizedBox(height: 50.0),
              Row(
                children: [
                  Container(
                    child: ButtonTheme(
                      minWidth: 195.0,
                      height: 50.0,
                      child: RaisedButton(
                        padding: EdgeInsets.all(10.0),
                          onPressed: () {
                            _onPressed();
                            setState(() {
                              nameCity = "Apple";
                              quantity = 0;
                              days = 1;
                            });
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
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
