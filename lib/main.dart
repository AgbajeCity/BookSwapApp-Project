import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 1. IMPORT YOUR SCREENS (LoginScreen is now implicitly imported via OnboardingScreen)
import 'features/auth/presentation/verify_email_screen.dart';
import 'presentation/navigation/main_navigation.dart';
import 'features/auth/presentation/onboarding_screen.dart'; // <-- THIS IS THE PRIMARY START SCREEN

// FIREBASE OPTIONS
const firebaseOptions = FirebaseOptions(
  apiKey: "AIzaSyBb971sZyga19CEKWRzsBvb15GwTSf2Ck8",
  authDomain: "bookswapapp-211ec.firebaseapp.com",
  projectId: "bookswapapp-211ec",
  storageBucket: "bookswapapp-211ec.appspot.com",
  messagingSenderId: "296077173095",
  appId: "1:296077173095:web:c4f5ea0b97fcb7774fac2c",
);

// MAIN APP INITIALIZATION
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: firebaseOptions,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

// MAIN APP WIDGET
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookSwap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1F1F1F),
        textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Poppins'),
        colorScheme: const ColorScheme.dark().copyWith(
          primary: const Color(0xFFF2C94C),
          secondary: const Color(0xFFF2C94C),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFF2C94C)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF2C94C),
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: const Color(0xFF2a2a2a),
          selectedItemColor: const Color(0xFFF2C94C),
          unselectedItemColor: Colors.grey[600],
          type: BottomNavigationBarType.fixed,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFF2C94C),
          foregroundColor: Colors.black,
        ),
      ),
      home: const AuthWrapper(),
    );
  }
}

// RIVERPOD PROVIDER
final authStateChangesProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// AUTHWRAPPER
class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          if (user.emailVerified) {
            return const MainNavigation();
          } else {
            return const VerifyEmailScreen();
          }
        }
        // Redirects to the Onboarding/Splash Screen when not logged in
        return const OnboardingScreen();
      },
      loading: () => const Scaffold(
        backgroundColor: Color(0xFF1F1F1F),
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        backgroundColor: const Color(0xFF1F1F1F),
        body: Center(
            child: Text("Error: ${err.toString()}",
                style: const TextStyle(color: Colors.red))),
      ),
    );
  }
}
