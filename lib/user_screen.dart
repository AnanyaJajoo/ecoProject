import 'package:flutter/material.dart';
TextStyle ListFont = TextStyle(fontSize: 21);
TextStyle ListFontMini = TextStyle(fontSize: 16);

class UserScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Select a Grocery Store", style: TextStyle(fontSize: 24,color: Colors.white)),
        ),
        body: ListView(
            children: [
              Card(
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

  Widget itemTile(var name, int amount, int days){
    int _userAmount = 0;
    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 0.0, 15.0),
        title: Text(name, style: ListFont),
        subtitle: Text("Amount: $amount\nExpiring In $days days", style: ListFontMini),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: Icon(Icons.keyboard_arrow_left),onPressed: () {
              setState(() {
                if(_userAmount < amount){
                  _userAmount++;
                }
              });
            },),
            Text("$_userAmount", style: ListFont),
            IconButton(icon: Icon(Icons.keyboard_arrow_right),onPressed: () {
              setState(() {
                if(_userAmount >1) {
                  _userAmount--;
                }
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
      appBar: AppBar(
      ),
      body: ListView(
        children: [
          itemTile("Canned Soup", 5, 3)
        ]
      )
    );
  }
}
