import 'dart:convert';
import 'dart:io';

void main(List<String> arguments) async {
  print('TCP Server');
  final server = await ServerSocket.bind('127.0.0.1', 8080);
  var twoDListP1 = List<List>.generate(10, (i) => List<dynamic>.generate(10, (index) => 0, growable: false), growable: false);
  var twoDListP2 = List<List>.generate(10, (i) => List<dynamic>.generate(10, (index) => 0, growable: false), growable: false);

  var twoDListP1Pos = List<List>.generate(10, (i) => List<dynamic>.generate(10, (index) => 0, growable: false), growable: false);
  var twoDListP2Pos = List<List>.generate(10, (i) => List<dynamic>.generate(10, (index) => 0, growable: false), growable: false);

  int isP1Pos = 0;
  int isP2Pos = 0;

  int sinkP1 = 0;
  int sinkP2 = 0;

  bool isP1 = true;

  server.listen((socket) {
    socket.listen((eventBytes) {
      String result = utf8.decode(eventBytes);
      String player = result.substring(0, 1);
      result = result.substring(1, result.length);
      List<String> res = result.split(" ");
      int row, col = 0;
      switch(res[0].toUpperCase()){
        case "A":
          col = 0;
          break;
        case "B":
          col = 1;
          break;
        case "C":
          col = 2;
          break;
        case "D":
          col = 3;
          break;
        case "E":
          col = 4;
          break;
        case "F":
          col = 5;
          break;
        case "G":
          col = 6;
          break;
        case "H":
          col = 7;
          break;
        case "I":
          col = 8;
          break;
        case "J":
          col = 9;
          break;
      }
      row = int.parse(res[1]);

      if(player.toUpperCase() == "P" && isP1){
        if(isP1Pos < 5){
          twoDListP1Pos[row][col] = 2;
          socket.add(utf8.encode('$twoDListP1Pos'));
          isP1Pos += 1;
          print('Nave posizionata = $result');
          if(isP1Pos-1 != 4) {
            return;
          }
        }
        isP1 = false;
        if(isP1Pos-1 == 4) {
          socket.add(utf8.encode('Finito'));
          isP1Pos += 1;
          return;
        }
        if(twoDListP2Pos[row][col] == 2){
          twoDListP1[row][col] = 2;
          sinkP2++;
        }else {
          twoDListP1[row][col] = 1;
        }
        if(sinkP1 == 5){
          socket.add(utf8.encode('You Loose'));
        }else if(sinkP2 == 5){
          socket.add(utf8.encode('You Win'));
        }
        print('Attacco = $result');
        socket.add(utf8.encode('$twoDListP1'));
      }

      if(player.toUpperCase() == "H" && !isP1){
        if(isP2Pos < 5){
          twoDListP2Pos[row][col] = 2;
          socket.add(utf8.encode('$twoDListP2Pos'));
          isP2Pos += 1;
          print('Nave posizionata = $result');
          if(isP2Pos-1 != 4) {
            return;
          }
        }
        isP1 = true;
        if(isP2Pos-1 == 4) {
          socket.add(utf8.encode('Finito'));
          isP2Pos += 1;
          return;
        }
        if(twoDListP1Pos[row][col] == 2){
          twoDListP2[row][col] = 2;
          sinkP1++;
        }else {
          twoDListP2[row][col] = 1;
        }
        if(sinkP1 == 5){
          socket.add(utf8.encode('You Win'));
        }else if(sinkP2 == 5){
          socket.add(utf8.encode('You Loose'));
        }
        print('Attacco = $result');
        socket.add(utf8.encode('$twoDListP2'));
      }
    });
  });
}