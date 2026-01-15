# 📋 PLAN DETALLADO FASE 2: AUTENTICACIÓN CON FIREBASE

## 🎯 Objetivo de Fase 2
Implementar sistema completo de autenticación con Firebase Auth, incluyendo modelos, datasources, repositorios, casos de uso, y pantallas de login/registro.

---

## 📊 ESTRUCTURA DEL PLAN

### MÓDULO 1: Modelos y Entidades (Checkpoint 1)
**Objetivo:** Definir estructura de datos para usuarios  
**Tiempo estimado:** 1 día  
**Rama:** `feature/auth-models`

#### Tareas:
- [ ] Crear `UserEntity` en `domain/entities/user_entity.dart`
  - Propiedades: id, email, nombre, photoUrl, createdAt, updatedAt
  - Constructor con parámetros nombrados
  - Métodos copyWith()

- [ ] Crear `UserModel` en `data/models/user_model.dart`
  - Heredar de UserEntity
  - Métodos toJson() y fromJson()
  - Serialización JSON para Firebase

- [ ] Crear `AuthState` en `domain/entities/auth_state.dart`
  - Estados: unauthenticated, loading, authenticated, error
  - Manejo de errores

- [ ] Tests unitarios
  - Test de serialización UserModel

#### ✅ Commit esperado:
```
feat: Crear modelos y entidades de usuario para autenticación
- UserEntity en domain/entities
- UserModel con serialización JSON
- AuthState para gestionar estados
```

---

### MÓDULO 2: Datasources (Checkpoint 2)
**Objetivo:** Implementar fuentes de datos (Firebase y almacenamiento local)  
**Tiempo estimado:** 2 días  
**Rama:** `feature/auth-datasources`

#### Tareas:

**2.1 - Datasource Remoto (Firebase)**
- [ ] Crear interfaz `AuthRemoteDataSource` en `data/datasources/auth_remote_datasource.dart`
  - Método: `Future<UserModel> register(email, password, name)`
  - Método: `Future<UserModel> login(email, password)`
  - Método: `Future<void> logout()`
  - Método: `Future<UserModel?> getCurrentUser()`
  - Método: `Future<void> resetPassword(email)`

- [ ] Implementar `AuthRemoteDataSourceImpl`
  - Usar FirebaseAuth para autenticación
  - Usar Firestore para datos del usuario
  - Manejo de errores Firebase → AppException

**2.2 - Datasource Local**
- [ ] Crear interfaz `AuthLocalDataSource` en `data/datasources/auth_local_datasource.dart`
  - Método: `Future<void> saveUserToken(token)`
  - Método: `Future<String?> getUserToken()`
  - Método: `Future<void> clearUserToken()`
  - Método: `Future<void> saveUser(user)`
  - Método: `Future<UserModel?> getCachedUser()`

- [ ] Implementar `AuthLocalDataSourceImpl`
  - Usar SharedPreferences para tokens
  - Usar Hive para usuario caché
  - Serialización/deserialización

#### ✅ Commit esperado:
```
feat: Implementar datasources de autenticación
- AuthRemoteDataSource con Firebase Auth y Firestore
- AuthLocalDataSource con SharedPreferences y Hive
- Manejo robusto de errores
```

---

### MÓDULO 3: Repositories (Checkpoint 3)
**Objetivo:** Implementar lógica de negocio central  
**Tiempo estimado:** 2 días  
**Rama:** `feature/auth-repositories`

#### Tareas:

**3.1 - Interfaz del Repositorio**
- [ ] Crear `AuthRepository` en `domain/repositories/auth_repository.dart`
  - Métodos usando Either<Failure, Success>
  - Métodos: register, login, logout, getCurrentUser, resetPassword

**3.2 - Implementación del Repositorio**
- [ ] Crear `AuthRepositoryImpl` en `data/repositories/auth_repository_impl.dart`
  - Integrar datasources remoto y local
  - Convertir UserModel → UserEntity
  - Manejo de excepciones → fallos
  - Lógica de fallback (local si falla remoto)

**3.3 - Manejo de Errores**
- [ ] Crear función `_handleException()` para mapeo de errores
  - FirebaseAuthException → AuthFailure
  - Excepciones generales → UnknownFailure

#### ✅ Commit esperado:
```
feat: Crear repositories de autenticación
- AuthRepository interfaz en domain
- AuthRepositoryImpl con manejo de errores
- Integración datasources remoto/local
- Convertidor UserModel a UserEntity
```

---

### MÓDULO 4: Casos de Uso (Checkpoint 4)
**Objetivo:** Definir acciones de negocio específicas  
**Tiempo estimado:** 1 día  
**Rama:** `feature/auth-usecases`

#### Tareas:

