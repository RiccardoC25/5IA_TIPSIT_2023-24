import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: MyGridView(),
        ),
      ),
    );
  }
}

class MyGridView extends StatefulWidget {
  @override
  _MyGridViewState createState() => _MyGridViewState();
}

class _MyGridViewState extends State<MyGridView> {
  // set an int with value -1 since no card has been selected
  int selectedCard = -1;
  Socket? _socket;

  List<int> list = [0,0,0,0,0,0,0,0,0,0,
                    0,0,0,0,0,0,0,0,0,0,
                    0,0,0,0,0,0,0,0,0,0,
                    0,0,0,0,0,0,0,0,0,0,
                    0,0,0,0,0,0,0,0,0,0,
                    0,0,0,0,0,0,0,0,0,0,
                    0,0,0,0,0,0,0,0,0,0,
                    0,0,0,0,0,0,0,0,0,0,
                    0,0,0,0,0,0,0,0,0,0,
                    0,0,0,0,0,0,0,0,0,0];


  void initState() {
    super.initState();
    Socket.connect('10.0.2.2', 8080).then((sock) {
      setState(() {
        _socket = sock;
      });
    }, onError: (e) {
      debugPrint("Unable to connect: $e");
      exit(1);
    });
  }


  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: false,
        scrollDirection: Axis.vertical,
        itemCount: 100,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 10,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 2),
        ),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                // ontap of each card, set the defined int to the grid view index
                cellOperation(index);
              });
            },
            child: Card(
              // check if the index is equal to the selected Card integer
              color: setColor(index)/*selectedCard == index ? Colors.blue : Colors.grey*/,
              child: Container(
                height: 200,
                width: 200,
                child: Center(
                  child: Text(
                    '',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  void cellOperation(int i) {
    int sup = i%10;
    String col = "A";
    int row = 0;
    switch(sup){
      case 0:
        col = "A";
        break;
      case 1:
        col = "B";
        break;
      case 2:
        col = "C";
        break;
      case 3:
        col = "D";
        break;
      case 4:
        col = "E";
        break;
      case 5:
        col = "F";
        break;
      case 6:
        col = "G";
        break;
      case 7:
        col = "H";
        break;
      case 8:
        col = "I";
        break;
      case 9:
        col = "J";
        break;
    }
    row = (i/10).truncate();

    connServer(col, row);
  }

  Future<void> connServer(String col, int row) async {
    try {
      _socket?.add(utf8.encode("P"+col+" "+row.toString()));
      
      _socket?.listen((eventBytes) {
        String result = utf8.decode(eventBytes);
        if(result.contains("You Win")){
          for(int t = 0; t<list.length; t++){
            list[t] = 3;
          }
        }else if(result.contains("You Loose")){
          for(int t = 0; t<list.length; t++){
            list[t] = 4;
          }
        }else{
          result = result.replaceAll("[", "");
          result = result.replaceAll("]", "");
          List<String> lsSup = result.split(", ");
          for(int j = 0; j<list.length; j++){
            list[j] = int.parse(lsSup[j]);
          }
        }
      });
    }catch(e){
      print("Connection error!");
    }
  }

  Color setColor(int i){
    Color color = Colors.white;

    switch(list[i]){
      case 0:
        color = Colors.blue;
        break;
      case 1:
        color = Colors.yellow;
        break;
      case 2:
        color = Colors.red;
        break;
      case 3:
        color = Colors.green;
        break;
      case 4:
        color = Colors.deepOrange;
        break;
    }

    return color;
  }
}