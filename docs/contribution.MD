# Reglas de Contribución
En este documento se definen las reglas de trabajo con Git y GitHub para el equipo de desarrollo. Se busca mantener un repositorio ordenado, evitar conflictos y asegurar la calidad del código antes de integrarlo.

## Flujo de Ramas
El flujo oficial del proyecto es: **`feature/*` $\rightarrow$ `develop` $\rightarrow$ `main`**.

- **`main`**: Rama de código estable en producción (Nadie hace `push` directo a esta rama).
- **`develop`**: Rama base de desarrollo donde se integran las funcionalidades terminadas (gestionado por líder).
- **`feature/*`**: Ramas de trabajo para cualquier nueva pantalla, componente o corrección (gestionado por desarrolladores).

## Nombres de Ramas
- Usar `kebab-case` (en caso de requerirse).
- Las únicas ramas permitidas son:
  - `main`
  - `develop`
  - `feature/nombre-tarea` (ej. `feature/login-screen`, `feature/registro`, etc).

## Mensajes de Commit
- Describir claramente qué se hizo en tiempo presente.
- Evitar mensajes vagos como `funciones agregadas`, `cambios`, ``,.
- Los commits deben ser atómicos (un solo cambio puntual por commit) y deben seguir el siguiente formato:
  - `tipo (alcance opcional): descripción breve` 
  Ej. `feat (auth): agregar pantalla de login` o `fix (storage): corregir guardado de token en sesión`.

### Tipos de commit permitidos:
| Tipo | Uso | Ejemplo |
| :--- | :--- | :--- |
| **`feat`** | Añade una nueva funcionalidad o pantalla. | `feat(auth): añadir inicio de sesión con Google` |
| **`fix`** | Soluciona un error o bug en el código. | `fix(cart): corregir cálculo de total` |
| **`chore`** | Tareas de mantenimiento, dependencias o configuración. | `chore: actualizar dependencias en pubspec.yaml` |
| **`docs`** | Cambios exclusivos en la documentación. | `docs: actualizar reglas de contribución` |
| **`style`** | Cambios de formato (espacios, comas, indentación) que no alteran la lógica. | `style: aplicar formato con trailing commas` |
| **`refactor`** | Cambios en el código que reestructuran o limpian sin añadir funcionalidad ni corregir bugs. | `refactor(core): extraer widgets a clases independientes` |
| **`perf`** | Cambios de código diseñados para optimizar el rendimiento. | `perf: optimizar renderizado de lista de productos` |
| **`test`** | Añadir o corregir pruebas unitarias o de widgets. | `test: agregar prueba de login_screen` |
| **`build`** | Cambios que afectan la compilación o empaquetado del proyecto. | `build: actualizar configuración de gradle` |
| **`revert`** | Revierte un commit anterior. | `revert: revertir feat(auth): login con Google` |


## Flujo de Trabajo Diario

### Para Desarrolladores:

1. **Actualizar la rama base antes de empezar**:
   ```bash
   git switch develop
   git pull origin develop
   ```

2. **Crear tu rama de trabajo a partir de `develop`**:
   ```bash
   git switch -c feature/nombre-tarea
   ```

3. **Hacer commits pequeños y atómicos mientras avanzas**:
   ```bash
   git status                     # Ver qué archivos cambiaron
   git add <archivo>              # Seleccionar archivos para el commit
   git commit -m "tipo (alcance opcional): descripción breve"
   ```
   **Nota**: `git restore --staged <archivo>`: Deshace la selección de archivos para el próximo commit, manteniendo los cambios en el directorio de trabajo.

4. **Sincronizar con `develop` antes de subir** (trae lo que otros ya integraron y evita conflictos en el PR):
   ```bash
   git pull origin develop
   ```
   Si aparecen conflictos, resolverlos en el editor, luego:
   ```bash
   git add <archivo>
   git commit
   ```

