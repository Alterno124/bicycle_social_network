class Usuario_Entitie {
  final int id_Usuario;
  final int cod_Usuario;
  final String nombre;
  final String fehaCreacion;

  Usuario_Entitie({this.id_Usuario, this.cod_Usuario, this.nombre, this.fehaCreacion});

  factory Usuario_Entitie.fromJson(Map<String, dynamic> json) {
    return Usuario_Entitie(
      id_Usuario: json['id_Usuario'],
      cod_Usuario: json['cod_Usuario'],
      nombre: json['nombre'],
      fehaCreacion: json['fechaCreacion'],
    );
  }
}