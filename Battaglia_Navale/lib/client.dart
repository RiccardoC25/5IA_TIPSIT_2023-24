import 'dart:convert';
import 'dart:io';

void main(List<String> arguments) async {
  print('TCP Client');
  var socket;
  bool inGame = true;
  String resServ = "";
  while(resServ != "Finito"){
    socket = await Socket.connect('127.0.0.1', 8080);
    socket.listen((eventBytes) {
      String result = utf8.decode(eventBytes);
      resServ = result;
      result = result.replaceAll("[", "");
      result = result.substring(0, result.length - 2);
      List<String> list = result.split("], ");

      if(resServ != "Finito") {
        print("   A  B  C  D  E  F  G  H  I  J");
        for (int i = 0; i < list.length; i++) {
          print(i.toString() + "  " + list[i]);
        }
      }
    });

    print("\n\n\nInserisci la cella dove inserire la nave (Esempio 'A 0') oppure inserisci 'exit' per uscire: ");
    String? msg = stdin.readLineSync();
    if(msg == "exit"){
      break;
    }
    socket.add(utf8.encode("P"+msg!));
    await Future.delayed(Duration(seconds: 2));
    await socket.flush();
    socket.destroy();
  }
  while(inGame) {
    socket = await Socket.connect('127.0.0.1', 8080);
    socket.listen((eventBytes) {
      String result = utf8.decode(eventBytes);
      if(result == "You Loose"){
        print("\n\n\nYou Loose\n\n");
        inGame = false;
        return;
      }else if(result == "You Win"){
        print("\n\n\nYou Win\n\n");
        inGame = false;
        return;
      }
      result = result.replaceAll("[", "");
      result = result.substring(0, result.length - 2);
      List<String> list = result.split("], ");

      print("   A  B  C  D  E  F  G  H  I  J");
      for (int i = 0; i < list.length; i++) {
        print(i.toString() + "  " + list[i]);
      }
    });

    print("\n\n\nInserisci la cella (Esempio 'A 0') oppure inserisci 'exit' per uscire: ");
    String? msg = stdin.readLineSync();
    if(msg == "exit"){
      break;
    }
    socket.add(utf8.encode("P"+msg!));
    await Future.delayed(Duration(seconds: 2));
    await socket.flush();
    socket.destroy();
  }
  socket.destroy();
}