5. **Subir tu rama a GitHub**:
   ```bash
   git push -u origin feature/nombre-tarea
   ```
   - `-u` solo se usa la primera vez; enlaza tu rama local con la remota. Después basta con `git push`.
   - Al terminar, la terminal muestra un enlace como este:
     ```
     remote: Create a pull request for 'feature/nombre-tarea' on GitHub by visiting:
     remote:   https://github.com/ids-ulv-desarrollo/colportando/pull/new/feature/nombre-tarea
     ```

6. **Abrir el Pull Request (PR) hacia `develop`**:
   1. Abrir el enlace que mostró la terminal, o entrar al repositorio en GitHub y pulsar el botón amarillo **"Compare & pull request"** que aparece arriba.
   2. Verificar las ramas en la parte superior:
      - **base:** `develop` ← **compare:** `feature/nombre-tarea`
      > **Importante:** Por defecto GitHub propone `main` como base. Cambiarlo siempre a `develop`.
   3. Escribir el título y la descripción según las [Reglas de Pull Requests](#reglas-de-pull-requests).
   4. En el panel derecho, en **Reviewers**, seleccionar al líder.
   5. Pulsar **"Create pull request"**.

7. **Atender la revisión** (si el líder solicita cambios):
   - Hacer las correcciones en la **misma rama** y subirlas; el PR se actualiza automáticamente:
     ```bash
     git add <archivo>
     git commit -m "fix (alcance): corregir observaciones de revisión"
     git push
     ```
   - **No** crear un PR nuevo por cada corrección.

8. **Después de que el PR sea fusionado**, volver a `develop` y actualizar:
   ```bash
   git switch develop
   git pull origin develop
   git fetch --prune
   ```
   **Nota**: `git fetch --prune`: Descarga las referencias del repositorio remoto y elimina las referencias locales (`origin/...`) de ramas que ya no existen en GitHub. No borra tus ramas locales.

   Para la siguiente tarea, repetir desde el paso 2 con una rama nueva.

Nota: No se debe borrar la rama una vez fusionada, ya que sirve de registro / historial.

### Para el Líder:

1. **Revisar un PR hacia `develop`**:
   - En GitHub, abrir el PR → pestaña **"Files changed"** para revisar el código.
   - Pulsar **"Review changes"** y elegir:
     - **Approve**: si todo está correcto.
     - **Request changes**: si hay que corregir algo (dejar comentarios en las líneas).
   - Una vez aprobado, pulsar **"Merge pull request"** → **"Confirm merge"**.

2. **Publicar una versión estable (`develop` → `main`)**:
   - En GitHub: **Pull requests → New pull request**.
   - Seleccionar **base:** `main` ← **compare:** `develop`.
   - Título sugerido: `[Release] vX.Y.Z` y una lista de los cambios incluidos.
   - Crear y fusionar el PR.

3. **Actualizar `main` localmente**:
   ```bash
   git switch main
   git pull origin main
   ```


## Roles en el Flujo de Trabajo

| Rol | Responsabilidad en Git |
| :--- | :--- |
| **Desarrollador** | Trabaja exclusivamente en ramas `feature/*`. Sube sus cambios y solicita Pull Request hacia `develop`. No realiza merge directo a `develop`. |
| **Líder** | Revisa y aprueba los Pull Requests hacia `develop`. Cuando una versión está completa y probada en `develop`, realiza el Pull Request / merge desde `develop` hacia `main`. |


## Reglas de Pull Requests

- **Destino del PR**: Todo PR debe apuntar a la rama **`develop`** (nunca directo a `main`).
- **Título claro**: Debe resumir lo que contiene (ej. `[Feature] Pantalla de inicio de sesión`).
- **Descripción**:
  - Explicar brevemente qué se implementó o corrigió.
  - Si es un cambio visual (UI), adjuntar una captura de pantalla o GIF de cómo se ve en móvil o web.
- **Requisitos antes de solicitar revisión**:
  - Comprobar que el proyecto compila localmente sin errores (`flutter run` o `npm run dev`, según sea para flutter o web).
  - Asegurar que no hay errores de linter (`flutter analyze` o `npm run lint`).
- **Aprobaciones necesarias**:
  - Se requiere al menos **1 aprobación** antes de hacer merge.
  - Prohibido hacer merge sin revisión.