- [ ] Crear `RegisterUseCase` en `domain/usecases/register_usecase.dart`
  - Parámetro: RegisterParams(email, password, name)
  - Retorna: Either<Failure, UserEntity>

- [ ] Crear `LoginUseCase` en `domain/usecases/login_usecase.dart`
  - Parámetro: LoginParams(email, password)
  - Retorna: Either<Failure, UserEntity>

- [ ] Crear `LogoutUseCase` en `domain/usecases/logout_usecase.dart`
  - Parámetro: NoParams
  - Retorna: Either<Failure, void>

- [ ] Crear `GetCurrentUserUseCase` en `domain/usecases/get_current_user_usecase.dart`
  - Retorna: Either<Failure, UserEntity>

- [ ] Crear `ResetPasswordUseCase` en `domain/usecases/reset_password_usecase.dart`
  - Parámetro: email
  - Retorna: Either<Failure, void>

- [ ] Tests unitarios para usecases
  - Mockear repositories
  - Verificar casos de éxito y error

#### ✅ Commit esperado:
```
feat: Crear casos de uso de autenticación
- RegisterUseCase, LoginUseCase, LogoutUseCase
- GetCurrentUserUseCase, ResetPasswordUseCase
- Tests unitarios para cada usecase
```

---

### MÓDULO 5: Providers Riverpod (Checkpoint 5)
**Objetivo:** Implementar estado global con Riverpod  
**Tiempo estimado:** 1.5 días  
**Rama:** `feature/auth-providers`

#### Tareas:

- [ ] Crear `auth_provider.dart` en `presentation/providers/`
  - Provider para cada usecase
  - StateNotifierProvider para estado actual

- [ ] Crear `AuthNotifier` (StateNotifier)
  - Estado: AsyncValue<UserEntity>
  - Métodos: register, login, logout, getCurrentUser, resetPassword

- [ ] Crear providers selectores
  - `isAuthenticatedProvider` - bool
  - `currentUserProvider` - UserEntity?
  - `authStateProvider` - AsyncValue<UserEntity>

- [ ] Tests para providers
  - Verificar cambios de estado
  - Mockear datasources

#### ✅ Commit esperado:
```
feat: Implementar providers de Riverpod para autenticación
- AuthNotifier para gestionar estado
- Providers para usecases
- Providers selectores para UI
```

---

### MÓDULO 6: Validadores y Utilidades (Checkpoint 6)
**Objetivo:** Crear validaciones reutilizables  
**Tiempo estimado:** 1 día  
**Rama:** `feature/auth-validators`

#### Tareas:

- [ ] Crear `auth_validators.dart` en `core/validators/`
  - Función validateEmail(String email) → String? (null = válido)
  - Función validatePassword(String password) → String? 
    - Mínimo 8 caracteres
    - Al menos 1 mayúscula
    - Al menos 1 número
  - Función validateName(String name) → String?
  - Función validateConfirmPassword(String pwd1, pwd2) → String?

- [ ] Crear `password_strength.dart` en `core/utils/`
  - Enum: weak, fair, good, strong
  - Función getPasswordStrength(password) → PasswordStrength

- [ ] Tests para validadores

#### ✅ Commit esperado:
```
feat: Agregar validadores y utilidades de autenticación
- Validadores para email, contraseña, nombre
- Cálculo de fuerza de contraseña
- Tests de validación
```

---

### MÓDULO 7: Interfaz de Usuario (Checkpoint 7)
**Objetivo:** Crear pantallas de autenticación  
**Tiempo estimado:** 3 días  
**Rama:** `feature/auth-ui`

#### Tareas:

**7.1 - Widgets Reutilizables**
- [ ] Crear `auth_text_field.dart` en `presentation/widgets/`
  - TextField personalizado con validación
  - Iconos y manejo de visibilidad (password)

- [ ] Crear `password_strength_indicator.dart`
  - Barra de fuerza de contraseña
  - Colores según nivel

- [ ] Crear `auth_button.dart`
  - Botón personalizado con loading

**7.2 - Pantalla de Login**
- [ ] Crear `login_page.dart` en `presentation/pages/`
  - Form con email y password
  - Botón de login
  - Link a registro
  - Link "¿Olvidaste contraseña?"
  - Manejo de errores
  - Validación en tiempo real

- [ ] Crear `login_form.dart`
  - Widget separado del formulario

**7.3 - Pantalla de Registro**
- [ ] Crear `register_page.dart` en `presentation/pages/`
  - Form: nombre, email, password, confirmar password
  - Indicador de fuerza de contraseña
  - Términos y condiciones (checkbox)
  - Botón de registro
  - Validación en tiempo real

- [ ] Crear `register_form.dart`

