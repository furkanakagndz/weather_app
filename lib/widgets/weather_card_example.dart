import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../widgets/weather_card.dart';

/// Example demonstrating different uses of WeatherCard widget
class WeatherCardExample extends StatelessWidget {
  const WeatherCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample weather data for demonstration
    final sampleWeather = Weather(
      cityName: 'Istanbul',
      country: 'TR',
      temperature: 18.5,
      temperatureMin: 14.3,
      temperatureMax: 21.2,
      description: 'partly cloudy',
      main: 'Clouds',
      feelsLike: 17.2,
      humidity: 72,
      pressure: 1018,
      windSpeed: 2.8,
      windDirection: 45,
      visibility: 10000,
      cloudiness: 40,
      icon: '02d',
      dateTime: DateTime.now(),
      sunrise: DateTime.now().subtract(const Duration(hours: 2)),
      sunset: DateTime.now().add(const Duration(hours: 6)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('WeatherCard Examples'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Full WeatherCard',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            WeatherCard(weather: sampleWeather),
            
            const SizedBox(height: 24),
            const Text(
              'Compact WeatherCard',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            WeatherCard.compact(weather: sampleWeather),
            
            const SizedBox(height: 24),
            const Text(
              'Custom Sized WeatherCard',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            WeatherCard(
              weather: sampleWeather,
              width: 200,
              height: 150,
              showFeelsLike: false,
            ),
            
            const SizedBox(height: 24),
            const Text(
              'WeatherCard without Country',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            WeatherCard(
              weather: sampleWeather,
              showCountry: false,
            ),
            
            const SizedBox(height: 24),
            const Text(
              'Mini WeatherCards Row',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  WeatherCardMini(weather: sampleWeather),
                  WeatherCardMini(weather: _createSampleWeather('London', 'GB', 15.2, 'Clear')),
                  WeatherCardMini(weather: _createSampleWeather('Paris', 'FR', 12.8, 'Rain')),
                  WeatherCardMini(weather: _createSampleWeather('Tokyo', 'JP', 22.1, 'Clouds')),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            const Text(
              'Usage Examples:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '// Full weather card\nWeatherCard(weather: weatherData)',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '// Compact weather card\nWeatherCard.compact(weather: weatherData)',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '// Custom sized card\nWeatherCard(\n  weather: weatherData,\n  width: 200,\n  height: 150,\n  showFeelsLike: false,\n)',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '// Mini weather card\nWeatherCardMini(\n  weather: weatherData,\n  onTap: () => print("Tapped!"),\n)',
                    style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Weather _createSampleWeather(String city, String country, double temp, String main) {
    return Weather(
      cityName: city,
      country: country,
      temperature: temp,
      temperatureMin: temp - 3,
      temperatureMax: temp + 4,
      description: main.toLowerCase(),
      main: main,
      feelsLike: temp - 1,
      humidity: 65,
      pressure: 1015,
      windSpeed: 3.2,
      windDirection: 180,
      visibility: 10000,
      cloudiness: 30,
      icon: '01d',
      dateTime: DateTime.now(),
      sunrise: DateTime.now().subtract(const Duration(hours: 2)),
      sunset: DateTime.now().add(const Duration(hours: 6)),
    );
  }
}