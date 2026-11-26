import 'package:flutter_test/flutter_test.dart';
import 'package:practica_06_persistencia/models/tarea.dart';

void main() {
  group('Pruebas del modelo Tarea', () {
    test('Debe crear una tarea correctamente', () {
      final tarea = Tarea(
        id: 1,
        titulo: 'Estudiar Flutter',
        descripcion: 'Realizar la práctica 6',
      );

      expect(tarea.id, 1);
      expect(tarea.titulo, 'Estudiar Flutter');
      expect(tarea.descripcion, 'Realizar la práctica 6');
      expect(tarea.completada, false);
    });

    test('Debe convertir una tarea a Map', () {
      final tarea = Tarea(
        id: 1,
        titulo: 'Estudiar Flutter',
        descripcion: 'Realizar la práctica 6',
        completada: true,
      );

      final mapa = tarea.toMap();

      expect(mapa['titulo'], 'Estudiar Flutter');
      expect(mapa['completada'], 1);
    });

    test('Debe convertir un Map a Tarea', () {
      final tarea = Tarea.fromMap({
        'id': 2,
        'titulo': 'Terminar proyecto',
        'descripcion': 'Completar CRUD',
        'completada': 1,
        'pendiente_sincronizar': 0,
      });

      expect(tarea.id, 2);
      expect(tarea.completada, true);
      expect(tarea.pendienteSincronizar, false);
    });
  });
}
