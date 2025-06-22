# Clima Solid

Pequeña aplicación Flutter que permite consultar el clima por horas en distintas ciudades a través de la API de OpenWeatherMap.

## Características

- Arquitectura SOLID
- Gestión de estado con Bloc/Cubits
- Integración de idiomas con EasyLocalization

## Capturas
 <img src="assets/screenshots/home.png" width="300" alt="Home">

## Estructura
```text
lib/
├── main.dart            # Configuración de EasyLocalization, MultiProvider y MaterialApp
├── theme.dart           # Definición de colores y estilos globales

├── blocs/               # Gestión de estado
│   ├── weather_cubit.dart
│   └── weather_state.dart

├── models/              # Entidades de dominio y mapeos JSON
│   ├── city_model.dart
│   ├── contact_model.dart
│   └── hour_weather_model.dart

├── repositories/        # Interfaces y lógica de negocio
│   ├── weather_repository.dart
│   └── city_repository.dart

├── services/            # llamadas HTTP, servicios de infraestructura
│   ├── openweather_api_service.dart
│   └── contact_service.dart

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
    └── date_formatter.dart
```

## Posibles mejoras futuras

- Autenticación de usuarios
- Separación de lógica de retry del service
- Cacheado de imágenes
- Buscador de ciudades
