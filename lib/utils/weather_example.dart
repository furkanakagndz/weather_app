import '../services/weather_service.dart';

/// Example usage of the WeatherService
class WeatherExample {
  static final WeatherService _weatherService = WeatherService();

  /// Example: Get weather for a single city
  static Future<void> getSingleCityWeather() async {
    try {
      print('Fetching weather for London...');
      final weather = await _weatherService.getCurrentWeather('London');
      
      print('Weather Data:');
      print('City: ${weather.cityName}, ${weather.country}');
      print('Temperature: ${weather.temperature.toStringAsFixed(1)}°C (${weather.temperatureInFahrenheit.toStringAsFixed(1)}°F)');
      print('Feels like: ${weather.feelsLike.toStringAsFixed(1)}°C');
      print('Description: ${weather.description}');
      print('Humidity: ${weather.humidity}%');
      print('Wind: ${weather.windSpeed} m/s ${weather.windDirectionCompass}');
      print('Visibility: ${weather.visibilityInMiles.toStringAsFixed(1)} miles');
      print('${weather.isDaytime ? 'Daytime' : 'Nighttime'}');
      print('Icon URL: ${weather.iconUrl}');
      print('---');
      
    } catch (e) {
      print('Error getting weather: $e');
    }
  }

  /// Example: Get weather by coordinates
  static Future<void> getWeatherByCoordinates() async {
    try {
      print('Fetching weather for coordinates (40.7128, -74.0060) - New York...');
      final weather = await _weatherService.getCurrentWeatherByCoordinates(40.7128, -74.0060);
      
      print('Weather for ${weather.cityName}:');
      print('Temperature: ${weather.temperature}°C');
      print('Description: ${weather.description}');
      print('---');
      
    } catch (e) {
      print('Error getting weather by coordinates: $e');
    }
  }

  /// Example: Get weather for multiple cities
  static Future<void> getMultipleCitiesWeather() async {
    try {
      print('Fetching weather for multiple cities...');
      final cities = ['London', 'Paris', 'Tokyo', 'New York'];
      final weatherList = await _weatherService.getWeatherForMultipleCities(cities);
      
      print('Weather data for ${weatherList.length} cities:');
      for (final weather in weatherList) {
        print('${weather.cityName}: ${weather.temperature}°C, ${weather.description}');
      }
      print('---');
      
    } catch (e) {
      print('Error getting weather for multiple cities: $e');
    }
  }

  /// Example: Handle various error scenarios
  static Future<void> demonstrateErrorHandling() async {
    print('Demonstrating error handling...');
    
    // Test invalid city name
    try {
      await _weatherService.getCurrentWeather('InvalidCityName12345');
    } catch (e) {
      print('Invalid city error: $e');
    }
    
    // Test empty city name
    try {
      await _weatherService.getCurrentWeather('');
    } catch (e) {
      print('Empty city error: $e');
    }
    
    // Test invalid coordinates
    try {
      await _weatherService.getCurrentWeatherByCoordinates(200, 300); // Invalid lat/lon
    } catch (e) {
      print('Invalid coordinates error: $e');
    }
    
    print('---');
  }

  /// Run all examples
  static Future<void> runAllExamples() async {
    print('=== WeatherService Examples ===');
    
    // Check if API key is set
    if (!_weatherService.isApiKeySet) {
      print('Warning: API key is not properly configured!');
      return;
    }
    
    await getSingleCityWeather();
    await getWeatherByCoordinates();
    await getMultipleCitiesWeather();
    await demonstrateErrorHandling();
    
    print('=== Examples Complete ===');
  }
}