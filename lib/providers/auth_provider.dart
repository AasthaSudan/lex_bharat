import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Helper to safely access Supabase — returns null if not initialized
SupabaseClient? get supabaseClient {
  try {
    return Supabase.instance.client;
  } catch (_) {
    return null;
  }
}

final authProvider = NotifierProvider<AuthNotifier, User?>(AuthNotifier.new);

class AuthNotifier extends Notifier<User?> {
  @override
  User? build() {
    final client = supabaseClient;
    if (client == null) return null;

    client.auth.onAuthStateChange.listen((data) {
      state = data.session?.user;
    });
    return client.auth.currentUser;
  }

  Future<void> signInWithGoogle() async {
    final client = supabaseClient;
    if (client == null) {
      throw Exception('Supabase not available. Please check your connection.');
    }

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

      await client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken,
      );
      state = client.auth.currentUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    final client = supabaseClient;
    if (client != null) {
      try {
        await client.auth.signOut();
      } catch (_) {}
    }
    state = null;
  }

  bool get isLoggedIn => state != null;
  
  String get displayName => state?.userMetadata?['name'] ?? 'Guest User';
  String get email => state?.email ?? '';
  String get initials {
    final name = displayName;
    if (name == 'Guest User') return 'G';
    return name.isNotEmpty ? name[0].toUpperCase() : 'G';
  }
}