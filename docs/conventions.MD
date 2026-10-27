# Convenciones de Desarrollo

En este documento se establecen las convenciones para el desarrollo del front-end en **Flutter (Mobile)** y **React (Web)**. Se busca la máxima estandarización entre ambas plataformas. **Todo el código debe estar en inglés a excepción de los comentarios.**

## Convenciones Generales

### Variables y Constantes
- Usar _camelCase para variables privadas.
- Usar camelCase para variables públicas.
- Usar _CONSTANT_CASE para constantes privadas.
- Usar CONSTANT_CASE para constantes públicas.
- Sus nombres deben representar su propósito de forma breve.
- Evitar el uso de abreviaturas y acrónimos.
- Si una variable o constante es de tipo bool, su nombre debe empezar con «is» o «has» (ej. isLoading, hasError).

### Funciones
- Usar _camelCase para funciones privadas.
- Usar camelCase para funciones públicas.
- El nombre debe iniciar con un verbo que describa la acción (ej. fetchData, submitForm).
- Usar el prefijo `on` para callbacks o propiedades de eventos (ej. onPressed, onClick) y `handle` o `_on` para las funciones que los procesan (ej. _handleLogin, handleSubmit).

### Clases
- Usar PascalCase para clases (abarca widgets y componentes).

### Archivos comunes
- Usar snake_case para los nombres de todos los archivos.
- Pantallas / Páginas: terminar con `_screen` (ej. `login_screen.dart`, `login_screen.tsx`).
- Servicios de red / APIs: terminar con `_service` (ej. `user_service.dart`, `user_service.ts`).
- Almacenamiento local / persistencia: terminar con `_storage` (ej. `token_storage.dart`, `token_storage.ts`).
- Manejo de excepciones / errores: terminar con `_handler` (ej. `error_handler.dart`, `error_handler.ts`).
- Modelos de datos / entidades: terminar con `_model` (ej. `user_model.dart`, `user_model.ts`).
- Temas, colores y diseño de la app: terminar con `_theme` (ej. `app_theme.dart`, `app_theme.ts`).

### Carpetas
- Usar lowercase para las carpetas.
- Describir el propósito de la carpeta en una sola palabra o término simple (ej. auth, core, ...).

### Comentarios
- Hacer comentarios de una línea.
- Los comentarios deben ser claros, concisos y en español.


## Flutter (Móvil)
En Flutter se utiliza la extensión `.dart`. El estado se gestiona mediante **Riverpod** (`Notifier` / `NotifierProvider`), o estado local efímero (`setState` / `StatefulWidget`).

### Archivos específicos
- Widgets base del sistema de diseño (`core/widgets/`): terminar con `_format.dart` (ej. `button_format.dart`, `dialog_format.dart`).
- Widgets exclusivos de una feature (`features/[feature]/presentation/widgets/`): terminar con `_widget.dart`.
- Gestión de estado: terminar con `_riverpod.dart` (ej. `auth_riverpod.dart`).

### Estructura de un widget
- Evitar crear métodos auxiliares que retornen widgets en cascada; extraer a `StatelessWidget` o `StatefulWidget` independientes.
- Usar `const` en constructores siempre que sea posible.
- Propiedades inmutables (`final`) y parámetros requeridos con `required`.
- Usar `setState` solo para estado visual simple y efímero; para lógica de negocio usar Riverpod.


## React (Web)
En React se utiliza la extensión .tsx para componentes visuales y .ts para lógica pura (servicios, modelos, utilidades).

### Archivos específicos
- Componentes reutilizables: terminar con `_component.tsx` (ej. `button_component.tsx`).
- Hooks personalizados: iniciar con `use_` (ej. `use_auth.ts`).

### Estructura de un componente
- Evitar componentes gigantes: extraer partes visuales a subcomponentes independientes.
- Usar componentes funcionales.
- Usar `interface Props` para definir los parámetros que recibe el componente (equivalente al constructor en Flutter).
- Manejo de estados y ciclo de vida:
  - `useState`: para datos locales y temporales (ej. abrir/cerrar un menú, mostrar/ocultar contraseña).
  - `useEffect`: para ejecutar código al cargar la pantalla o al salir de ella (equivalente a `initState` y `dispose`).
- Retorno del JSX/HTML al final de la función.


