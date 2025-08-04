class WeatherConstants {
  // API Configuration
  static const String openWeatherMapApiKey = 'c918e3693d1a0f574a8f98b4e77d29b5';
  
  // Default cities
  static const List<String> defaultCities = [
    'London',
    'New York',
    'Tokyo',
    'Paris',
    'Sydney',
  ];
  
  // Weather icon base URL
  static const String iconBaseUrl = 'https://openweathermap.org/img/wn/';
  
  // Get full icon URL
  static String getIconUrl(String iconCode) {
    return '$iconBaseUrl$iconCode@2x.png';
  }
  
  // Temperature conversion
  static double celsiusToFahrenheit(double celsius) {
    return (celsius * 9/5) + 32;
  }
  
  static double fahrenheitToCelsius(double fahrenheit) {
    return (fahrenheit - 32) * 5/9;
  }
}