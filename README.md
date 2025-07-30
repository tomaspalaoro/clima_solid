# Clima SOLID 
>(Prueba técnica de Tomás Palaoro)

Pequeña aplicación Flutter que permite consultar el clima (en intervalos de tres horas) de distintas ciudades a través de la API de [OpenWeatherMap](https://openweathermap.org/).

## Características

- Selector de idioma en tiempo real (inglés por defecto, o español)
- Consulta de clima por ciudades: Londres, Toronto y Singapur
- Previsión meteorológica por intervalos de 3 horas
- Formulario de contacto validado
- Arquitectura basada en Cubits y separación de capas
- Login con email y contraseña
- Gestión de sesión persistente

## Principios SOLID

Cada clase tiene una única responsabilidad. Los Cubits gestionan exclusivamente el estado y la lógica de presentación, los servicios manejan las llamadas a la API o tareas de infraestructura, los repositorios encapsulan la lógica de negocio, y las vistas y widgets se encargan únicamente de mostrar la interfaz de usuario.

La app se puede extender sin necesidad de modificar las clases existentes. 

Las clases pueden ser reemplazadas por otras que implementen la misma interfaz sin afectar el comportamiento de la app.

Las clases solo dependen de lo que realmente necesitan, sin implementaciones innecesarias.

## Capturas
 <img src="assets/screenshots/home.png" width="300" alt="Home">

## Estructura
```text
lib/
├── main.dart            # Configuración de repositorios y blocs
├── theme.dart           # Definición de colores y estilos globales

├── blocs/               # Gestión de estado
│   ├── weather_cubit.dart
│   ├── weather_state.dart
│   ├── auth_cubit.dart
│   ├── auth_state.dart
│   ├── login_cubit.dart
│   ├── login_state.dart
│   ├── contact_form_state.dart
│   └── contact_form_cubit.dart

├── models/              # Entidades de dominio y mapeos JSON
│   ├── city_model.dart
│   ├── contact_model.dart
│   └── hour_weather_model.dart

├── repositories/        # Interfaces y lógica de negocio
│   ├── weather_repository.dart
│   └── city_repository.dart

├── services/            # llamadas HTTP, servicios de infraestructura
│   ├── weather_api_service.dart
│   ├── contact_service.dart
│   ├── login_service.dart
│   └── auth_service.dart

├── views/               # Pantallas de la app
│   ├── login_screen.dart
│   ├── home_screen.dart
│   ├── city_weather_tab.dart
│   ├── contact_form_tab.dart
│   └── splash_screen.dart

├── navigation/          # Gestión de navegación automática
│   └── auth_routes.dart

├── widgets/             # Componentes reutilizables
│   ├── weather_info.dart
│   ├── language_button.dart
│   └── logout_button.dart

└── utils/               # Funciones de apoyo
    ├── form_validator.dart
    ├── forecast_filter.dart 
    └── date_formatter.dart 
```

## Tests

Este proyecto incluye tests unitarios.
En 'login_test.dart' se comprueba la validación de email y contraseña, el flujo de envío exitoso y el manejo de errores.
En 'weather_test.dart' se verifica el comportamiento en casos exitosos y fallidos al obtener datos meteorológicos. También la correcta deserialización del JSON proporcionado por la API de OpenWeatherMap.

## Notas

- **IMPORTANTE**: La clave de API de OpenWeatherMap se inyecta en tiempo de compilación usando --dart-define. Esto permite ejecutar la app sin exponer credenciales en el código fuente.
- La organización de carpetas actualmente separa responsabilidades por tipo de archivo. En producción podría evolucionar a organización por features.

## Posibles mejoras futuras

- Autenticación de usuarios desde base de datos
- Separación de lógica de retry del service
- Cacheado de imágenes
- Buscador de ciudades
- Marcar ciudades favoritas
- Ver más detalles al pulsar sobre una hora

## Ejecución
Se ha actualizado la versión a la última estable en la fecha de la prueba técnica.
Flutter 3.32.5 • channel stable
```bash
flutter pub get
```

**IMPORTANTE**: Para ejecutar la aplicación, debes proporcionar tu token (por ej. 1234) con el siguiente comando:
```bash
flutter run --dart-define=API_KEY=1234
```
Puedes obtener tu token gratuito desde: https://home.openweathermap.org/api_keys

La activación del token puede tardar algunos minutos después de crearlo en la web.



