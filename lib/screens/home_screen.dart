import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/weather.dart';
import '../widgets/weather_card.dart';
import '../providers/weather_providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load default city on app start using Riverpod
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getWeather('Istanbul');
    });
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _getWeather(String cityName) async {
    if (cityName.trim().isEmpty) {
      ref.read(weatherErrorProvider.notifier).setError('Please enter a city name');
      return;
    }

    // Update last searched city
    ref.read(lastSearchedCityProvider.notifier).updateCity(cityName.trim());
    
    // Fetch weather using Riverpod provider
    await ref.read(currentWeatherProvider.notifier).fetchWeather(cityName.trim());
  }

  void _onSearchPressed() {
    _getWeather(_cityController.text);
  }

  void _onRefresh() async {
    await ref.read(currentWeatherProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the current weather provider
    final weatherAsync = ref.watch(currentWeatherProvider);
    final weatherError = ref.watch(weatherErrorProvider);

    return Scaffold(
      backgroundColor: _getBackgroundColor(weatherAsync.value),
      appBar: AppBar(
        title: const Text(
          '🌤️ Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Favorite button
          if (weatherAsync.value != null)
            _buildFavoriteButton(weatherAsync.value!),
          // Refresh button
          if (weatherAsync.value != null)
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: weatherAsync.isLoading ? null : _onRefresh,
            ),
        ],
      ),
      body: Container(
        decoration: _getBackgroundDecoration(weatherAsync.value),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildSearchSection(weatherAsync.isLoading),
                const SizedBox(height: 20),
                Expanded(
                  child: _buildWeatherContent(weatherAsync, weatherError),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSection(bool isLoading) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _cityController,
                decoration: const InputDecoration(
                  hintText: 'Enter city name',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.location_city),
                ),
                onSubmitted: (_) => _onSearchPressed(),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: isLoading ? null : _onSearchPressed,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.search),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherContent(AsyncValue<Weather?> weatherAsync, String? weatherError) {
    return weatherAsync.when(
      data: (weather) {
        if (weather != null) {
          return _buildWeatherDisplay(weather);
        } else if (weatherError != null) {
          return _buildErrorDisplay(weatherError);
        } else {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.wb_sunny,
                  size: 64,
                  color: Colors.white,
                ),
                SizedBox(height: 16),
                Text(
                  'Enter a city name to get weather information',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
      },
      loading: () => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              'Loading weather data...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      error: (error, stackTrace) => _buildErrorDisplay(error.toString()),
    );
  }

  Widget _buildErrorDisplay(String errorMessage) {
    return Center(
      child: Card(
        color: Colors.red.shade100,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Oops! Something went wrong',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage.replaceFirst('WeatherException: ', ''),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red.shade600,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _getWeather(_cityController.text.isNotEmpty 
                    ? _cityController.text 
                    : 'Istanbul'),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherDisplay(Weather weather) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Main weather card using the reusable WeatherCard widget
          WeatherCard(
            weather: weather,
            padding: const EdgeInsets.all(24.0),
            margin: EdgeInsets.zero,
          ),
          
          // Date display
          Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Last updated: ${weather.dateTime.toString().split(' ')[0]}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Weather details grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _buildWeatherDetailCard(
                'Humidity',
                '${weather.humidity}%',
                Icons.water_drop,
                Colors.blue,
              ),
              _buildWeatherDetailCard(
                'Wind Speed',
                '${weather.windSpeed.toStringAsFixed(1)} m/s',
                Icons.air,
                Colors.green,
              ),
              _buildWeatherDetailCard(
                'Pressure',
                '${weather.pressure} hPa',
                Icons.compress,
                Colors.orange,
              ),
              _buildWeatherDetailCard(
                'Visibility',
                '${weather.visibilityInMiles.toStringAsFixed(1)} mi',
                Icons.visibility,
                Colors.purple,
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Temperature range card
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Icon(Icons.thermostat, color: Colors.blue),
                      const SizedBox(height: 4),
                      const Text('Min Temp', style: TextStyle(fontSize: 12)),
                      Text(
                        '${weather.temperatureMin.toStringAsFixed(1)}°C',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Icon(Icons.thermostat, color: Colors.red),
                      const SizedBox(height: 4),
                      const Text('Max Temp', style: TextStyle(fontSize: 12)),
                      Text(
                        '${weather.temperatureMax.toStringAsFixed(1)}°C',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(
                        weather.isDaytime ? Icons.wb_sunny : Icons.nights_stay,
                        color: weather.isDaytime ? Colors.yellow : Colors.indigo,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        weather.isDaytime ? 'Daytime' : 'Nighttime',
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        weather.windDirectionCompass,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetailCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(Weather weather) {
    final favoritesAsync = ref.watch(favoriteCitiesProvider);
    
    return favoritesAsync.when(
      data: (favorites) {
        final isFavorite = favorites.contains(weather.cityName);
        
        return IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Colors.white,
          ),
          onPressed: () {
            if (isFavorite) {
              ref.read(favoriteCitiesProvider.notifier).removeFavorite(weather.cityName);
              _showSnackBar('${weather.cityName} removed from favorites');
            } else {
              ref.read(favoriteCitiesProvider.notifier).addFavorite(weather.cityName);
              _showSnackBar('${weather.cityName} added to favorites');
            }
          },
        );
      },
      loading: () => const IconButton(
        icon: Icon(Icons.favorite_border, color: Colors.white),
        onPressed: null,
      ),
      error: (error, stack) => const IconButton(
        icon: Icon(Icons.favorite_border, color: Colors.white),
        onPressed: null,
      ),
    );
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Color _getBackgroundColor(Weather? weather) {
    if (weather == null) return Colors.blue.shade300;
    
    switch (weather.main.toLowerCase()) {
      case 'clear':
        return Colors.orange.shade300;
      case 'clouds':
        return Colors.grey.shade400;
      case 'rain':
      case 'drizzle':
        return Colors.blue.shade400;
      case 'thunderstorm':
        return Colors.indigo.shade500;
      case 'snow':
        return Colors.blue.shade100;
      case 'mist':
      case 'fog':
        return Colors.grey.shade300;
      default:
        return Colors.blue.shade300;
    }
  }

  BoxDecoration _getBackgroundDecoration(Weather? weather) {
    final bgColor = _getBackgroundColor(weather);
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          bgColor,
          bgColor.withValues(alpha: 0.7),
        ],
      ),
    );
  }


}