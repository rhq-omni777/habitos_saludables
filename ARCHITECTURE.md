# Hábitos Saludables - Aplicación Móvil

Una aplicación móvil profesional desarrollada con **Flutter** para el seguimiento y mejora de hábitos saludables en actividades diarias, con integración a **Firebase** para autenticación y almacenamiento de datos en la nube.

## 📋 Descripción del Proyecto

Esta aplicación de titulación permite a los usuarios:
- Registrarse y autenticarse con Firebase
- Crear y gestionar hábitos personalizados
- Realizar seguimiento diario de actividades
- Visualizar progreso con gráficos y estadísticas
- Recibir notificaciones de recordatorio
- Sincronizar datos en la nube

## 🎯 Objetivos

- Desarrollar una aplicación móvil multiplataforma (Android/iOS)
- Implementar autenticación y gestión de usuarios con Firebase
- Crear sistema de seguimiento de hábitos robusto
- Aplicar arquitectura limpia y patrones de diseño profesionales
- Integración con base de datos en tiempo real (Firestore)

## 🏗️ Arquitectura

El proyecto sigue una **arquitectura limpia con separación de responsabilidades**:

```
lib/
├── config/              # Configuración global
│   ├── theme/          # Temas y estilos de la app
│   └── firebase/       # Inicialización de Firebase
├── core/               # Lógica compartida
│   ├── constants/      # Constantes globales
│   ├── errors/         # Definición de excepciones y fallos
│   └── extensions/     # Extensiones de tipos
├── data/               # Capa de datos
│   ├── datasources/    # Fuentes de datos (API, local)
│   ├── models/         # Modelos de datos
│   └── repositories/   # Implementación de repositorios
├── domain/             # Lógica de negocio (independiente de UI)
│   ├── entities/       # Entidades del negocio
│   ├── repositories/   # Interfaces de repositorios
│   └── usecases/       # Casos de uso
├── presentation/       # Capa de presentación
│   ├── pages/          # Pantallas/páginas
│   ├── widgets/        # Componentes reutilizables
│   └── providers/      # Estado (Riverpod)
└── utils/              # Utilidades varias
```

## 🛠️ Tecnologías Utilizadas

### Backend & Base de Datos
- **Firebase Core** - Plataforma de Firebase
- **Firebase Authentication** - Autenticación de usuarios
- **Cloud Firestore** - Base de datos en tiempo real
- **Firebase Storage** - Almacenamiento de archivos

### Frontend & UI
- **Flutter 3.24.5** - Framework para desarrollo multiplataforma
- **Material Design 3** - Diseño de interfaz
- **Google Fonts** - Tipografías

### State Management & Arquitectura
- **Riverpod** - Gestión de estado y inyección de dependencias
- **Dartz** - Functional programming (Either, Task)
- **GetIt** - Service Locator

### Funcionalidades Adicionales
- **Local Notifications** - Notificaciones locales
- **Shared Preferences** - Almacenamiento local
- **Hive** - Base de datos local
- **Dio** - Cliente HTTP
- **Connectivity Plus** - Detección de conectividad
- **Device Info Plus** - Información del dispositivo

## 📦 Dependencias Principales

```yaml
# Firebase
firebase_core: ^3.8.0
firebase_auth: ^5.3.0
cloud_firestore: ^5.4.0
firebase_storage: ^12.3.0

# State Management
riverpod: ^2.6.1
flutter_riverpod: ^2.6.1

# UI
google_fonts: ^6.2.1
flutter_svg: ^2.0.10

# Storage
shared_preferences: ^2.3.2
hive: ^2.2.3
hive_flutter: ^1.1.0
```

## 🚀 Configuración del Proyecto

### Requisitos Previos
- Flutter SDK 3.5.4 o superior
- Dart 3.5.4 o superior
- Android Studio o Xcode (para emuladores)
- Cuenta de Google (para Firebase)

### Instalación

1. **Clonar el repositorio**
```bash
git clone https://github.com/tu-usuario/habitos_saludables.git
cd habitos_saludables
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Configurar Firebase**
   - Crear proyecto en [Firebase Console](https://console.firebase.google.com)
   - Descargar `google-services.json` (Android)
   - Descargar `GoogleService-Info.plist` (iOS)
   - Colocar los archivos en sus respectivas carpetas

4. **Ejecutar el proyecto**
```bash
flutter run
```

## 📱 Estructura de Ramas Git

```
main/
├── develop                    # Rama de desarrollo
│   ├── feature/auth          # Autenticación
│   ├── feature/habits        # Gestión de hábitos
│   ├── feature/tracking      # Seguimiento
│   └── feature/analytics     # Gráficos y estadísticas
└── release/v1.0.0            # Releases
```

## 🔄 Flujo de Trabajo

1. **Feature Branch** desde `develop`
2. **Pull Request** con revisión
3. **Merge** a `develop`
4. **Testing** en staging
5. **Release** a `main` con versión

## 📝 Commits y Versioning

Seguimos **Semantic Versioning (SemVer)**:
- **MAJOR**: Cambios incompatibles (1.0.0)
- **MINOR**: Nuevas funcionalidades (1.1.0)
- **PATCH**: Correcciones de bugs (1.0.1)

## 📊 Fases del Desarrollo

### Fase 1: Setup Inicial (Actual)
- ✅ Instalación de Flutter
- ✅ Creación de estructura de proyecto
- ✅ Configuración de dependencias
- ⏳ Primer commit al repositorio

### Fase 2: Autenticación
- [ ] Registro de usuarios
- [ ] Login con email/contraseña
- [ ] Recuperación de contraseña
- [ ] Perfil de usuario

### Fase 3: Core de Hábitos
- [ ] CRUD de hábitos
- [ ] Categorización
- [ ] Seguimiento diario
- [ ] Historial

### Fase 4: UI/UX Profesional
- [ ] Dashboard principal
- [ ] Gráficos de progreso
- [ ] Diseño responsivo
- [ ] Animaciones

### Fase 5: Notificaciones y Extras
- [ ] Push notifications
- [ ] Analytics
- [ ] Exportación de datos
- [ ] Compartir logros

## 🧪 Testing

```bash
# Ejecutar pruebas unitarias
flutter test

# Ejecutar pruebas de integración
flutter test integration_test

# Cobertura de código
flutter test --coverage
```

## 📄 Licencia

Este proyecto es parte del trabajo de titulación.

## 👤 Autor

- **Nombre**: [Tu Nombre]
- **Universidad**: [Tu Universidad]
- **Correo**: [tu-email@ejemplo.com]

## 📞 Soporte

Para consultas o reportar bugs, contactar a través de las issues del repositorio.

---

**Última actualización**: Enero 2026
**Versión**: 1.0.0-alpha
