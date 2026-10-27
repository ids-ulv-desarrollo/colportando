# Arquitectura y Estructura del Proyecto

Tanto la app móvil (Flutter) como la web (React) siguen una arquitectura **Feature-First** basada en **Clean Architecture**, dividida en tres capas:

1. **domain:** Reglas de negocio puras (Dart/TS puro). Entidades, contratos de repositorios y casos de uso.
2. **data:** Acceso a datos y persistencia. Modelos/DTOs (`fromJson`/`toJson`), data sources y repositorios concretos.
3. **presentation:** Interfaz y estado reactivo. Pantallas, widgets/componentes y notifiers/hooks.

---

## 1. Arquitectura Móvil (Flutter + Riverpod)

Gestión de estado con **Riverpod** (`Notifier<State>` y `NotifierProvider`).

### 1.1 Estructura del Código (`mobile/colportando/lib/`)

```text
lib/
├── core/                               # Globales y reutilizables
│   ├── constants/                      # Textos fijos
│   ├── error/                          # Result<T> y manejo de excepciones
│   ├── network/                        # ApiClient y manageHttpResponse
│   ├── router/                         # Enrutamiento
│   ├── theme/                          # Tema global
│   ├── utils/                          # Validaciones y permisos
│   └── widgets/                        # Widgets base
│
├── features/
│   └── auth/                           # Módulos por features
│       ├── domain/
│       │   ├── entities/               # user.dart (Inmutable con Equatable)
│       │   ├── repositories/           # i_auth_repository.dart (Contrato)
│       │   └── usecases/               # signin_usecase.dart, signup_usecase.dart
│       ├── data/
│       │   ├── models/                 # user_dto.dart (Extiende User, fromJson/toJson)
│       │   ├── sources/                # auth_remote_data_source.dart (Usa ApiClient)
│       │   │                           # (Pendiente: auth_local_data_source.dart para SQLite)
│       │   └── repositories/           # auth_repository_impl.dart
│       └── presentation/
│           ├── riverpod/               # auth_riverpod.dart (Estado y Notifier)
│           │                           # auth_di.dart (Inyección de dependencias)
│           ├── screens/                # signin_screen.dart, signup_screen.dart
│           └── widgets/                # Widgets exclusivos de la feature
│
└── main.dart                           # Punto de entrada con ProviderScope
```

### 1.2 Flujo de Datos

1. **UI:** El usuario ejecuta una acción en la pantalla (ej. presiona un botón validado por `FormKey`).
2. **Notifier:** La vista invoca `ref.read(authProvider.notifier).signIn(...)`. El notifier activa `isLoading: true`.
3. **Caso de Uso y Repositorio:** El notifier ejecuta el caso de uso, que llama al repositorio (`IAuthRepository`).
4. **Data Source y Red:** El repositorio delega en `AuthRemoteDataSource`, consumiendo `ApiClient` y procesando la respuesta con `manageHttpResponse`.
5. **Resultado (`Result<T>`):** La respuesta retorna encapsulada en `Result<T>` (éxito o error).
6. **Actualización de Estado:** El notifier actualiza el estado (`state = state.copyWith(...)`).
7. **Reacción:** La pantalla actualiza su UI con `ref.watch` y ejecuta efectos colaterales (alertas con `SnackBarFormat` o navegación) mediante `ref.listen`.

---

## 2. Arquitectura Web (React + TypeScript) *(Propuesto / Pendiente de implementación)*

En la web se mantendrá la misma estructura por capas usando **Hooks personalizados** (`use_auth`) para el estado.

### 2.1 Estructura Objetivo (`web/src/`)

```text
src/
├── core/                               # Transversal (red, temas, router, utilidades, componentes base)
├── features/
│   └── auth/
│       ├── domain/                     # user.entity.ts, auth.repository.ts
│       ├── data/                       # user.dto.ts, auth.datasource.ts, auth.repository.impl.ts
│       └── presentation/               # hooks/ (use_auth.ts), screens/, components/
├── App.tsx
└── main.tsx
```

---

## 3. Comparativa de Nomenclatura

| Concepto | Flutter (`.dart`) *(Implementado)* | React (`.ts`/`.tsx`) *(Pendiente)* |
| :--- | :--- | :--- |
| **Pantalla principal** | `signin_screen.dart` | `signin_screen.tsx` |
| **Componentes base** | `*_format.dart` (`ButtonFormat`, etc.) | `*_component.tsx` |
| **Gestión de estado** | `auth_riverpod.dart` (`NotifierProvider`) | `use_auth.ts` (Hooks) |
| **Inyección de dependencias**| `auth_di.dart` | Contenedor / Contexto |
| **Entidad** | `user.dart` (extiende `Equatable`) | `user.entity.ts` |
| **Modelo / DTO** | `user_dto.dart` (extiende entidad) | `user.dto.ts` |
| **Contrato repositorio** | `auth_repository.dart` (`I...`) | `auth.repository.ts` |
| **Implementación repo** | `auth_repository_impl.dart` | `auth.repository.impl.ts` |
| **Manejo de resultados** | `Result<T>` (`result.dart`) | `Result<T>` (`result.ts`) |

---

## 4. Estrategia Offline-First y Sincronización *(En diseño / Pendiente de corroborar e implementar)*


### 4.1 Principios de Dominio
- **IDs universales:** Generación de identificadores con UUID en el cliente para crear registros válidos localmente sin esperar al servidor.
- **Estado de sincronización (`syncStatus`):**
  - `synced`: Sincronizado con el servidor.
  - `pendingCreation`: Creado localmente; pendiente de enviar (`POST`).
  - `pendingUpdate`: Editado localmente; pendiente de actualizar (`PUT`/`PATCH`).
  - `pendingDeletion`: Eliminado lógicamente; pendiente de borrar (`DELETE`).
  - `syncError`: Error devuelto por el servidor al intentar sincronizar.
- **Borrado lógico (`deletedAt`):** Oculta el registro en la app sin eliminarlo físicamente de la base local hasta confirmar con el backend.

### 4.2 Flujo de Datos y Persistencia
1. **Lectura (Cache-First):** Se lee de `LocalDataSource` (SQLite) para respuesta instantánea; se actualiza desde el servidor en segundo plano si hay red.
2. **Escritura Optimista:** Los cambios se guardan localmente en SQLite con estado pendiente y se notifican de inmediato a la UI.
3. **Servicio de Sincronización (`SyncService`):** Proceso en segundo plano que, al detectar conexión, recorre los registros pendientes y sincroniza con el backend mediante `RemoteDataSource`. Al recibir confirmación exitosa (200/201/204), actualiza el estado local a `synced` (o borra la fila en eliminaciones).
