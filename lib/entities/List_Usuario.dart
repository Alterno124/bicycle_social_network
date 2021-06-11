import 'package:bicycle_social_network/entities/Usuario_Entitie.dart';
import 'package:bicycle_social_network/entities/Usuario_Entitie.dart';
import 'package:bicycle_social_network/entities/Usuario_Entitie.dart';

class List_Usuario {
  final List<Usuario_Entitie> usuarios;

  List_Usuario({
    this.usuarios,
  });

  factory List_Usuario.fromJson(List<dynamic> parsedJson) {

    List<Usuario_Entitie> usuarios = new List<Usuario_Entitie>();
    usuarios = parsedJson.map((i)=>Usuario_Entitie.fromJson(i)).toList();

    return new List_Usuario(usuarios: usuarios,);
  }
}