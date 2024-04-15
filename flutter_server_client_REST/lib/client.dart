import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<void> main() async {
  /*// Chiedi all'utente di inserire il dato da inviare al server
  print("Inserisci il dato da inviare al server:");
  var input = stdin.readLineSync();

  // Crea l'URL del server REST PHP
  var url = Uri.parse('http://localhost/progetto_server_Dentico/server.php?codice=$input');

  // Esegui la richiesta GET al server
  var response = await http.get(url);

  // Controlla se la richiesta è stata eseguita con successo
  if (response.statusCode == 200) {
    // Decodifica la risposta JSON
    var data = jsonDecode(response.body);
    print("Risposta dal server: $data");
  } else {
    // Se la richiesta ha fallito, stampa il codice di stato
    print('Errore nella richiesta: ${response.statusCode}');
  }*/

}

Future<dynamic> serverAccess(String codice) async {
  var finalData;

  var url = Uri.parse('http://10.0.2.2/progetto_server_Dentico/server.php?codice=$codice');

  var response = await http.get(url);

  if (response.statusCode == 200) {
    // Decodifica la risposta JSON
    var data = jsonDecode(response.body);
    finalData = data;
  } else {
    // Se la richiesta ha fallito, stampa il codice di stato
    finalData = response.statusCode.toString();
  }

  return finalData;
}

