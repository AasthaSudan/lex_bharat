import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

final userProvider = StateNotifierProvider<UserNotifier, User?>(
      (ref) => UserNotifier(),
);

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userData = prefs.getString('user');
    if (userData != null) {
      // state = User.fromJson(jsonDecode(userData));
    }
  }

  Future<void> updateUser(User user) async {
    state = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', user.toJson().toString());
  }

  Future<void> clearUser() async {
    state = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
  }
}