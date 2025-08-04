# WeatherCard Widget Documentation

The `WeatherCard` widget is a reusable Flutter widget designed to display weather information in a beautiful, consistent format throughout your weather app.

## Features

- 🎨 **Dynamic theming** based on weather conditions
- 🌐 **Network weather icons** with fallback support
- 📱 **Responsive design** for different screen sizes
- 🔧 **Highly customizable** with multiple variants
- ♻️ **Fully reusable** across different screens

## Widget Variants

### 1. WeatherCard (Full)
The main weather card widget with complete weather information.

```dart
WeatherCard(
  weather: weatherData,
  showFeelsLike: true,
  showCountry: true,
)
```

**Features:**
- City name and country
- Temperature in both °C and °F
- Weather icon from API
- Weather description
- "Feels like" temperature (optional)
- Weather-based gradient background

### 2. WeatherCard.compact
A more compact version of the weather card.

```dart
WeatherCard.compact(
  weather: weatherData,
)
```

**Features:**
- Horizontal layout
- City name
- Temperature
- Weather icon
- Weather description
- More space-efficient

### 3. WeatherCardMini
A minimal weather card perfect for lists or grids.

```dart
WeatherCardMini(
  weather: weatherData,
  onTap: () => print('Tapped!'),
)
```

**Features:**
- Very compact size (120x80)
- City name
- Temperature
- Weather icon
- Tap gesture support

## Customization Options

### WeatherCard Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `weather` | `Weather` | required | Weather data to display |
| `width` | `double?` | null | Custom width |
| `height` | `double?` | null | Custom height |
| `padding` | `EdgeInsetsGeometry?` | `EdgeInsets.all(16.0)` | Internal padding |
| `margin` | `EdgeInsetsGeometry?` | `EdgeInsets.all(8.0)` | External margin |
| `showFeelsLike` | `bool` | `true` | Show "feels like" temperature |
| `showCountry` | `bool` | `true` | Show country code |
| `compact` | `bool` | `false` | Use compact layout |

## Usage Examples

### Basic Usage

```dart
import '../widgets/weather_card.dart';

// In your widget build method
WeatherCard(weather: myWeatherData)
```

### Custom Styling

```dart
WeatherCard(
  weather: weatherData,
  width: 300,
  height: 200,
  padding: EdgeInsets.all(20),
  margin: EdgeInsets.symmetric(horizontal: 16),
  showFeelsLike: false,
  showCountry: false,
)
```

### In a List

```dart
ListView.builder(
  itemCount: weatherList.length,
  itemBuilder: (context, index) {
    return WeatherCard.compact(
      weather: weatherList[index],
    );
  },
)
```

### Mini Cards Grid

```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    childAspectRatio: 1.5,
  ),
  itemBuilder: (context, index) {
    return WeatherCardMini(
      weather: weatherList[index],
      onTap: () => navigateToDetails(weatherList[index]),
    );
  },
)
```

## Weather-Based Theming

The WeatherCard automatically applies appropriate colors based on weather conditions:

- ☀️ **Clear**: Orange to yellow gradient
- ☁️ **Cloudy**: Grey gradients
- 🌧️ **Rain/Drizzle**: Blue gradients
- ⛈️ **Thunderstorm**: Dark purple to purple
- ❄️ **Snow**: Light blue to white
- 🌫️ **Mist/Fog**: Light grey gradients

## Icon Handling

- **Primary**: Uses weather icons from OpenWeatherMap API
- **Fallback**: Shows appropriate Material Design icons if network fails
- **Loading**: Displays loading indicator while fetching network icons

## Best Practices

### 1. Loading States
```dart
if (weatherData != null) {
  WeatherCard(weather: weatherData!)
} else {
  CircularProgressIndicator()
}
```

### 2. Error Handling
```dart
try {
  WeatherCard(weather: weatherData)
} catch (e) {
  Text('Failed to display weather')
}
```

### 3. Responsive Design
```dart
WeatherCard(
  weather: weatherData,
  width: MediaQuery.of(context).size.width * 0.9,
)
```

### 4. List Performance
For lists with many weather cards, consider using `WeatherCard.compact` or `WeatherCardMini` to improve performance.

## Integration with Other Widgets

### In Scaffold Body
```dart
Scaffold(
  body: SingleChildScrollView(
    child: Column(
      children: [
        WeatherCard(weather: currentWeather),
        // Other widgets...
      ],
    ),
  ),
)
```

### In PageView
```dart
PageView.builder(
  itemBuilder: (context, index) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: WeatherCard(weather: weatherList[index]),
    );
  },
)
```

### In Hero Animation
```dart
Hero(
  tag: 'weather-${weather.cityName}',
  child: WeatherCard(weather: weather),
)
```

## File Structure

```
lib/widgets/
├── weather_card.dart           # Main widget file
├── weather_card_example.dart   # Usage examples
└── README.md                   # This documentation
```

## Dependencies

- `flutter/material.dart`
- Your Weather model (`../models/weather.dart`)

## Testing

The WeatherCard widget can be tested using Flutter's widget testing framework:

```dart
testWidgets('WeatherCard displays weather info', (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: WeatherCard(weather: mockWeatherData),
    ),
  );
  
  expect(find.text('Istanbul'), findsOneWidget);
  expect(find.text('18.5°C'), findsOneWidget);
});
```

## Migration from Inline Code

If you have existing weather display code, you can easily migrate to WeatherCard:

**Before:**
```dart
Container(
  child: Column(
    children: [
      Text(weather.cityName),
      Text('${weather.temperature}°C'),
      // ... more weather display code
    ],
  ),
)
```

**After:**
```dart
WeatherCard(weather: weather)
```

This documentation covers all aspects of using the WeatherCard widget effectively in your Flutter weather application.