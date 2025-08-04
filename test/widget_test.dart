// This is a basic Flutter widget test for the Weather App.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:weather_app/main.dart';

void main() {
  testWidgets('Weather app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const WeatherApp());

    // Verify that the app loads with bottom navigation
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Favorites'), findsOneWidget);
    
    // Verify that the weather app loads with search functionality on home tab
    expect(find.text('🌤️ Weather App'), findsOneWidget);
    expect(find.text('Enter city name'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    
    // Verify that the search input field is present
    expect(find.byType(TextField), findsOneWidget);
    
    // Test bottom navigation
    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();
    
    // Should see favorites screen
    expect(find.text('⭐ Favorite Cities'), findsOneWidget);
    
    // Note: The app will attempt to load Istanbul weather on startup
    // but we can't test the actual API call in widget tests without mocking
  });
}
