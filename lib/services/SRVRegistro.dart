import 'dart:convert';
import 'package:http/http.dart' as http;

/*
 * Este método se encarga de crear una foto por medio del servicio en el servidor
 */
Future foto(String imagen, String tipoImagen) async {
  var url2 =
      Uri.parse(Uri.encodeFull("http://192.168.39.100:8000/fotobici-create"));
  var body2 = jsonEncode({
    'imagen': imagen,
    'tipo_imagen': tipoImagen,
  });

  print("Body: " + body2);
  await http
      .post(url2, headers: {"Content-Type": "application/json"}, body: body2)
      .then((http.Response response) {
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.contentLength}");
    print(response.headers);
    print(response.request);
  });
}

/*
 * Este método se encarga de crear un registro por medio del servicio en el servidor
 */
Future registro(String correo, String descripcion) async {
  var url =
      Uri.parse(Uri.encodeFull("http://192.168.39.100:8000/registro-create"));
  var body = jsonEncode({
    'correo': correo,
    'descripcion': descripcion,
  });

  print("Body: " + body);
  http
      .post(url, headers: {"Content-Type": "application/json"}, body: body)
      .then((http.Response response) {
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.contentLength}");
    print(response.headers);
    print(response.request);
  });
}

/*
 * Este método se encarga de traer un registro por medio del servicio en el servidor
 */
Future<Map> getImagenes(String correo) async {
  var url = Uri.parse(
      Uri.encodeFull("http://192.168.39.100:8000/registro-BuscaImagen/rubenchoortegon@gmail.com"));
  var response = await http.get(url);
  var parsedJson = json.decode(response.body);
  return parsedJson;
}

/*
 * Este método se encarga de traer un registro por medio del servicio en el servidor
 */
Future<Map> getRegistro(String correo) async {
  var url = Uri.parse(
      Uri.encodeFull("http://192.168.39.100:8000/registro-Busca/rubenchoortegon@gmail.com"));
  var response = await http.get(url);
  var parsedJson = json.decode(response.body);
  return parsedJson;
}
