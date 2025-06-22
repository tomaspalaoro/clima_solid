# Clima SOLID (Prueba técnica)

Pequeña aplicación Flutter que permite consultar el clima (en intervalos de tres horas) de distintas ciudades a través de la API de [OpenWeatherMap](https://openweathermap.org/).

## Características

- Gestión de estado con Bloc/Cubits
- Integración de idiomas con EasyLocalization
- Validación de formulario

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
├── main.dart            # Configuración de EasyLocalization, MultiProvider y MaterialApp
├── theme.dart           # Definición de colores y estilos globales

├── blocs/               # Gestión de estado
│   ├── weather_cubit.dart
│   ├── weather_state.dart
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
│   └── login_service.dart

├── views/               # Pantallas de la app
│   ├── login_screen.dart
│   ├── home_screen.dart
│   ├── city_weather_tab.dart
│   └── contact_form_tab.dart

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

- **IMPORTANTE**: El token gratuito de la API está visible para facilitar la ejecución inmediata. En un entorno de producción, este token debe **almacenarse de forma segura** (por ejemplo, usando variables de entorno)
- La organización de carpetas actualmente separa responsabilidades por tipo de archivo. En producción podría evolucionar a organización por features.

## Posibles mejoras futuras

- Autenticación de usuarios desde base de datos
- Separación de lógica de retry del service
- Cacheado de imágenes
- Buscador de ciudades
