/// Weather model representing data from OpenWeatherMap API
class Weather {
  final String cityName;
  final String country;
  final double temperature;
  final double temperatureMin;
  final double temperatureMax;
  final String description;
  final String main;
  final double feelsLike;
  final int humidity;
  final int pressure;
  final double windSpeed;
  final int? windDirection;
  final int visibility;
  final int cloudiness;
  final String icon;
  final DateTime dateTime;
  final DateTime sunrise;
  final DateTime sunset;

  Weather({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.temperatureMin,
    required this.temperatureMax,
    required this.description,
    required this.main,
    required this.feelsLike,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    this.windDirection,
    required this.visibility,
    required this.cloudiness,
    required this.icon,
    required this.dateTime,
    required this.sunrise,
    required this.sunset,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    try {
      final main = json['main'] as Map<String, dynamic>;
      final weather = json['weather'][0] as Map<String, dynamic>;
      final wind = json['wind'] as Map<String, dynamic>? ?? {};
      final sys = json['sys'] as Map<String, dynamic>;
      final clouds = json['clouds'] as Map<String, dynamic>? ?? {};

      return Weather(
        cityName: json['name'] as String,
        country: sys['country'] as String? ?? '',
        temperature: (main['temp'] as num).toDouble(),
        temperatureMin: (main['temp_min'] as num).toDouble(),
        temperatureMax: (main['temp_max'] as num).toDouble(),
        description: weather['description'] as String,
        main: weather['main'] as String,
        feelsLike: (main['feels_like'] as num).toDouble(),
        humidity: main['humidity'] as int,
        pressure: main['pressure'] as int,
        windSpeed: (wind['speed'] as num?)?.toDouble() ?? 0.0,
        windDirection: wind['deg'] as int?,
        visibility: json['visibility'] as int? ?? 10000,
        cloudiness: clouds['all'] as int? ?? 0,
        icon: weather['icon'] as String,
        dateTime: DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000),
        sunrise: DateTime.fromMillisecondsSinceEpoch((sys['sunrise'] as int) * 1000),
        sunset: DateTime.fromMillisecondsSinceEpoch((sys['sunset'] as int) * 1000),
      );
    } catch (e) {
      throw FormatException('Failed to parse weather data: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': cityName,
      'sys': {
        'country': country,
        'sunrise': sunrise.millisecondsSinceEpoch ~/ 1000,
        'sunset': sunset.millisecondsSinceEpoch ~/ 1000,
      },
      'main': {
        'temp': temperature,
        'temp_min': temperatureMin,
        'temp_max': temperatureMax,
        'feels_like': feelsLike,
        'humidity': humidity,
        'pressure': pressure,
      },
      'weather': [
        {
          'main': main,
          'description': description,
          'icon': icon,
        }
      ],
      'wind': {
        'speed': windSpeed,
        if (windDirection != null) 'deg': windDirection,
      },
      'visibility': visibility,
      'clouds': {
        'all': cloudiness,
      },
      'dt': dateTime.millisecondsSinceEpoch ~/ 1000,
    };
  }

  @override
  String toString() {
    return 'Weather(cityName: $cityName, country: $country, temperature: ${temperature.toStringAsFixed(1)}°C, description: $description, humidity: $humidity%)';
  }

  /// Get temperature in Fahrenheit
  double get temperatureInFahrenheit => (temperature * 9/5) + 32;
  
  /// Get feels like temperature in Fahrenheit
  double get feelsLikeInFahrenheit => (feelsLike * 9/5) + 32;
  
  /// Get minimum temperature in Fahrenheit
  double get temperatureMinInFahrenheit => (temperatureMin * 9/5) + 32;
  
  /// Get maximum temperature in Fahrenheit
  double get temperatureMaxInFahrenheit => (temperatureMax * 9/5) + 32;

  /// Get wind speed in mph (converted from m/s)
  double get windSpeedInMph => windSpeed * 2.237;

  /// Get wind direction as compass direction
  String get windDirectionCompass {
    if (windDirection == null) return 'N/A';
    
    const directions = ['N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE', 
                       'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW'];
    
    final index = ((windDirection! + 11.25) / 22.5).floor() % 16;
    return directions[index];
  }

  /// Get weather icon URL
  String get iconUrl => 'https://openweathermap.org/img/wn/$icon@2x.png';

  /// Check if it's currently daytime (between sunrise and sunset)
  bool get isDaytime {
    final now = DateTime.now();
    return now.isAfter(sunrise) && now.isBefore(sunset);
  }

  /// Get visibility in miles (converted from meters)
  double get visibilityInMiles => visibility * 0.000621371;

  /// Get pressure in inches of mercury (converted from hPa)
  double get pressureInInHg => pressure * 0.02953;
}