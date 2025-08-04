import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'weather_providers.dart';
import '../widgets/weather_card.dart';

/// Example demonstrating how to use Riverpod providers in the weather app
class ProviderExampleScreen extends ConsumerStatefulWidget {
  const ProviderExampleScreen({super.key});

  @override
  ConsumerState<ProviderExampleScreen> createState() => _ProviderExampleScreenState();
}

class _ProviderExampleScreenState extends ConsumerState<ProviderExampleScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod Provider Examples'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('1. Current Weather Provider'),
            _buildCurrentWeatherExample(),
            
            const SizedBox(height: 24),
            _buildSectionTitle('2. Default Cities Weather'),
            _buildDefaultCitiesExample(),
            
            const SizedBox(height: 24),
            _buildSectionTitle('3. Favorite Cities Management'),
            _buildFavoritesExample(),
            
            const SizedBox(height: 24),
            _buildSectionTitle('4. Weather Search Provider'),
            _buildSearchExample(),
            
            const SizedBox(height: 24),
            _buildSectionTitle('5. Provider State Information'),
            _buildStateInfoExample(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.indigo,
        ),
      ),
    );
  }

  Widget _buildCurrentWeatherExample() {
    final weatherAsync = ref.watch(currentWeatherProvider);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'City Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: weatherAsync.isLoading ? null : () {
                    if (_controller.text.isNotEmpty) {
                      ref.read(currentWeatherProvider.notifier)
                          .fetchWeather(_controller.text);
                    }
                  },
                  child: weatherAsync.isLoading 
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Fetch'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            weatherAsync.when(
              data: (weather) => weather != null
                  ? WeatherCard.compact(weather: weather, margin: EdgeInsets.zero)
                  : const Text('Enter a city name and tap Fetch'),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Text(
                'Error: $error',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultCitiesExample() {
    final defaultWeatherAsync = ref.watch(defaultCitiesWeatherProvider);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Auto-loaded default cities:'),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(defaultCitiesWeatherProvider.notifier).refresh();
                  },
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Refresh'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            defaultWeatherAsync.when(
              data: (weatherList) => SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: weatherList.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: WeatherCardMini(weather: weatherList[index]),
                  ),
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Text(
                'Error loading default cities: $error',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesExample() {
    final favoritesAsync = ref.watch(favoriteCitiesProvider);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Favorite Cities Management:'),
            const SizedBox(height: 12),
            favoritesAsync.when(
              data: (favorites) => Wrap(
                spacing: 8,
                children: [
                  ...favorites.map((city) => Chip(
                    label: Text(city),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () {
                      ref.read(favoriteCitiesProvider.notifier).removeFavorite(city);
                    },
                  )),
                  ActionChip(
                    label: const Text('Add City'),
                    avatar: const Icon(Icons.add, size: 16),
                    onPressed: () => _showAddCityDialog(),
                  ),
                ],
              ),
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error: $error'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchExample() {
    final searchAsync = ref.watch(weatherSearchProvider);
    const searchCities = ['Paris', 'Tokyo', 'Sydney'];
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Multi-city search:'),
                ElevatedButton(
                  onPressed: () {
                    ref.read(weatherSearchProvider.notifier)
                        .searchCities(searchCities);
                  },
                  child: const Text('Search Cities'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            searchAsync.when(
              data: (weatherList) => weatherList.isEmpty
                  ? const Text('Tap "Search Cities" to load weather for Paris, Tokyo, Sydney')
                  : Column(
                      children: weatherList.map((weather) => 
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: WeatherCard.compact(
                            weather: weather,
                            margin: EdgeInsets.zero,
                          ),
                        ),
                      ).toList(),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Text(
                'Error: $error',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStateInfoExample() {
    final lastSearched = ref.watch(lastSearchedCityProvider);
    final weatherError = ref.watch(weatherErrorProvider);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Provider State Information:'),
            const SizedBox(height: 12),
            Text('Last searched city: $lastSearched'),
            const SizedBox(height: 8),
            if (weatherError != null)
              Text(
                'Current error: $weatherError',
                style: const TextStyle(color: Colors.red),
              )
            else
              const Text(
                'No current errors',
                style: TextStyle(color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }

  void _showAddCityDialog() {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Favorite City'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter city name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref.read(favoriteCitiesProvider.notifier)
                    .addFavorite(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}