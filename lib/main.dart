import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/splash_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/learn/categories_screen.dart';
import 'screens/chat/chat_screen.dart';
import 'screens/forms/form_list_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/resources/resources_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  runApp(
    const ProviderScope(
      child: LegalRightsApp(),
    ),
  );
}

class LegalRightsApp extends StatelessWidget {
  const LegalRightsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lex Bharat',
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFAFAF8),
        primaryColor: const Color(0xFF1A1A2E),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A1A2E),
          primary: const Color(0xFF1A1A2E),
          secondary: const Color(0xFF7B5CF8),
        ),
        textTheme: GoogleFonts.interTextTheme(),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF1A1A2E),
          iconTheme: IconThemeData(color: Color(0xFF1A1A2E)),
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFF0EFE9), width: 1),
          ),
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A1A2E),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: const Color(0xFFFAFAF8),
          indicatorColor: const Color(0xFFE8E4FF),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E));
            }
            return const TextStyle(fontSize: 11, color: Color(0xFF9B9B9B));
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: Color(0xFF7B5CF8));
            }
            return const IconThemeData(color: Color(0xFF9B9B9B));
          }),
        ),
      ),
    );
  }
}

class HomeNavigation extends StatefulWidget {
  const HomeNavigation({super.key});

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  int _selectedIndex = 0;

  final List<NavigationDestination> destinations = [
    const NavigationDestination(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    const NavigationDestination(
      icon: Icon(Icons.school),
      label: 'Learn',
    ),
    const NavigationDestination(
      icon: Icon(Icons.chat),
      label: 'Chat',
    ),
    const NavigationDestination(
      icon: Icon(Icons.description),
      label: 'Forms',
    ),
    const NavigationDestination(
      icon: Icon(Icons.map_rounded),
      label: 'Help',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: destinations,
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const CategoriesScreen();
      case 2:
        return const ChatScreen();
      case 3:
        return const FormListScreen();
      case 4:
        return const ResourcesScreen();
      default:
        return const HomeScreen();
    }
  }
}