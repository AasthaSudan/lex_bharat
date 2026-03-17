import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

final userProvider =
NotifierProvider<UserNotifier, User?>(UserNotifier.new);

class UserNotifier extends Notifier<User?> {
  @override
  User? build() {
    _loadUser();
    return null;
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