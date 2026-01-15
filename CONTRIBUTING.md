# Guía de Contribución

## 🎯 Objetivo

Mantener un código limpio, consistente y bien documentado.

## 📋 Estándares de Código

### Naming Conventions
- **Classes**: PascalCase (ej: `UserRepository`)
- **Variables/Functions**: camelCase (ej: `getUserData()`)
- **Constants**: UPPER_SNAKE_CASE (ej: `MAX_ATTEMPTS`)
- **Files**: snake_case (ej: `user_repository.dart`)

### Estructura de Archivos
- Un componente por archivo
- Archivos pequeños y enfocados
- Nombres descriptivos

## 🔄 Flujo de Git

### Ramas
- `main` - Producción
- `develop` - Desarrollo activo
- `feature/[nombre]` - Nuevas funcionalidades
- `bugfix/[nombre]` - Correcciones de bugs
- `hotfix/[nombre]` - Hotfixes para producción

### Commits
```
feat: Agregar nueva funcionalidad
fix: Corregir bug específico
docs: Actualizar documentación
refactor: Reorganizar código
test: Agregar tests
chore: Tareas de mantenimiento
```

### Pull Requests
1. Crear desde `feature/` a `develop`
2. Descripciones claras
3. Al menos 1 review
4. Tests pasando
5. Merge + delete branch

## 🧪 Testing

- Escribir tests unitarios para lógica de negocio
- Escribir tests de widgets para UI crítica
- Mantener cobertura > 70%

```bash
flutter test
```

## 📝 Documentación

- Documentar funciones públicas con `///`
- Incluir ejemplos en documentación
- Mantener README actualizado

## 🚀 Proceso de Deploy

1. Crear rama `release/v1.0.0`
2. Actualizar versión en `pubspec.yaml`
3. Actualizar `CHANGELOG.md`
4. PR a `main`
5. Tag en Git
6. Build de release

## ✅ Checklist Antes de PR

- [ ] Código sigue convenciones
- [ ] Tests pasan
- [ ] No hay warnings
- [ ] Documentación actualizada
- [ ] Cambios en CHANGELOG
- [ ] No hay archivos sin usar

¡Gracias por contribuir! 🙏
