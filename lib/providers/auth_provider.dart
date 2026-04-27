import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final authProvider = NotifierProvider<AuthNotifier, User?>(AuthNotifier.new);

class AuthNotifier extends Notifier<User?> {
  @override
  User? build() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      state = user;
    });
    return FirebaseAuth.instance.currentUser;
  }

  Future<void> signInWithGoogle() async {
    try {
      final googleClientId = dotenv.env['GOOGLE_CLIENT_ID'] ?? '';

      final googleSignIn = GoogleSignIn(
        clientId: googleClientId.isNotEmpty ? googleClientId : null,
      );

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return; // User cancelled

      final googleAuth = await googleUser.authentication;

      if (googleAuth.idToken == null) {
        throw Exception('Failed to get Google ID token');
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      state = userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
    } catch (_) {}
    state = null;
  }

  bool get isLoggedIn => state != null;

  String get displayName => state?.displayName ?? 'Guest User';
  String get email => state?.email ?? '';
  String get initials {
    final name = displayName;
    if (name == 'Guest User') return 'G';
    return name.isNotEmpty ? name[0].toUpperCase() : 'G';
  }
}
