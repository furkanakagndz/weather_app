import 'package:flutter/material.dart';
import '../models/weather.dart';

/// A reusable weather card widget that displays weather information
/// including city name, temperature, description, and weather icon.
class WeatherCard extends StatelessWidget {
  final Weather weather;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool showFeelsLike;
  final bool showCountry;
  final bool compact;

  const WeatherCard({
    super.key,
    required this.weather,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.showFeelsLike = true,
    this.showCountry = true,
    this.compact = false,
  });

  /// Factory constructor for a compact weather card
  const WeatherCard.compact({
    super.key,
    required this.weather,
    this.width,
    this.height,
    this.padding,
    this.margin,
  }) : showFeelsLike = false,
       showCountry = false,
       compact = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin ?? const EdgeInsets.all(8.0),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _getWeatherGradient(weather.main),
            ),
          ),
          child: compact ? _buildCompactLayout() : _buildFullLayout(),
        ),
      ),
    );
  }

  Widget _buildFullLayout() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // City name and country
        Text(
          showCountry ? '${weather.cityName}, ${weather.country}' : weather.cityName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        
        // Weather icon and temperature row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Temperature section
            Expanded(
              child: Column(
                children: [
                  Text(
                    '${weather.temperature.toStringAsFixed(1)}°C',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${weather.temperatureInFahrenheit.toStringAsFixed(1)}°F',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            
            // Weather icon section
            Expanded(
              child: Column(
                children: [
                  _buildWeatherIcon(),
                  const SizedBox(height: 8),
                  Text(
                    weather.description.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
        
        if (showFeelsLike) ...[
          const SizedBox(height: 12),
          Text(
            'Feels like ${weather.feelsLike.toStringAsFixed(1)}°C',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCompactLayout() {
    return Row(
      children: [
        // Weather icon
        SizedBox(
          width: 50,
          height: 50,
          child: _buildWeatherIcon(size: 50),
        ),
        const SizedBox(width: 12),
        
        // Weather info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                showCountry ? '${weather.cityName}, ${weather.country}' : weather.cityName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    '${weather.temperature.toStringAsFixed(1)}°C',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      weather.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherIcon({double? size}) {
    final iconSize = size ?? 60.0;
    
    return Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(iconSize / 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(iconSize / 2),
        child: Image.network(
          weather.iconUrl,
          width: iconSize,
          height: iconSize,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              _getWeatherIcon(weather.main),
              size: iconSize * 0.6,
              color: Colors.white,
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: SizedBox(
                width: iconSize * 0.4,
                height: iconSize * 0.4,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Get appropriate icon for weather condition
  IconData _getWeatherIcon(String weatherMain) {
    switch (weatherMain.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.grain;
      case 'drizzle':
        return Icons.grain;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'snow':
        return Icons.ac_unit;
      case 'mist':
      case 'fog':
        return Icons.cloud;
      default:
        return Icons.wb_sunny;
    }
  }

  /// Get weather-appropriate gradient colors
  List<Color> _getWeatherGradient(String weatherMain) {
    switch (weatherMain.toLowerCase()) {
      case 'clear':
        return [Colors.orange.shade400, Colors.yellow.shade300];
      case 'clouds':
        return [Colors.grey.shade500, Colors.grey.shade300];
      case 'rain':
      case 'drizzle':
        return [Colors.blue.shade600, Colors.blue.shade400];
      case 'thunderstorm':
        return [Colors.indigo.shade700, Colors.purple.shade400];
      case 'snow':
        return [Colors.blue.shade200, Colors.white];
      case 'mist':
      case 'fog':
        return [Colors.grey.shade400, Colors.grey.shade200];
      default:
        return [Colors.blue.shade500, Colors.blue.shade300];
    }
  }
}

/// A specialized weather card for displaying minimal weather info
class WeatherCardMini extends StatelessWidget {
  final Weather weather;
  final VoidCallback? onTap;

  const WeatherCardMini({
    super.key,
    required this.weather,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 80,
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _getWeatherGradient(weather.main),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                weather.cityName,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getWeatherIcon(weather.main),
                    size: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${weather.temperature.toStringAsFixed(0)}°',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getWeatherIcon(String weatherMain) {
    switch (weatherMain.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.grain;
      case 'drizzle':
        return Icons.grain;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'snow':
        return Icons.ac_unit;
      case 'mist':
      case 'fog':
        return Icons.cloud;
      default:
        return Icons.wb_sunny;
    }
  }

  List<Color> _getWeatherGradient(String weatherMain) {
    switch (weatherMain.toLowerCase()) {
      case 'clear':
        return [Colors.orange.shade400, Colors.yellow.shade300];
      case 'clouds':
        return [Colors.grey.shade500, Colors.grey.shade300];
      case 'rain':
      case 'drizzle':
        return [Colors.blue.shade600, Colors.blue.shade400];
      case 'thunderstorm':
        return [Colors.indigo.shade700, Colors.purple.shade400];
      case 'snow':
        return [Colors.blue.shade200, Colors.white];
      case 'mist':
      case 'fog':
        return [Colors.grey.shade400, Colors.grey.shade200];
      default:
        return [Colors.blue.shade500, Colors.blue.shade300];
    }
  }
}