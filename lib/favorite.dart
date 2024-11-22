import 'package:shared_preferences/shared_preferences.dart';

class FavoriteManager {
  // Singleton pattern
  static final FavoriteManager _instance = FavoriteManager._internal();
  factory FavoriteManager() => _instance;

  List<String> favoriteItems = [];

  FavoriteManager._internal() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    favoriteItems = prefs.getStringList('favoriteItems') ?? [];
  }

  Future<void> addFavorite(String item) async {
    if (!favoriteItems.contains(item)) {
      favoriteItems.add(item);
      await _saveFavorites();
    }
  }

  Future<void> removeFavorite(String item) async {
    favoriteItems.remove(item);
    await _saveFavorites();
  }

  Future<void> _saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favoriteItems', favoriteItems);
  }

  // Check if an item is in favorites
  bool isFavorite(String item) {
    return favoriteItems.contains(item);
  }
}
