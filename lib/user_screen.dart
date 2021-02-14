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

class SubmitScreen extends StatefulWidget {
  @override
  _SubmitScreenState createState() => _SubmitScreenState();
}

class _SubmitScreenState extends State<SubmitScreen> {
  var nameOfPickup = TextEditingController();
  String dateOfPickup = "Select Date..";
  DateTime pickedDate = DateTime.now();
    final firestoreInstance = FirebaseFirestore.instance;
    List<Widget> foodList = [];

  _pickDate() async {
    DateTime curDate = await showDatePicker(
        context: context,
        initialDate: pickedDate,
        firstDate: pickedDate,
        lastDate: DateTime(DateTime.now().year+5));
    if(curDate!=null){
      setState(() {
        pickedDate = curDate;
        dateOfPickup = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
        foodList = [];
      });
    }
  }

  Widget itemTile(var name, int days, int counter){
    return Card(
      color: paletteLightBlue,
      child: ListTile(
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 10.0),
          title: Text(name, style: ListFont),
          subtitle: Text("Expiring In $days days", style: ListFontMini),
          trailing: Padding(padding: EdgeInsets.only(right:20),child: Text("$counter", style: ListFont))
      ),
    );
  }

  Future<void> submitCounters() async {
  final menu = await firestoreInstance.collection("foods").get();
  for(var item in menu.docs){
    var temp = item.data();
    if(temp["counter"] > 0){
      if(temp["foodAmount"]==temp["counter"]){
        firestoreInstance.collection("foods").doc(item.id).delete();
      }else {
        firestoreInstance.collection("foods").doc(item.id).update(
            {"foodAmount": temp["foodAmount"] - temp["counter"]});
        firestoreInstance.collection("foods").doc(item.id).update(
            {"counter": 0});
      }
    }
  }
}

    Future getMenu(BuildContext context) async {
      final menu = await firestoreInstance.collection("foods").get();
      for(var item in menu.docs){
        var temp = item.data();
        if(temp["counter"] > 0){
          foodList.add(itemTile(temp["foodName"], temp["foodExpiration"], temp["counter"]));
        }
      }
      return foodList;
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: paletteLightGreen,
        appBar: AppBar(
            backgroundColor: paletteDarkBlue,
            title: Text("Request Summary")
        ),
        body: Column(
          children: [Expanded(
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
          ),
            Expanded(
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      title: TextField(
                        controller: nameOfPickup,
                        decoration: InputDecoration(
                          fillColor: paletteYellow,
                          border: OutlineInputBorder(),
                          labelText: 'Name',
                        ),
                      )
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      onTap: (){
                        _pickDate();
                      },
                      title: TextField(
                        enabled: false,
                        decoration: InputDecoration(
                          fillColor: paletteYellow,
                          border: OutlineInputBorder(),
                          labelText: dateOfPickup,
                        ),
                      )
                    ),
                  ],
                ),
            ),
            SizedBox(
              width: 200,
              child: RaisedButton(
                onPressed: () {
                  firestoreInstance.collection("pickupDates").add({
                    "time":dateOfPickup,
                    "name":"${nameOfPickup.text}",
                  });
                  submitCounters();
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('Send', style: TextStyle(fontSize: 22)),
                elevation: 0.0,
                color: paletteYellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ],
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

  Future getMenu(BuildContext context) async {
    final menu = await firestoreInstance.collection("foods").get();
    for(var item in menu.docs){
      var temp = item.data();
      foodList.add(itemTile(temp["foodName"], temp["foodAmount"], temp["foodExpiration"], temp["counter"], item.id));
    }
    return foodList;
  }

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
        title: Text("Walmart")
      ),
      body: Column(
        children: [Expanded(
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
        ),
          SizedBox(
            width: 300,
            child: RaisedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SubmitScreen())
                );
              },
              child: Text('Review Request', style: TextStyle(fontSize: 20)),
              elevation: 0.0,
              color: paletteYellow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ],
      )
    );
  }
}