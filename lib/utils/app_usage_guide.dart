/// Weather App Usage Guide
/// 
/// This file contains comprehensive documentation for using the Weather App.
/// 
/// ## Overview
/// The Weather App is a Flutter application that displays current weather
/// information for any city using the OpenWeatherMap API.
/// 
/// ## Features
/// - 🌤️ Real-time weather data
/// - 🔍 City search functionality
/// - 📊 Comprehensive weather metrics
/// - 🎨 Dynamic UI themes based on weather conditions
/// - 🌡️ Temperature in both Celsius and Fahrenheit
/// - 💨 Wind speed and direction
/// - 👁️ Visibility and pressure readings
/// - 🌅 Sunrise and sunset times
/// - 📱 Responsive design
/// 
/// ## Core Components
/// 
/// ### 1. HomeScreen (`lib/screens/home_screen.dart`)
/// - Main screen displaying weather information
/// - Search functionality with text input
/// - Loading states and error handling
/// - Dynamic background colors based on weather
/// - Comprehensive weather data display
/// 
/// ### 2. WeatherService (`lib/services/weather_service.dart`)
/// - Handles API calls to OpenWeatherMap
/// - Parses JSON responses into Weather objects
/// - Comprehensive error handling
/// - Support for city names and coordinates
/// - Batch processing for multiple cities
/// 
/// ### 3. Weather Model (`lib/models/weather.dart`)
/// - Data model representing weather information
/// - JSON serialization/deserialization
/// - Utility methods for temperature conversion
/// - Helper methods for formatting and display
/// 
/// ## How to Use
/// 
/// ### Basic Usage:
/// 1. Launch the app - Istanbul weather loads automatically
/// 2. Enter a city name in the search field
/// 3. Tap the search button or press Enter
/// 4. View the comprehensive weather information
/// 
/// ### Features Available:
/// - **Current Temperature**: Displayed in large format with both °C and °F
/// - **Weather Description**: Clear, readable weather conditions
/// - **Feels Like**: Perceived temperature
/// - **Humidity**: Air moisture percentage
/// - **Wind**: Speed in m/s with compass direction
/// - **Pressure**: Atmospheric pressure in hPa
/// - **Visibility**: How far you can see in miles
/// - **Temperature Range**: Daily min/max temperatures
/// - **Day/Night**: Current time relative to sunrise/sunset
/// 
/// ### Error Handling:
/// - Invalid city names show clear error messages
/// - Network issues are handled gracefully
/// - API errors provide helpful guidance
/// - Empty inputs are validated
/// 
/// ### UI Features:
/// - **Dynamic Backgrounds**: Change based on weather conditions
/// - **Weather-Themed Colors**: UI adapts to current weather
/// - **Responsive Cards**: Clean, modern card-based layout
/// - **Loading States**: Smooth loading indicators
/// - **Error Recovery**: Easy retry functionality
/// 
/// ## API Configuration
/// 
/// The app uses OpenWeatherMap API. Make sure your API key is configured in:
/// `lib/utils/constants.dart` - `WeatherConstants.openWeatherMapApiKey`
/// 
/// ## Example Weather Data Display:
/// ```
/// Istanbul, TR
/// 2024-01-15
/// 
/// 18.5°C (65.3°F)
/// PARTLY CLOUDY
/// Feels like 17.2°C
/// 
/// Humidity: 72%
/// Wind: 2.8 m/s NE
/// Pressure: 1018 hPa
/// Visibility: 7.1 mi
/// 
/// Min: 14.3°C | Max: 21.2°C | Daytime
/// ```
/// 
/// ## Code Examples
/// 
/// ### Getting Weather Data:
/// ```dart
/// final weatherService = WeatherService();
/// try {
///   Weather weather = await weatherService.getCurrentWeather('Istanbul');
///   print('Temperature: ${weather.temperature}°C');
/// } catch (e) {
///   print('Error: $e');
/// }
/// ```
/// 
/// ### Using Weather Utilities:
/// ```dart
/// print('${weather.temperature}°C = ${weather.temperatureInFahrenheit}°F');
/// print('Wind: ${weather.windSpeed} m/s ${weather.windDirectionCompass}');
/// print(weather.isDaytime ? 'Daytime' : 'Nighttime');
/// ```
/// 
/// ## File Structure
/// ```
/// lib/
/// ├── main.dart              # App entry point
/// ├── screens/
/// │   └── home_screen.dart   # Main weather display screen
/// ├── services/
/// │   └── weather_service.dart # API service layer
/// ├── models/
/// │   └── weather.dart       # Weather data model
/// └── utils/
///     ├── constants.dart     # App constants and config
///     ├── weather_example.dart # Usage examples
///     └── app_usage_guide.dart # This documentation
/// ```
/// 
/// ## Testing
/// Run `flutter test` to execute the widget tests.
/// Run `flutter analyze` to check code quality.
/// 
/// ## Performance Notes
/// - API calls include 10-second timeout
/// - Efficient state management with minimal rebuilds
/// - Responsive design for various screen sizes
/// - Graceful error handling prevents crashes
/// 
/// Enjoy using your Weather App! 🌤️
class AppUsageGuide {
  static const String version = '1.0.0';
  static const String lastUpdated = '2024-01-15';
}