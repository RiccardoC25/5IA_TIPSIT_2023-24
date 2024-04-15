import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_server_client_rest/main.dart';
import 'package:flutter_server_client_rest/client.dart';

class MyAppSecondPage extends StatefulWidget {
  @override
  SecondPage createState() => SecondPage();
}

class SecondPage extends State<MyAppSecondPage>{
  var data_to_print;
  final myController = TextEditingController();

  List<DynamicWidget> listDynamic = [];

  addDynamic() {
    if (listDynamic.length != 0) {
      listDynamic = [];
    }

    listDynamic.add(new DynamicWidget(data_to_print));

    setState(() {});
  }

  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
  }


  final ButtonStyle buttonStyle = TextButton.styleFrom(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SecondPage",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Second Screen"),
          centerTitle: true,
          leading: FittedBox(
            child: FloatingActionButton(
              child: Icon(Icons.arrow_back_rounded),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
              },
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Align(
                child: Padding(
                  padding: EdgeInsets.all(25.0),
                  child: TextField(
                    controller: myController,
                    decoration: InputDecoration(
                      labelText: 'Label here...',
                    ),
                  ),
                ),
              ),
              Align(
                child: Container(
                  child: TextButton(
                    style: buttonStyle,
                    onPressed: () async {
                      data_to_print = await serverAccess(myController.text);
                      addDynamic();
                    },
                    child: Text(
                      'Invia Richiesta',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
              ),
              Align(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Dati del Dipendente:',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),
              Align(
                  child: Column(
                    children: <Widget>[
                      listDynamic.length == 1 ? listDynamic[0] : Text(""),
                    ],
                  ),
              )
            ],
          ),
        ),
      )
    );
  }
}

class DynamicWidget extends StatelessWidget {
  var data_to_print;

  DynamicWidget(data){
    this.data_to_print = data;
    print(data);
  }

  @override
  Widget build(BuildContext context){
    return Container(
      child: new Text(
        'Nome: ${data_to_print['nome']}\nCognome: ${data_to_print['cognome']}\nReparto: ${data_to_print['reparto']}',
        style: TextStyle(fontSize: 20)
      ),
    );
  }
}