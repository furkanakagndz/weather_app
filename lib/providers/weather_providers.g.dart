// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$weatherServiceHash() => r'70fe327d965e15347c73be4561f55527f5c56cb2';

/// See also [weatherService].
@ProviderFor(weatherService)
final weatherServiceProvider = AutoDisposeProvider<WeatherService>.internal(
  weatherService,
  name: r'weatherServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$weatherServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WeatherServiceRef = AutoDisposeProviderRef<WeatherService>;
String _$favoriteCitiesWeatherHash() =>
    r'51ab0d7e6dd3cf503e5f040885a70247491ef038';

/// See also [favoriteCitiesWeather].
@ProviderFor(favoriteCitiesWeather)
final favoriteCitiesWeatherProvider =
    AutoDisposeFutureProvider<List<Weather>>.internal(
      favoriteCitiesWeather,
      name: r'favoriteCitiesWeatherProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$favoriteCitiesWeatherHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FavoriteCitiesWeatherRef = AutoDisposeFutureProviderRef<List<Weather>>;
String _$currentWeatherHash() => r'9d23aa79033320226b7ab085cd3e35704cbdd196';

/// See also [CurrentWeather].
@ProviderFor(CurrentWeather)
final currentWeatherProvider =
    AutoDisposeAsyncNotifierProvider<CurrentWeather, Weather?>.internal(
      CurrentWeather.new,
      name: r'currentWeatherProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$currentWeatherHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CurrentWeather = AutoDisposeAsyncNotifier<Weather?>;
String _$weatherSearchHash() => r'd40c49c38f85d6c519bb5a68967e7c667a25700f';

/// See also [WeatherSearch].
@ProviderFor(WeatherSearch)
final weatherSearchProvider =
    AutoDisposeAsyncNotifierProvider<WeatherSearch, List<Weather>>.internal(
      WeatherSearch.new,
      name: r'weatherSearchProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$weatherSearchHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$WeatherSearch = AutoDisposeAsyncNotifier<List<Weather>>;
String _$defaultCitiesWeatherHash() =>
    r'd8b99e2dde3d1967751c9a3897b0ea648575cc06';

/// See also [DefaultCitiesWeather].
@ProviderFor(DefaultCitiesWeather)
final defaultCitiesWeatherProvider = AutoDisposeAsyncNotifierProvider<
  DefaultCitiesWeather,
  List<Weather>
>.internal(
  DefaultCitiesWeather.new,
  name: r'defaultCitiesWeatherProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$defaultCitiesWeatherHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DefaultCitiesWeather = AutoDisposeAsyncNotifier<List<Weather>>;
String _$favoriteCitiesHash() => r'7efe43e8a63c5c7d05a2786dc6f7e9ef624d1d3c';

/// See also [FavoriteCities].
@ProviderFor(FavoriteCities)
final favoriteCitiesProvider =
    AutoDisposeAsyncNotifierProvider<FavoriteCities, List<String>>.internal(
      FavoriteCities.new,
      name: r'favoriteCitiesProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$favoriteCitiesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$FavoriteCities = AutoDisposeAsyncNotifier<List<String>>;
String _$lastSearchedCityHash() => r'b4dd837c1efacb13806aeaf2360fb7f57baebc5c';

/// See also [LastSearchedCity].
@ProviderFor(LastSearchedCity)
final lastSearchedCityProvider =
    AutoDisposeNotifierProvider<LastSearchedCity, String>.internal(
      LastSearchedCity.new,
      name: r'lastSearchedCityProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$lastSearchedCityHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LastSearchedCity = AutoDisposeNotifier<String>;
String _$weatherLoadingStateHash() =>
    r'488f2eecd100ec67ee9595e34e9dbc8b2f1d026a';

/// See also [WeatherLoadingState].
@ProviderFor(WeatherLoadingState)
final weatherLoadingStateProvider =
    AutoDisposeNotifierProvider<WeatherLoadingState, bool>.internal(
      WeatherLoadingState.new,
      name: r'weatherLoadingStateProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$weatherLoadingStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$WeatherLoadingState = AutoDisposeNotifier<bool>;
String _$weatherErrorHash() => r'0923e3729d1870959998fa382a07f81a1193aa0d';

/// See also [WeatherError].
@ProviderFor(WeatherError)
final weatherErrorProvider =
    AutoDisposeNotifierProvider<WeatherError, String?>.internal(
      WeatherError.new,
      name: r'weatherErrorProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$weatherErrorHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$WeatherError = AutoDisposeNotifier<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
