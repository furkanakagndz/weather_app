# Weather App Riverpod State Management

This directory contains all the Riverpod providers for state management in the Weather App. Riverpod provides reactive state management, dependency injection, and caching capabilities.

## Overview

The weather app uses Riverpod for:
- 🔄 **Reactive state management** - UI automatically updates when data changes
- 🗄️ **Caching** - Weather data is cached and reused
- 🔗 **Dependency injection** - Services are provided throughout the app
- 🎯 **Type safety** - Compile-time safety with proper error handling
- 🧪 **Testability** - Easy to test providers and mock dependencies

## Providers Structure

### Core Providers

#### 1. WeatherService Provider
```dart
@riverpod
WeatherService weatherService(WeatherServiceRef ref) {
  return WeatherService();
}
```
- **Type**: Singleton service provider
- **Purpose**: Provides weather service instance throughout the app
- **Usage**: `ref.read(weatherServiceProvider)`

#### 2. Current Weather Provider
```dart
@riverpod
class CurrentWeather extends _$CurrentWeather {
  @override
  FutureOr<Weather?> build() => null;
  
  Future<void> fetchWeather(String cityName) async { ... }
}
```
- **Type**: AsyncNotifier for single weather data
- **Purpose**: Manages current weather state (loading, data, error)
- **Methods**:
  - `fetchWeather(cityName)` - Fetch weather for a city
  - `fetchWeatherByCoordinates(lat, lon)` - Fetch by coordinates
  - `refresh()` - Refresh current weather
  - `clear()` - Clear current weather data

#### 3. Weather Search Provider
```dart
@riverpod
class WeatherSearch extends _$WeatherSearch {
  @override
  FutureOr<List<Weather>> build() => [];
  
  Future<void> searchCities(List<String> cityNames) async { ... }
}
```
- **Type**: AsyncNotifier for multiple weather searches
- **Purpose**: Manages weather search results
- **Methods**:
  - `searchCities(cityNames)` - Search multiple cities
  - `addCity(cityName)` - Add city to results
  - `removeCity(cityName)` - Remove city from results
  - `clear()` - Clear search results

#### 4. Default Cities Weather Provider
```dart
@riverpod
class DefaultCitiesWeather extends _$DefaultCitiesWeather {
  @override
  FutureOr<List<Weather>> build() => _loadDefaultCities();
}
```
- **Type**: Auto-loading provider for default cities
- **Purpose**: Automatically loads weather for default cities
- **Auto-refresh**: Can be refreshed to update all default cities

#### 5. Favorite Cities Provider
```dart
@riverpod
class FavoriteCities extends _$FavoriteCities {
  @override
  FutureOr<List<String>> build() => ['Istanbul', 'London'];
}
```
- **Type**: Simple state provider for favorite city names
- **Purpose**: Manages list of favorite cities
- **Persistence**: In production, would sync with SharedPreferences

#### 6. Favorite Cities Weather Provider
```dart
@riverpod
Future<List<Weather>> favoriteCitiesWeather(FavoriteCitiesWeatherRef ref) async {
  final favoriteCities = await ref.watch(favoriteCitiesProvider.future);
  // ... fetch weather for favorite cities
}
```
- **Type**: Computed provider that depends on favorites
- **Purpose**: Automatically provides weather for favorite cities
- **Reactive**: Updates when favorite cities change

### Utility Providers

#### 7. Last Searched City Provider
```dart
@riverpod
class LastSearchedCity extends _$LastSearchedCity {
  @override
  String build() => 'Istanbul';
}
```
- **Purpose**: Remembers the last searched city
- **Persistence**: Would sync with SharedPreferences in production

#### 8. Weather Error Provider
```dart
@riverpod
class WeatherError extends _$WeatherError {
  @override
  String? build() => null;
}
```
- **Purpose**: Centralized error state management
- **Usage**: For showing error messages across the app

## Usage Examples

