# Práctica 6: Persistencia local y funcionamiento offline

## Información general

- **Proyecto:** Gestor de tareas offline
- **Asignatura:** Desarrollo de aplicaciones móviles
- **Institución:** ITESCAM
- **Tecnología:** Flutter y Dart
- **Base de datos:** SQLite
- **Plataforma de ejecución:** Microsoft Edge
- **Participante:** Kevin Canul

## 1. Introducción

Esta práctica consiste en implementar persistencia local y funcionamiento sin conexión a Internet mediante Flutter.

Se desarrolló una aplicación de gestión de tareas que permite almacenar información localmente, administrar registros y conservar las preferencias del usuario incluso después de cerrar o recargar la aplicación.

## 2. Objetivo

Persistir preferencias simples y registros estructurados en almacenamiento local, implementando operaciones CRUD y una estrategia básica de funcionamiento offline.

## 3. Tecnologías utilizadas

- **Flutter:** Framework para desarrollar la aplicación.
- **Dart:** Lenguaje de programación.
- **SQLite:** Base de datos para almacenar las tareas.
- **sqflite:** Paquete para realizar operaciones con SQLite.
- **sqflite_common_ffi_web:** Compatibilidad de SQLite con Flutter Web.
- **SharedPreferences:** Almacenamiento de preferencias del usuario.
- **Path:** Administración de rutas de almacenamiento.
- **Microsoft Edge:** Navegador utilizado para ejecutar y probar la aplicación.

## 4. Funcionalidades implementadas

### Gestión de tareas

La aplicación permite realizar las siguientes operaciones:

- Crear nuevas tareas.
- Consultar las tareas registradas.
- Editar el título y la descripción.
- Eliminar tareas mediante un diálogo de confirmación.
- Marcar tareas como completadas.
- Visualizar el número de tareas registradas y completadas.

### Persistencia local

Se utiliza SQLite para almacenar los registros de tareas mediante una tabla denominada `tareas`.

La tabla contiene los siguientes campos:

| Campo | Descripción |
|---|---|
| id | Identificador único de la tarea |
| titulo | Nombre de la tarea |
| descripcion | Descripción de la actividad |
| completada | Estado de finalización |
| pendiente_sincronizar | Indicador de cambios pendientes de sincronización |

### Preferencias del usuario

Se implementó SharedPreferences para guardar el nombre del usuario y mostrarlo al iniciar la aplicación.

### Funcionamiento offline

La aplicación utiliza almacenamiento local para administrar las tareas sin depender de una conexión a Internet.

También incorpora el campo `pendiente_sincronizar`, que permite identificar registros con cambios locales que todavía no han sido enviados a un servidor.

No se implementó una sincronización real con un servidor.

## 5. Estructura del proyecto

```text
practica_06_persistencia/
│
├── lib/
│   ├── database/
│   │   └── db.dart
│   │
│   ├── models/
│   │   └── tarea.dart
│   │
│   ├── services/
│   │   └── preferencias_service.dart
│   │
│   ├── screens/
│   │   └── tareas_screen.dart
│   │
│   └── main.dart
│
├── test/
│   └── widget_test.dart
│
├── web/
│   ├── index.html
│   ├── sqflite_sw.js
│   └── sqlite3.wasm
│
├── docs/
│   └── evidencias/
│       └── practica-06/
│
├── pubspec.yaml
└── README.md
```

## 6. Requisitos de instalación

Para ejecutar el proyecto se necesita:

- Flutter SDK.
- Dart SDK.
- Visual Studio Code.
- Microsoft Edge.
- Git.

## 7. Instalación y ejecución

Clonar el repositorio:

```bash
git clone URL_DEL_REPOSITORIO
```

Entrar en la carpeta:

```bash
cd practica_06_persistencia
```

Instalar las dependencias:

```bash
flutter pub get
```

Si es necesario regenerar los recursos de SQLite Web:

```bash
dart run sqflite_common_ffi_web:setup
```

Ejecutar la aplicación en Microsoft Edge:

```bash
flutter run -d edge --web-port 8080
```

## 8. Pruebas realizadas

Se realizaron las siguientes comprobaciones:

- Creación de tareas.
- Consulta de registros.
- Actualización de tareas.
- Eliminación de registros.
- Cambio del estado de las tareas.
- Guardado del nombre del usuario.
- Persistencia de información después de recargar Edge.
- Creación de tareas con el navegador configurado en modo offline.

### Verificación del código

Se ejecutaron los siguientes comandos:

```bash
dart format lib test
flutter analyze
flutter test
```

**Resultados obtenidos:**

- `flutter analyze`: No issues found!
- `flutter test`: All tests passed!
- Pruebas automatizadas del modelo: 3 pruebas aprobadas.
- Persistencia local: Comprobada.
- Creación de tareas sin conexión: Comprobada manualmente.

## 9. Evidencias

Las capturas de pantalla de la aplicación y las pruebas realizadas se almacenarán en:

```text
docs/evidencias/practica-06/
```

## 10. Entrega en GitHub

La práctica se publicará en la rama:

```text
practica-06-persistencia
```

Se realizará una Pull Request hacia la rama `develop`, incluyendo la descripción de las funcionalidades implementadas, las pruebas realizadas y las evidencias correspondientes.

**URL del Pull Request:** Pendiente.

**URL del commit final:** Pendiente.

## 11. Conclusión

Mediante esta práctica se implementó una aplicación de gestión de tareas utilizando Flutter, SQLite y SharedPreferences.

Se comprendió cómo almacenar registros estructurados, realizar operaciones CRUD y conservar preferencias del usuario en almacenamiento local.

Además, se comprobó que la aplicación puede continuar administrando tareas sin conexión a Internet, cumpliendo con el objetivo de persistencia local y funcionamiento offline.