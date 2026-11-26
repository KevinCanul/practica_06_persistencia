class Tarea {
  final int? id;
  final String titulo;
  final String descripcion;
  final bool completada;
  final bool pendienteSincronizar;

  Tarea({
    this.id,
    required this.titulo,
    required this.descripcion,
    this.completada = false,
    this.pendienteSincronizar = true,
  });

  factory Tarea.fromMap(Map<String, dynamic> map) {
    return Tarea(
      id: map['id'] as int,
      titulo: map['titulo'] as String,
      descripcion: map['descripcion'] as String,
      completada: map['completada'] == 1,
      pendienteSincronizar: map['pendiente_sincronizar'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'completada': completada ? 1 : 0,
      'pendiente_sincronizar': pendienteSincronizar ? 1 : 0,
    };
  }
}
