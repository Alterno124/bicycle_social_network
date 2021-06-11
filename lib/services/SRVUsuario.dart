import 'dart:convert';
import 'package:http/http.dart' as http;

/*
 * El método siguiente funciona para el ingreso del usuario mediante una API REST
 */
Future postUsuario(String correo, String nombre) async {
  var url = Uri.parse(Uri.encodeFull("http://192.168.0.105:8000/usuario-create"));

  var body = jsonEncode({
    'correo': correo,
    'nombre': nombre
  });

  print("Body: " + body);
  http.post(url,
      headers: {"Content-Type": "application/json"},
      body: body
  ).then((http.Response response) {
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.contentLength}");
    print(response.headers);
    print(response.request);
  });
}

/*
 * El método siguiente funciona para el ingreso del usuario mediante una API REST
 */
usuarioExistente(String correo) async {
  http.Response response = await http.get(Uri.parse(Uri.encodeFull("http://192.168.0.105:8000/usuario/${correo}")),
    headers: {"Accept": "application/json"},
  );
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}