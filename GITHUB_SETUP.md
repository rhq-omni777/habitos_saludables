# 📤 Guía: Subir Proyecto a GitHub

## Paso 1: Crear Repositorio en GitHub

1. Ir a [GitHub.com](https://github.com)
2. Haz clic en "New repository" (botón verde arriba a la derecha)
3. Rellena los datos:
   - **Repository name:** `habitos_saludables`
   - **Description:** "Aplicación móvil de hábitos saludables con Flutter y Firebase"
   - **Visibility:** Public (o Private según prefieras)
   - **README:** No selecciones (ya tenemos uno)
   - **gitignore:** No selecciones (ya lo tenemos)
   - **.gitignore template:** None

4. Haz clic en "Create repository"

## Paso 2: Conectar Repositorio Local con GitHub

Copia estos comandos en PowerShell (en la carpeta del proyecto):

```powershell
# Agregar repositorio remoto
git remote add origin https://github.com/TU_USUARIO/habitos_saludables.git

# Verificar la conexión
git remote -v

# Subir rama main
git branch -M main
git push -u origin main

# Subir rama develop
git push -u origin develop
```

**Nota:** Reemplaza `TU_USUARIO` con tu nombre de usuario de GitHub

## Paso 3: Verificar en GitHub

1. Recarga la página del repositorio
2. Deberías ver las dos ramas: `main` y `develop`
3. Verifica que los archivos se subieron correctamente

## Paso 4: Proteger Ramas (Opcional pero Recomendado)

1. Ve a "Settings" del repositorio
2. En la izquierda, selecciona "Branches"
3. Haz clic en "Add rule"

**Para rama `main`:**
- Branch name pattern: `main`
- Requiere pull request reviews: ✓
- Requiere aprobación: 1
- Descartar pull request si hay cambios: ✓

**Para rama `develop`:**
- Branch name pattern: `develop`
- Requiere pull request reviews: ✓
- Requiere aprobación: 1

## Paso 5: Clonar en otra máquina (si lo necesitas)

```powershell
git clone https://github.com/TU_USUARIO/habitos_saludables.git
cd habitos_saludables
git checkout develop
flutter pub get
```

## 🔑 Autenticación SSH (Opcional - Recomendado)

Si prefieres no ingresar usuario/contraseña cada vez:

1. Genera clave SSH:
```powershell
ssh-keygen -t ed25519 -C "tu-email@ejemplo.com"
```

2. Agrega a GitHub:
   - Ve a Settings → SSH and GPG keys
   - New SSH key
   - Copia el contenido de `~/.ssh/id_ed25519.pub`

3. Usa URL SSH en lugar de HTTPS:
```powershell
git remote set-url origin git@github.com:TU_USUARIO/habitos_saludables.git
```

## Flujo de Trabajo Diario

```bash
# Crear nueva rama para trabajar
git checkout develop
git checkout -b feature/autenticacion

# Hacer cambios y commits
git add .
git commit -m "feat: Agregar pantalla de login"

# Subir a GitHub
git push origin feature/autenticacion

# Crear Pull Request en GitHub (desde web)

# Después de revisión y merge
git checkout develop
git pull origin develop
```

## Comandos Git Útiles

```bash
# Ver estado
git status

# Ver ramas
git branch -a

# Ver commits
git log --oneline -10

# Subir cambios
git push origin develop

# Descargar cambios
git pull origin develop

# Ver cambios sin subir
git diff --stat

# Deshacer último commit
git reset --soft HEAD~1

# Cambiar a otra rama
git checkout nombre-rama
```

---

**¿Necesitas ayuda?** Consulta la [documentación de GitHub](https://docs.github.com/es)
