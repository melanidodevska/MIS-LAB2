import 'package:firebase_database/firebase_database.dart';

class FavoritesService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // fiks korisnik
  final String _userId = 'test_user_001';


  DatabaseReference get _favoritesRef => _database.child('users/$_userId/favorites');


  Future<void> addFavorite(String mealId, String mealName, String mealThumb) async {
    try {
      await _favoritesRef.child(mealId).set({
        'id': mealId,
        'name': mealName,
        'thumb': mealThumb,
        'addedAt': ServerValue.timestamp,
      });
      print('Added to Firebase: $mealName');
    } catch (e) {
      print('Error adding favorite: $e');
      rethrow;
    }
  }


  Future<void> removeFavorite(String mealId) async {
    try {
      await _favoritesRef.child(mealId).remove();
      print('Removed from Firebase: $mealId');
    } catch (e) {
      print('Error removing favorite: $e');
      rethrow;
    }
  }


  Future<bool> isFavorite(String mealId) async {
    try {
      final snapshot = await _favoritesRef.child(mealId).get();
      return snapshot.exists;
    } catch (e) {
      print('Error checking favorite: $e');
      return false;
    }
  }


  Future<List<Map<String, dynamic>>> getFavoritesList() async {
    try {
      final snapshot = await _favoritesRef.get();

      if (!snapshot.exists) {
        return [];
      }

      final List<Map<String, dynamic>> favorites = [];
      final data = snapshot.value as Map<dynamic, dynamic>;

      data.forEach((key, value) {
        final meal = value as Map<dynamic, dynamic>;
        favorites.add({
          'id': meal['id']?.toString() ?? '',
          'name': meal['name']?.toString() ?? '',
          'thumb': meal['thumb']?.toString() ?? '',
        });
      });


      favorites.sort((a, b) {
        final aTime = data[a['id']]?['addedAt'] ?? 0;
        final bTime = data[b['id']]?['addedAt'] ?? 0;
        return (bTime as num).compareTo(aTime as num);
      });

      return favorites;
    } catch (e) {
      print('Error getting favorites: $e');
      return [];
    }
  }


  Stream<List<Map<String, dynamic>>> getFavoritesStream() {
    return _favoritesRef.onValue.map((event) {
      if (!event.snapshot.exists) {
        return <Map<String, dynamic>>[];
      }

      final List<Map<String, dynamic>> favorites = [];
      final data = event.snapshot.value as Map<dynamic, dynamic>;

      data.forEach((key, value) {
        final meal = value as Map<dynamic, dynamic>;
        favorites.add({
          'id': meal['id']?.toString() ?? '',
          'name': meal['name']?.toString() ?? '',
          'thumb': meal['thumb']?.toString() ?? '',
        });
      });

      return favorites;
    });
  }
}