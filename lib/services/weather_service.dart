import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';
import '../utils/constants.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String _apiKey = WeatherConstants.openWeatherMapApiKey;
  static const Duration _timeout = Duration(seconds: 10);
  
  // Get current weather by city name
  Future<Weather> getCurrentWeather(String cityName) async {
    if (cityName.trim().isEmpty) {
      throw WeatherException('City name cannot be empty.');
    }

    final url = Uri.parse(
      '$_baseUrl/weather?q=${Uri.encodeComponent(cityName.trim())}&appid=$_apiKey&units=metric'
    );

    try {
      final response = await http.get(url).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = _parseJsonResponse(response.body);
        return _parseWeatherData(data);
      } else {
        _handleHttpError(response.statusCode, response.body);
      }
    } catch (e) {
      _handleException(e, 'getCurrentWeather');
    }
  }

  // Get current weather by coordinates (latitude, longitude)
  Future<Weather> getCurrentWeatherByCoordinates(double lat, double lon) async {
    if (lat < -90 || lat > 90) {
      throw WeatherException('Invalid latitude. Must be between -90 and 90.');
    }
    if (lon < -180 || lon > 180) {
      throw WeatherException('Invalid longitude. Must be between -180 and 180.');
    }

    final url = Uri.parse(
      '$_baseUrl/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric'
    );

    try {
      final response = await http.get(url).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = _parseJsonResponse(response.body);
        return _parseWeatherData(data);
      } else {
        _handleHttpError(response.statusCode, response.body);
      }
    } catch (e) {
      _handleException(e, 'getCurrentWeatherByCoordinates');
    }
  }

  // Get weather for multiple cities
  Future<List<Weather>> getWeatherForMultipleCities(List<String> cities) async {
    if (cities.isEmpty) {
      throw WeatherException('Cities list cannot be empty.');
    }

    final List<Weather> weatherList = [];
    final List<String> failedCities = [];

    for (String city in cities) {
      try {
        final weather = await getCurrentWeather(city);
        weatherList.add(weather);
      } catch (e) {
        failedCities.add(city);
      }
    }

    if (weatherList.isEmpty) {
      throw WeatherException('Failed to get weather data for all cities: ${failedCities.join(', ')}');
    }

    return weatherList;
  }

  // Check if API key is set
  bool get isApiKeySet => _apiKey != 'YOUR_API_KEY_HERE' && _apiKey.isNotEmpty;

  // Private helper methods
  
  /// Parse JSON response with error handling
  Map<String, dynamic> _parseJsonResponse(String responseBody) {
    try {
      final data = json.decode(responseBody) as Map<String, dynamic>;
      return data;
    } catch (e) {
      throw WeatherException('Invalid JSON response from weather service.');
    }
  }

  /// Parse weather data from JSON with enhanced error handling
  Weather _parseWeatherData(Map<String, dynamic> data) {
    try {
      return Weather.fromJson(data);
    } on FormatException catch (e) {
      throw WeatherException('Failed to parse weather data: ${e.message}');
    } catch (e) {
      throw WeatherException('Unexpected error parsing weather data: $e');
    }
  }

  /// Handle HTTP errors with detailed messages
  Never _handleHttpError(int statusCode, String responseBody) {
    String errorMsg;
    
    switch (statusCode) {
      case 400:
        errorMsg = 'Bad request. Please check your input parameters.';
        break;
      case 401:
        errorMsg = 'Invalid API key. Please check your API key configuration.';
        break;
      case 403:
        errorMsg = 'Access forbidden. Your API key may not have the required permissions.';
        break;
      case 404:
        errorMsg = 'Location not found. Please check the city name or coordinates.';
        break;
      case 429:
        errorMsg = 'Too many requests. Please wait before making another request.';
        break;
      case 500:
      case 502:
      case 503:
      case 504:
        errorMsg = 'Weather service is temporarily unavailable. Please try again later.';
        break;
      default:
        errorMsg = 'Failed to fetch weather data. Status code: $statusCode';
    }

    // Try to extract more specific error from response body
    try {
      final data = json.decode(responseBody) as Map<String, dynamic>;
      if (data.containsKey('message')) {
        errorMsg += ' Details: ${data['message']}';
      }
    } catch (_) {
      // Ignore JSON parsing errors for error responses
    }

    throw WeatherException(errorMsg);
  }

  /// Handle various exceptions that might occur during API calls
  Never _handleException(dynamic e, String methodName) {
    if (e is WeatherException) {
      throw e;
    } else if (e is TimeoutException) {
      throw WeatherException('Request timeout. Please check your internet connection and try again.');
    } else if (e is http.ClientException) {
      throw WeatherException('Network error: ${e.message}. Please check your internet connection.');
    } else if (e is FormatException) {
      throw WeatherException('Invalid response format from weather service.');
    } else {
      throw WeatherException('Unexpected error in $methodName: ${e.toString()}');
    }
  }
}

// Custom exception class for weather-related errors
class WeatherException implements Exception {
  final String message;
  
  WeatherException(this.message);
  
  @override
  String toString() => 'WeatherException: $message';
}