### Basic Weather Fetching

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(currentWeatherProvider);
    
    return weatherAsync.when(
      data: (weather) => weather != null 
        ? WeatherCard(weather: weather)
        : Text('No weather data'),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

### Triggering Weather Fetch

```dart
class SearchButton extends ConsumerWidget {
  final String cityName;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        ref.read(currentWeatherProvider.notifier).fetchWeather(cityName);
      },
      child: Text('Search Weather'),
    );
  }
}
```

### Managing Favorites

```dart
class FavoriteButton extends ConsumerWidget {
  final String cityName;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoriteCitiesProvider);
    final isFavorite = favorites.value?.contains(cityName) ?? false;
    
    return IconButton(
      icon: Icon(isFavorite ? Icons.star : Icons.star_border),
      onPressed: () {
        if (isFavorite) {
          ref.read(favoriteCitiesProvider.notifier).removeFavorite(cityName);
        } else {
          ref.read(favoriteCitiesProvider.notifier).addFavorite(cityName);
        }
      },
    );
  }
}
```

### Automatic Weather Updates

```dart
class DefaultCitiesWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultWeatherAsync = ref.watch(defaultCitiesWeatherProvider);
    
    return defaultWeatherAsync.when(
      data: (weatherList) => ListView.builder(
        itemCount: weatherList.length,
        itemBuilder: (context, index) => WeatherCard.compact(
          weather: weatherList[index],
        ),
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error loading default cities'),
    );
  }
}
```

### Reactive Favorite Cities Weather

```dart
class FavoritesWeatherWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesWeatherAsync = ref.watch(favoriteCitiesWeatherProvider);
    
    return favoritesWeatherAsync.when(
      data: (weatherList) => Column(
        children: weatherList.map((weather) => 
          WeatherCard(weather: weather)
        ).toList(),
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

## State Management Patterns

### 1. Loading States
All async providers automatically handle loading states:
```dart
weatherAsync.when(
  loading: () => CircularProgressIndicator(),
  // ...
)
```

### 2. Error Handling
Providers catch and propagate errors:
```dart
weatherAsync.when(
  error: (error, stackTrace) => ErrorWidget(error: error),
  // ...
)
```

### 3. Data Caching
Riverpod automatically caches provider results:
- Data persists until provider is disposed
- Manual refresh available through `ref.invalidate()`
- Automatic dependency tracking

### 4. Reactive Updates
UI automatically updates when provider state changes:
```dart
// When this changes...
ref.read(favoriteCitiesProvider.notifier).addFavorite('Paris');

// This widget automatically rebuilds
ref.watch(favoriteCitiesWeatherProvider)
```

## Provider Dependencies

```
weatherServiceProvider (singleton)
├── currentWeatherProvider
├── weatherSearchProvider
├── defaultCitiesWeatherProvider
└── favoriteCitiesWeatherProvider
    └── depends on favoriteCitiesProvider

favoriteCitiesProvider
└── favoriteCitiesWeatherProvider

lastSearchedCityProvider (independent)
weatherErrorProvider (independent)
```

## Testing Providers

### Override Providers for Testing
```dart
testWidgets('weather widget test', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        weatherServiceProvider.overrideWithValue(MockWeatherService()),
      ],
      child: MyApp(),
    ),
  );
  
  // Test widget behavior
});
```

### Test Provider Logic
```dart
test('currentWeather provider test', () async {
  final container = ProviderContainer(
    overrides: [
      weatherServiceProvider.overrideWithValue(MockWeatherService()),
    ],
  );
  
  final notifier = container.read(currentWeatherProvider.notifier);
  await notifier.fetchWeather('London');
  
  final weather = container.read(currentWeatherProvider).value;
  expect(weather?.cityName, 'London');
});
```

## Code Generation

The providers use Riverpod's code generation. Run this command when you modify providers:

```bash
dart run build_runner build
```

For continuous generation during development:

```bash
dart run build_runner watch
```

## Best Practices

### 1. Provider Naming
- Use descriptive names: `currentWeatherProvider` not `weatherProvider`
- Follow Riverpod conventions: `Provider`, `FutureProvider`, `StateProvider`

### 2. Error Handling
- Always handle errors in AsyncNotifier classes
- Use try-catch blocks in provider methods
- Provide meaningful error messages

### 3. State Updates
- Use appropriate provider types for different data
- Don't overuse global state - prefer local state when appropriate
- Clear unused state to prevent memory leaks

### 4. Performance
- Use `.select()` to watch specific parts of complex state
- Invalidate providers strategically to avoid unnecessary rebuilds
- Cache expensive computations

### 5. Dependencies
- Keep provider dependencies minimal and explicit
- Use `ref.read()` for one-time reads
- Use `ref.watch()` for reactive dependencies

This Riverpod setup provides a robust, scalable state management solution for the weather app with automatic caching, error handling, and reactive updates.