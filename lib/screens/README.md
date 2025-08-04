# Weather App Screens

This directory contains all the screens/pages for the weather app with bottom navigation support.

## Screen Structure

The app uses a bottom navigation pattern with two main tabs:

```
MainScreen (BottomNavigationBar)
├── HomeScreen (Tab 0)
└── FavoritesScreen (Tab 1)
```

## Screens Overview

### 1. MainScreen
**File:** `main_screen.dart`
**Type:** Main container with BottomNavigationBar

**Features:**
- 🏠 **Home Tab**: Weather search and display
- ⭐ **Favorites Tab**: Favorite cities management
- 📱 **IndexedStack**: Preserves state when switching tabs
- 🎨 **Clean UI**: Material Design bottom navigation

**Usage:**
```dart
// Used as the main entry point in main.dart
home: const MainScreen(),
```

### 2. HomeScreen
**File:** `home_screen.dart`
**Type:** Weather search and display screen

**Features:**
- 🔍 **City Search**: Enter city name to get weather
- 🌤️ **Weather Display**: Complete weather information using WeatherCard
- ❤️ **Favorite Toggle**: Heart button to add/remove from favorites
- 🔄 **Refresh**: Refresh current weather data
- 🎨 **Dynamic Background**: Changes based on weather conditions
- 📱 **Responsive**: Works on all screen sizes

**State Management:**
- Uses Riverpod `currentWeatherProvider` for weather data
- Uses `favoriteCitiesProvider` for favorite management
- Reactive UI updates when state changes

**Key Components:**
```dart
// Watch weather state
final weatherAsync = ref.watch(currentWeatherProvider);

// Add/remove favorites
ref.read(favoriteCitiesProvider.notifier).addFavorite(cityName);
```

### 3. FavoritesScreen
**File:** `favorites_screen.dart`
**Type:** Favorite cities management and weather display

**Features:**
- ⭐ **Favorites List**: Shows all favorite cities with weather
- 🌡️ **Weather Info**: Temperature, description, humidity for each city
- ❤️ **Remove Favorites**: Swipe to delete or tap heart icon
- ➕ **Add Favorites**: Add new cities via dialog
- 🔄 **Auto-refresh**: Weather data updates when tab is opened
- 🗑️ **Undo Support**: Restore accidentally deleted favorites

**State Management:**
- Uses `favoriteCitiesWeatherProvider` for reactive weather data
- Uses `favoriteCitiesProvider` for favorites list management
- Automatically fetches weather for all favorite cities

**Key Features:**
```dart
// Watch favorites weather (automatically updates)
final favoritesWeatherAsync = ref.watch(favoriteCitiesWeatherProvider);

// Swipe to delete with undo
Dismissible(
  onDismissed: (direction) => removeFavorite(cityName),
  // Undo functionality in SnackBar
)
```

## Navigation Flow

### Bottom Navigation
- **Home Tab (Index 0)**: Default screen, weather search
- **Favorites Tab (Index 1)**: Favorite cities management

### State Preservation
- Uses `IndexedStack` to maintain state when switching tabs
- Weather data persists between tab switches
- Search input and scroll positions preserved

## Integration with Riverpod

### Home Screen Providers
```dart
// Current weather state
final weatherAsync = ref.watch(currentWeatherProvider);

// Fetch weather
ref.read(currentWeatherProvider.notifier).fetchWeather(cityName);

// Manage favorites
ref.read(favoriteCitiesProvider.notifier).addFavorite(cityName);
```

### Favorites Screen Providers
```dart
// Reactive favorites weather
final favoritesAsync = ref.watch(favoriteCitiesWeatherProvider);

// Manage favorites list
final favorites = ref.watch(favoriteCitiesProvider);
```

## UI/UX Features

### Home Screen
- **Dynamic Backgrounds**: Colors change based on weather
- **Heart Animation**: Favorite button shows filled/outline heart
- **Snackbar Feedback**: Confirms favorite add/remove actions
- **Loading States**: Shows progress during API calls
- **Error Handling**: User-friendly error messages with retry

### Favorites Screen
- **Rich Weather Cards**: Detailed weather info for each city
- **Color-coded Icons**: Weather condition indicators
- **Swipe Gestures**: Intuitive delete interaction
- **Empty State**: Helpful message when no favorites
- **Quick Actions**: App bar buttons for add/refresh

## Error Handling

### Network Errors
- Graceful fallback to cached data
- User-friendly error messages
- Retry mechanisms

### State Errors
- Loading state management
- Error boundary handling
- Recovery options

## Accessibility

### Screen Reader Support
- Semantic labels for all interactive elements
- Proper navigation announcements
- Descriptive tooltips

### Visual Accessibility
- High contrast weather icons
- Clear typography hierarchy
- Touch target sizing

## Testing

### Widget Tests
- Bottom navigation functionality
- Tab switching behavior
- State preservation
- Error state handling

### Integration Tests
- End-to-end user flows
- Favorites management
- Weather data display

## Performance

### Optimizations
- `IndexedStack` for tab state preservation
- Efficient provider watching
- Minimal rebuilds with Riverpod
- Lazy loading where appropriate

### Memory Management
- Automatic cleanup of unused data
- Provider disposal handling
- Image caching for weather icons

## Future Enhancements

### Planned Features
- 📍 **Location Tab**: Current location weather
- 📊 **Charts Tab**: Weather trends and forecasts
- ⚙️ **Settings Tab**: User preferences
- 🔔 **Notifications**: Weather alerts

### UI Improvements
- Swipe gestures between tabs
- Animated transitions
- Pull-to-refresh everywhere
- Dark mode support

This screen architecture provides a solid foundation for the weather app with clear separation of concerns, efficient state management, and excellent user experience.