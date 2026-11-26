import 'package:flutter/material.dart';

import '../database/db.dart';
import '../models/tarea.dart';
import '../services/preferencias_service.dart';

class TareasScreen extends StatefulWidget {
  const TareasScreen({super.key});

  @override
  State<TareasScreen> createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {
  List<Tarea> tareas = [];
  String nombreUsuario = 'Invitado';
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    final resultados = await DB.listar();
    final nombre = await PreferenciasService.leerNombre();

    if (!mounted) return;

    setState(() {
      tareas = resultados.map((map) => Tarea.fromMap(map)).toList();
      nombreUsuario = nombre;
      cargando = false;
    });
  }

  Future<void> mostrarFormulario({Tarea? tarea}) async {
    final tituloController = TextEditingController(text: tarea?.titulo ?? '');

    final descripcionController = TextEditingController(
      text: tarea?.descripcion ?? '',
    );

    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(tarea == null ? 'Nueva tarea' : 'Editar tarea'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: tituloController,
                    decoration: const InputDecoration(
                      labelText: 'Título',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Escribe un título';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: descripcionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Escribe una descripción';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;

                final titulo = tituloController.text.trim();
                final descripcion = descripcionController.text.trim();

                if (tarea == null) {
                  await DB.insertar(titulo, descripcion);
                } else {
                  await DB.actualizar(tarea.id!, titulo, descripcion);
                }

                if (!dialogContext.mounted) return;
                Navigator.pop(dialogContext);
                await cargarDatos();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );

    tituloController.dispose();
    descripcionController.dispose();
  }

  Future<void> eliminarTarea(Tarea tarea) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar tarea'),
          content: Text('¿Deseas eliminar "${tarea.titulo}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      await DB.eliminar(tarea.id!);
      await cargarDatos();
    }
  }

  Future<void> cambiarCompletada(Tarea tarea, bool valor) async {
    await DB.cambiarEstado(tarea.id!, valor);
    await cargarDatos();
  }

  Future<void> cambiarNombre() async {
    final controller = TextEditingController(text: nombreUsuario);

    final nombre = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Nombre de usuario'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Escribe tu nombre',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                final valor = controller.text.trim();

                if (valor.isNotEmpty) {
                  Navigator.pop(dialogContext, valor);
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (nombre != null) {
      await PreferenciasService.guardarNombre(nombre);

      if (!mounted) return;

      setState(() {
        nombreUsuario = nombre;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final completadas = tareas.where((tarea) => tarea.completada).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestor de tareas'),
        actions: [
          IconButton(
            onPressed: cambiarNombre,
            icon: const Icon(Icons.person_outline),
            tooltip: 'Cambiar nombre',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => mostrarFormulario(),
        icon: const Icon(Icons.add),
        label: const Text('Nueva tarea'),
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¡Hola, $nombreUsuario!',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text('Tienes ${tareas.length} tareas registradas.'),
                      const SizedBox(height: 4),
                      Text(
                        '$completadas tareas completadas',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: tareas.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.task_alt,
                                size: 70,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'No hay tareas registradas',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text('Agrega tu primera tarea.'),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                          itemCount: tareas.length,
                          itemBuilder: (context, index) {
                            final tarea = tareas[index];

                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                leading: Checkbox(
                                  value: tarea.completada,
                                  onChanged: (valor) {
                                    cambiarCompletada(tarea, valor ?? false);
                                  },
                                ),
                                title: Text(
                                  tarea.titulo,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: tarea.completada
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                                subtitle: Text(
                                  '${tarea.descripcion}\n'
                                  '${tarea.pendienteSincronizar ? "Pendiente de sincronizar" : "Sincronizada"}',
                                ),
                                isThreeLine: true,
                                trailing: PopupMenuButton<String>(
                                  onSelected: (opcion) {
                                    if (opcion == 'editar') {
                                      mostrarFormulario(tarea: tarea);
                                    } else if (opcion == 'eliminar') {
                                      eliminarTarea(tarea);
                                    }
                                  },
                                  itemBuilder: (context) => const [
                                    PopupMenuItem(
                                      value: 'editar',
                                      child: Text('Editar'),
                                    ),
                                    PopupMenuItem(
                                      value: 'eliminar',
                                      child: Text('Eliminar'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
