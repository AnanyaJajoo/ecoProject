import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'grocery.dart';
import 'user_screen.dart';

const paletteLightGreen = const Color(0xff9cd7b4);
const paletteLightBlue = const Color(0xffdcf0e1);
const paletteYellow = const Color(0xfffbd969);
const paletteDarkGreen = const Color(0xff0f3044);
const paletteDarkBlue = const Color(0xff497a6e);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      theme: ThemeData(
          fontFamily: 'GlacialIndifference'),
        home: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/1.png"), fit: BoxFit.cover),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 200.0, left: 22.0),
                child: Image.asset(
                  'images/leaf.png',
                  height: 100.0,
                  width: 200.0,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0),
                child: Text(
                  "Eco",
                  style: TextStyle(
                      fontFamily: 'Abril Fatface',
                      fontSize: 50.0,
                      color: Color(0xFF0f3044)),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Container(
                  child: ButtonTheme(
                minWidth: 350.0,
                height: 50.0,
                child: RaisedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => Grocery(),
                      ));
                  },
                  child: Text('Grocery Store', style: TextStyle(fontSize: 20)),
                  elevation: 0.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(
                      color: Color(0xFF0f3044),
                      width: 5.0,
                    ),
                  ),
                ),
              )),
              SizedBox(
                height: 30.0,
              ),
              Container(
                  child: ButtonTheme(
                minWidth: 350.0,
                height: 50.0,
                child: RaisedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => UserScreen(),
                    ));
                  },
                  child: Text('User', style: TextStyle(fontSize: 20)),
                  elevation: 0.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Color(0xFF0f3044), width: 5.0),
                  ),
                ),
              )),
            ],
          )),
    );
  }
}