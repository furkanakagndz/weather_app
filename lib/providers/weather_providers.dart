import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';

part 'weather_providers.g.dart';

// Weather service provider (singleton)
@riverpod
WeatherService weatherService(WeatherServiceRef ref) {
  return WeatherService();
}

// Current weather provider for a specific city
@riverpod
class CurrentWeather extends _$CurrentWeather {
  @override
  FutureOr<Weather?> build() {
    // Initially return null, weather will be loaded when requested
    return null;
  }

  /// Fetch weather for a specific city
  Future<void> fetchWeather(String cityName) async {
    // Set loading state
    state = const AsyncValue.loading();
    
    try {
      final weatherService = ref.read(weatherServiceProvider);
      final weather = await weatherService.getCurrentWeather(cityName);
      
      // Update state with successful result
      state = AsyncValue.data(weather);
    } catch (error, stackTrace) {
      // Update state with error
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Fetch weather by coordinates
  Future<void> fetchWeatherByCoordinates(double lat, double lon) async {
    state = const AsyncValue.loading();
    
    try {
      final weatherService = ref.read(weatherServiceProvider);
      final weather = await weatherService.getCurrentWeatherByCoordinates(lat, lon);
      
      state = AsyncValue.data(weather);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Refresh current weather data
  Future<void> refresh() async {
    final currentWeather = state.value;
    if (currentWeather != null) {
      await fetchWeather(currentWeather.cityName);
    }
  }

  /// Clear current weather data
  void clear() {
    state = const AsyncValue.data(null);
  }
}

// Weather search provider for searching cities
@riverpod
class WeatherSearch extends _$WeatherSearch {
  @override
  FutureOr<List<Weather>> build() {
    return [];
  }

  /// Search weather for multiple cities
  Future<void> searchCities(List<String> cityNames) async {
    if (cityNames.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();
    
    try {
      final weatherService = ref.read(weatherServiceProvider);
      final weatherList = await weatherService.getWeatherForMultipleCities(cityNames);
      
      state = AsyncValue.data(weatherList);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Add a city to search results
  Future<void> addCity(String cityName) async {
    try {
      final weatherService = ref.read(weatherServiceProvider);
      final weather = await weatherService.getCurrentWeather(cityName);
      
      final currentList = state.value ?? [];
      final updatedList = [...currentList, weather];
      
      state = AsyncValue.data(updatedList);
    } catch (error) {
      // Handle error appropriately - could show snackbar or similar
      rethrow;
    }
  }

  /// Remove a city from search results
  void removeCity(String cityName) {
    final currentList = state.value ?? [];
    final updatedList = currentList.where((weather) => weather.cityName != cityName).toList();
    
    state = AsyncValue.data(updatedList);
  }

  /// Clear search results
  void clear() {
    state = const AsyncValue.data([]);
  }
}

// Default cities weather provider
@riverpod
class DefaultCitiesWeather extends _$DefaultCitiesWeather {
  @override
  FutureOr<List<Weather>> build() {
    // Automatically load default cities on initialization
    return _loadDefaultCities();
  }

  Future<List<Weather>> _loadDefaultCities() async {
    final weatherService = ref.read(weatherServiceProvider);
    
    // Use a subset of default cities to avoid too many API calls
    const defaultCities = ['Istanbul', 'London', 'New York', 'Tokyo'];
    
    try {
      final weatherList = await weatherService.getWeatherForMultipleCities(defaultCities);
      return weatherList;
    } catch (error) {
      // Return empty list on error, but log it
      // Log error in production app
      debugPrint('Error loading default cities: $error');
      return [];
    }
  }

  /// Refresh default cities weather
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    
    try {
      final weatherList = await _loadDefaultCities();
      state = AsyncValue.data(weatherList);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

// Favorite cities provider
@riverpod
class FavoriteCities extends _$FavoriteCities {
  @override
  FutureOr<List<String>> build() {
    // In a real app, this would load from SharedPreferences or a database
    return ['Istanbul', 'London'];
  }

  /// Add a city to favorites
  void addFavorite(String cityName) {
    final currentFavorites = state.value ?? [];
    if (!currentFavorites.contains(cityName)) {
      final updatedFavorites = [...currentFavorites, cityName];
      state = AsyncValue.data(updatedFavorites);
      // In a real app, save to SharedPreferences here
    }
  }

  /// Remove a city from favorites
  void removeFavorite(String cityName) {
    final currentFavorites = state.value ?? [];
    final updatedFavorites = currentFavorites.where((city) => city != cityName).toList();
    state = AsyncValue.data(updatedFavorites);
    // In a real app, save to SharedPreferences here
  }

  /// Check if a city is favorite
  bool isFavorite(String cityName) {
    final favorites = state.value ?? [];
    return favorites.contains(cityName);
  }
}

// Favorite cities weather provider that combines favorites with weather data
@riverpod
Future<List<Weather>> favoriteCitiesWeather(FavoriteCitiesWeatherRef ref) async {
  final favoriteCitiesAsync = ref.watch(favoriteCitiesProvider);
  
  return favoriteCitiesAsync.when(
    data: (favoriteCities) async {
      if (favoriteCities.isEmpty) return [];
      
      final weatherService = ref.read(weatherServiceProvider);
      try {
        return await weatherService.getWeatherForMultipleCities(favoriteCities);
      } catch (error) {
        rethrow;
      }
    },
    loading: () => throw const AsyncLoading<List<Weather>>(),
    error: (error, stackTrace) => throw AsyncError<List<Weather>>(error, stackTrace),
  );
}

// Last searched city provider
@riverpod
class LastSearchedCity extends _$LastSearchedCity {
  @override
  String build() {
    // Default to Istanbul
    return 'Istanbul';
  }

  /// Update the last searched city
  void updateCity(String cityName) {
    state = cityName;
    // In a real app, save to SharedPreferences here
  }
}

// Weather loading state provider for UI
@riverpod
class WeatherLoadingState extends _$WeatherLoadingState {
  @override
  bool build() {
    return false;
  }

  void setLoading(bool isLoading) {
    state = isLoading;
  }
}

// Weather error provider for centralized error handling
@riverpod
class WeatherError extends _$WeatherError {
  @override
  String? build() {
    return null;
  }

  void setError(String? error) {
    state = error;
  }

  void clearError() {
    state = null;
  }
}