# 🎯 INSTRUCCIONES PARA LA PRÓXIMA SESIÓN

## Estado Actual

**Proyecto:** Hábitos Saludables  
**Fase Completada:** 1 (Setup Inicial)  
**Rama Activa:** `develop`  
**Versión:** 1.0.0-alpha  
**Commits:** 3

## ¿Qué se hizo en Fase 1?

✅ Instalación de Flutter 3.24.5  
✅ Creación de estructura profesional (Clean Architecture)  
✅ Configuración de 47 dependencias (Firebase, Riverpod, etc)  
✅ Creación de temas y extensiones  
✅ Documentación completa  
✅ Setup de Git con ramas develop y main  

## Para Retomar el Trabajo

### Paso 1: Abrir la carpeta del proyecto

```powershell
cd C:\FlutterProjects\habitos_saludables
```

### Paso 2: Verificar que estés en rama develop

```powershell
git status
# Debe mostrar: "On branch develop"

# Si no estás, cambia:
git checkout develop
```

### Paso 3: Instalar dependencias (si es necesario)

```powershell
flutter pub get
```

### Paso 4: Ejecutar la aplicación

```powershell
flutter run
```

## Plan para Fase 2: Autenticación

### Archivos a Crear

```
lib/
├── data/
│   ├── datasources/
│   │   ├── auth_local_datasource.dart
│   │   └── auth_remote_datasource.dart
│   ├── models/
│   │   └── user_model.dart
│   └── repositories/
│       └── auth_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── user_entity.dart
│   ├── repositories/
│   │   └── auth_repository.dart
│   └── usecases/
│       ├── login_usecase.dart
│       ├── register_usecase.dart
│       └── logout_usecase.dart
└── presentation/
    ├── pages/
    │   ├── auth_page.dart
    │   ├── login_page.dart
    │   └── register_page.dart
    ├── widgets/
    │   ├── auth_form.dart
    │   └── password_field.dart
    └── providers/
        └── auth_provider.dart
```

### Tareas de Fase 2

1. **Configurar Firebase**
   - Crear proyecto en Firebase Console
   - Descargar credenciales
   - Configurar en el proyecto

2. **Modelos y Entidades**
   - Crear `UserEntity` en domain
   - Crear `UserModel` en data
   - Implementar serialización JSON

3. **Datasources**
   - Crear interfaces en `auth_repository.dart`
   - Implementar `AuthRemoteDataSource` (Firebase)
   - Implementar `AuthLocalDataSource` (Shared Preferences)

4. **Repositories**
   - Implementar `AuthRepositoryImpl`
   - Manejo de errores
   - Convertir entre modelos y entidades

5. **Casos de Uso**
   - `LoginUseCase`
   - `RegisterUseCase`
   - `LogoutUseCase`
   - `GetCurrentUserUseCase`

6. **Providers (Riverpod)**
   - `authProvider` para estado actual
   - `authStateNotifierProvider` para cambios
   - `isAuthenticatedProvider` para verificar

7. **UI**
   - `LoginPage` con validaciones
   - `RegisterPage` con validaciones
   - `AuthForm` reutilizable
   - Flujo de navegación

8. **Testing**
   - Tests unitarios para usecases
   - Tests de widgets

### Commits Esperados

```
feat: Agregar Firebase configuration
feat: Crear domain models para autenticación
feat: Implementar datasources de autenticación
feat: Crear repositories de autenticación
feat: Crear casos de uso de autenticación
feat: Añadir providers de Riverpod
feat: Diseñar pantallas de login/registro
feat: Agregar validaciones y error handling
test: Agregar tests unitarios para auth
```

## Estructura de Ramas para Fase 2

```bash
git checkout develop
git checkout -b feature/auth-setup

# Trabajar en la rama...
# Hacer commits...

git push origin feature/auth-setup

# Luego en GitHub: hacer Pull Request a develop
# Después del merge:

git checkout develop
git pull origin develop
git checkout -b feature/auth-models
# ... y así sucesivamente
```

## Comandos Importantes para Recordar

```bash
# Ver estado del proyecto
git status

# Ver qué ramas hay
git branch -a

# Cambiar de rama
git checkout develop

# Crear nueva rama
git checkout -b feature/nombre

# Hacer commit
git add .
git commit -m "feat: descripción del cambio"

# Subir cambios
git push origin feature/nombre

# Descargar cambios
git pull origin develop

# Ver historial
git log --oneline -10
```

## Recursos Útiles

- 📖 [Flutter Docs](https://flutter.dev/docs)
- 🔥 [Firebase Docs](https://firebase.flutter.dev)
- 🌀 [Riverpod Guide](https://riverpod.dev)
- 🏗️ [Clean Architecture](https://resocoder.com/flutter-clean-architecture)
- 📝 [Archivo README.md](README.md) - Guía rápida
- 📚 [Archivo ARCHITECTURE.md](ARCHITECTURE.md) - Detalles técnicos

## Checklist Antes de Comenzar Fase 2

- [ ] Flutter funciona (`flutter run` sin errores)
- [ ] Git está configurado
- [ ] Tienes acceso a GitHub (crear repositorio si no lo hiciste)
- [ ] Firebase Console accesible
- [ ] VS Code con extensiones Flutter/Dart instaladas

## ¿Qué pasa si algo falla?

### Si Flutter no compila:
```bash
flutter clean
flutter pub get
flutter run
```

### Si hay conflictos de Git:
```bash
git status  # Ver qué hay en conflicto
# Editar archivos manualmente
git add .
git commit -m "fix: resolver conflictos"
```

### Si necesitas cambiar algo del setup:
```bash
# No commits hasta tener todo listo
git diff           # Ver cambios
git checkout .     # Deshacer si es necesario
```

---

**Nota Importante:** No hagas cambios directamente en `main`. Siempre trabaja en `develop` o en ramas `feature/*` desde `develop`.

**¡Éxito en la Fase 2!** 🚀
