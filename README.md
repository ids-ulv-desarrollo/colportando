# Colportando
Colportando

## Aplicaciones
- **Mobile (mobile/colportando)**: Aplicación móvil para Android y iOS sobre el ministerio de colportaje, desarrollada en **Flutter**.
- **Web (web)**: Panel administrativo y portal web desarrollado en **React + TypeScript + Vite**.


## Estado Actual
- **Mobile (Flutter)**: Estructura base configurada con gestión de estado mediante `flutter_riverpod` y tipografías con `google_fonts`.
- **Web (React + Vite)**: Configuración base con React 19, TypeScript y Vite, lista para integración con servicios y componentes de interfaz.
- **Documentación**: Guías de arquitectura, convenciones de código y reglas de contribución disponibles en el directorio [`docs/`](docs/).


## Requisitos
Para clonar, compilar y ejecutar las aplicaciones de este repositorio se requiere contar con las siguientes herramientas instaladas:

| Herramienta | Versión | Comando |
| :--- | :--- | :--- |
| **Git** | v2.30+ | `git -v` |
| **Flutter SDK** | v3.38+ (Canal `stable`) | `flutter --version` |
| **Dart SDK** | v3.10+ (incluido en Flutter) | `dart --version` |
| **Node.js** | v20 LTS+ | `node -v` |
| **NPM** | v10+ | `npm -v` |
| **Android Studio** | Emulador o dispositivo físico | `flutter doctor` |

> **Nota:** Node.js v20 LTS+ es el mínimo requerido por Vite 8 y React 19. Al instalar una versión LTS de Node (v20 o v22), NPM v10+ viene incluido automáticamente.

### Entorno de desarrollo recomendado
- **Extensiones recomendadas**:
  - **Flutter** y **Dart** para el entorno móvil.
  - **Flutter Riverpod Snippets** para atajos de Riverpod.
  - **ADB QR** para debugging inalambrico en Android.
  - **Awesome Flutter Snippets** para atajos de código.
  - **Image preview** para la vista previa de imágenes en el editor.

- **Comandos y atajos útiles**:
  - **Vista previa de markdown**: `Ctrl + Shift + V`
  - **Autoformateo**: `Shift + Alt + F`
  - **Guardar un archivo**: `Ctrl + S`
  - **Guardar todos los archivos**: `Ctrl + K + S`


## Instalación
1. **Clonar el repositorio**:
   ```bash
   git clone https://github.com/ids-ulv-desarrollo/colportando.git
   cd colportando_frontend
   ```

2. **Instalar dependencias de la aplicación Móvil (Flutter)**:
   ```bash
   cd mobile/colportando
   flutter pub get
   ```

3. **Instalar dependencias de la plataforma Web (React)**:
   ```bash
   cd web
   npm install
   ```


## Variables de entorno
### Mobile (Flutter)
La URL de conexión al backend no requiere .env, sino que mediante constantes en `lib/core/network/api_constants.dart`:
- **Emulador Android**: Usa `http://10.0.2.2:3000` para acceder al localhost de tu computadora.
- **Dispositivo físico**: Usa la IP local de tu computadora donde corre el backend (ej. `http://10.50.0.110:3000`).
- **Servidor remoto**: La URL HTTPS de producción (Se definirá más adelante).

### Web (React)
Para ejecutar la plataforma web localmente, crea el archivo `.env` dentro del directorio `web/`:
```env
VITE_API_URL=http://localhost:3000/api
```



## Ejecución en desarrollo

### Mobile (Flutter)
```bash
cd mobile/colportando
flutter run
```
> **Nota:** Se puede presionar `F5` y seleccionar dispositivo.


### Web (React + Vite)
```bash
cd web
npm run dev
```
*El servidor de desarrollo estará disponible en `http://localhost:5173`.*


## Comprobación funcional

Para verificar la integridad y correcto funcionamiento del código antes de enviar cambios:

### Mobile (Flutter)
```bash
cd mobile/colportando
# Verificación del entorno
flutter doctor
# Análisis estático de código
flutter analyze
# Pruebas unitarias y de widgets
flutter test
```

### Web (React)
```bash
cd web
# Verificación de linting
npm run lint

# Verificación de tipos TypeScript
npx tsc --noEmit
```


## Compilación

### Mobile (Flutter)
- **Android APK**:
  ```bash
  cd mobile/colportando
  flutter build apk --release
  ```
- **Android App Bundle (AAB)**:
  ```bash
  cd mobile/colportando
  flutter build appbundle --release
  ```
- **iOS**:
  ```bash
  cd mobile/colportando
  flutter build ios --release
  ```

### Web (React)
- **Compilación para producción**:
  ```bash
  cd web
  npm run build
  ```
  *Los archivos finales optimizados se generarán en la carpeta `web/dist`.*
- **Previsualizar la compilación**:
  ```bash
  cd web
  npm run preview
  ```


## Solución de Problemas Comunes

Solo conviene usarlo cuando el proyecto no compila por dependencias corruptas o caché vieja, y por lo tanto se necesita empezar de cero de forma limpia:

- **Problemas de caché en Flutter**:
  ```bash
  cd mobile/colportando
  # Limpiar caché y dependencias y volver a instalar
  flutter clean
  flutter pub get
  ```

- **Errores de dependencias en Web**:
  ```bash
  cd web
  # Eliminar únicamente node_modules
  Remove-Item -Recurse -Force node_modules
  # Reinstalar respetando las versiones del lockfile
  npm install
  ```
  
  **Nota:** No borres `package-lock.json` ya que garantiza que el equipo use las mismas versiones y solo como último recurso si hay conflictos de Git irresolubles.


## Limitaciones actuales

- Los endpoints del backend están en proceso de integración y mockeo local.
- Soporte para iOS requiere un entorno de desarrollo macOS con certificados y perfiles de aprovisionamiento configurados en Xcode.
- La suite de pruebas de integración end-to-end se encuentra en etapa de definición.


## Documentación Adicional

Para lineamientos de arquitectura, convenciones y colaboración, consulta:
- [Arquitectura y Organización](docs/architecture.MD)
- [Convenciones de Código](docs/conventions.MD)
- [Reglas de Contribución y Git Flow](docs/contribution.MD)