**7.4 - Pantalla de Reset Password**
- [ ] Crear `reset_password_page.dart`
  - Input de email
  - Botón enviar instrucciones
  - Mensaje de confirmación

**7.5 - Navegación**
- [ ] Crear `auth_navigation.dart` o actualizar main.dart
  - Navegar entre login/registro
  - Navegar a home después de login

#### ✅ Commit esperado:
```
feat: Crear interfaz de usuario para autenticación
- Widgets reutilizables (TextField, Button, Indicator)
- Pantalla de Login con validación
- Pantalla de Registro
- Pantalla de Reset Password
- Manejo de navegación
```

---

### MÓDULO 8: Integración y Testing (Checkpoint 8)
**Objetivo:** Tests e integración final  
**Tiempo estimado:** 2 días  
**Rama:** `feature/auth-testing`

#### Tareas:

**8.1 - Tests Unitarios**
- [ ] Tests para AuthRepositoryImpl
  - Mock datasources
  - Verificar registro
  - Verificar login
  - Verificar logout

- [ ] Tests para Usecases
  - Verificar parámetros
  - Verificar retornos

- [ ] Tests para Validators
  - Emails válidos/inválidos
  - Passwords válidas/inválidas

**8.2 - Tests de Widgets**
- [ ] Test para LoginPage
  - Renderiza correctamente
  - Valida formulario
  - Llama a provider de login

- [ ] Test para RegisterPage

**8.3 - Documentación**
- [ ] Actualizar comentarios en código
- [ ] Documentar flujo de autenticación

#### ✅ Commit esperado:
```
test: Agregar tests unitarios e integración
- Tests para repositories y usecases
- Tests para validadores
- Tests de widgets de autenticación
- Documentación del flujo
```

---

## 📈 RESUMEN DE CHECKPOINTS

| # | Checkpoint | Tareas | Commits | Días | Estado |
|---|-----------|--------|---------|------|--------|
| 1 | Modelos | 4 | 1 | 1 | ⏳ |
| 2 | Datasources | 6 | 1 | 2 | ⏳ |
| 3 | Repositories | 5 | 1 | 2 | ⏳ |
| 4 | Usecases | 6 | 1 | 1 | ⏳ |
| 5 | Providers | 4 | 1 | 1.5 | ⏳ |
| 6 | Validadores | 4 | 1 | 1 | ⏳ |
| 7 | Interfaz UI | 11 | 1 | 3 | ⏳ |
| 8 | Testing | 7 | 1 | 2 | ⏳ |

**Total:** 47 tareas | **8 commits** | **13-14 días**

---

## 🔄 FLUJO DE TRABAJO

### Por cada Checkpoint:

1. **Crear rama**
   ```bash
   git checkout develop
   git checkout -b feature/auth-[nombre]
   ```

2. **Completar tareas** de ese checkpoint

3. **Verificar checklist** - todas las tareas ✓

4. **Hacer commit**
   ```bash
   git add .
   git commit -m "feat: [descripción en español]"
   ```

5. **Subir rama**
   ```bash
   git push origin feature/auth-[nombre]
   ```

6. **Crear PR en GitHub** desde feature/ a develop

7. **Revisar y mergear** en GitHub

8. **Actualizar local**
   ```bash
   git checkout develop
   git pull origin develop
   ```

9. **Siguiente checkpoint**

---

## 📝 TEMPLATE PARA COMMITS

```
feat: [descripción breve]

- Punto 1 de lo hecho
- Punto 2
- Punto 3

Closes: #[numero-issue-si-existe]
```

Ejemplo:
```
feat: Crear modelos y entidades de usuario

- Crear UserEntity en domain/entities
- Crear UserModel con serialización JSON
- Crear AuthState para gestionar estados
- Agregar tests unitarios
```

---

## ✅ CHECKLIST GENERAL FASE 2

- [ ] Checkpoint 1: Modelos ✓
- [ ] Checkpoint 2: Datasources ✓
- [ ] Checkpoint 3: Repositories ✓
- [ ] Checkpoint 4: Usecases ✓
- [ ] Checkpoint 5: Providers ✓
- [ ] Checkpoint 6: Validadores ✓
- [ ] Checkpoint 7: UI ✓
- [ ] Checkpoint 8: Testing ✓
- [ ] Documentación actualizada
- [ ] Todos los tests pasando
- [ ] Versión bumped en pubspec.yaml
- [ ] PR final a main listo

---

## 🚀 CÓMO INICIAR

1. Leer este documento completamente
2. Empezar con **Checkpoint 1: Modelos**
3. Seguir el orden de checkpoints
4. Marcar tareas completadas ✓
5. Hacer un commit al final de cada checkpoint
6. Verificar antes de pasar al siguiente

¡Buena suerte! 🎯
