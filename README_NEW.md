# 🏥 Hábitos Saludables - Aplicación Móvil

[![Flutter](https://img.shields.io/badge/Flutter-v3.24.5-blue)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.5.4-blue)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green)]()
[![Status](https://img.shields.io/badge/Status-Development-yellow)]()

Una aplicación móvil desarrollada con **Flutter** para mejorar el seguimiento de hábitos saludables en actividades diarias, integrando **Firebase** para autenticación y almacenamiento en la nube.

## 📚 Contenido

- 🚀 [Inicio Rápido](#inicio-rápido)
- 🏗️ [Arquitectura](#arquitectura)
- 📦 [Instalación](#instalación)
- 🔄 [Flujo de Trabajo](#flujo-de-trabajo)
- 📖 [Documentación](#documentación)

## 🚀 Inicio Rápido

```bash
# Clonar repositorio
git clone https://github.com/tu-usuario/habitos_saludables.git
cd habitos_saludables

# Instalar dependencias
flutter pub get

# Ejecutar aplicación
flutter run
```

## 🏗️ Arquitectura

Este proyecto implementa una **arquitectura limpia** siguiendo los principios SOLID:

```
lib/
├── config/          # Configuración (temas, Firebase)
├── core/            # Lógica compartida (constantes, errores, extensiones)
├── data/            # Capa de datos (datasources, models, repositories)
├── domain/          # Lógica de negocio (entities, repositories, usecases)
├── presentation/    # Interfaz de usuario (pages, widgets, providers)
└── utils/           # Utilidades varias
```

Para más detalles, consulta [ARCHITECTURE.md](ARCHITECTURE.md)

## 📦 Instalación

### Requisitos
- Flutter 3.5.4+
- Dart 3.5.4+
- Android Studio / Xcode
- Cuenta Firebase

### Pasos

1. **Instalación de dependencias**
```bash
flutter pub get
```

2. **Configurar Firebase**
   - Crear proyecto en [Firebase Console](https://console.firebase.google.com)
   - Descargar configuración (google-services.json / GoogleService-Info.plist)
   - Colocar en carpetas correspondientes

3. **Ejecutar**
```bash
flutter run
```

## 🔄 Flujo de Trabajo

### Ramas Git
- `main` - Producción
- `develop` - Desarrollo
- `feature/*` - Nuevas funcionalidades
- `bugfix/*` - Correcciones

### Proceso
1. Crear rama desde `develop`
2. Hacer cambios y commits
3. Pull Request a `develop`
4. Merge tras revisión

## 🛠️ Tecnologías

| Categoría | Tecnología |
|-----------|-----------|
| Backend | Firebase (Auth, Firestore, Storage) |
| Frontend | Flutter + Material Design 3 |
| State | Riverpod |
| Local Storage | Shared Preferences + Hive |
| HTTP | Dio |

## 📊 Fases

- ✅ **Fase 1**: Setup inicial y estructura
- 🔄 **Fase 2**: Autenticación
- ⏳ **Fase 3**: Core de hábitos
- ⏳ **Fase 4**: UI/UX profesional
- ⏳ **Fase 5**: Notificaciones

## 📖 Documentación

- [Arquitectura Detallada](ARCHITECTURE.md)
- [Guía de Contribución](CONTRIBUTING.md)
- [API de Firebase](https://firebase.flutter.dev)

## 📝 License

MIT License - Proyecto de Titulación

## 👥 Autor

**Tu Nombre**  
Universidad - Año 2026
