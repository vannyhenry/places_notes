import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:places_notes_app/firebase_options.dart';
import 'package:places_notes_app/src/screens/add_note_screen.dart';
import 'package:places_notes_app/src/screens/add_place_screen.dart';
import 'package:places_notes_app/src/screens/home_screen.dart';
import 'package:places_notes_app/src/screens/auth_screen.dart';
import 'package:places_notes_app/src/screens/login_screen.dart';
import 'package:places_notes_app/src/screens/register_screen.dart'; // Import the AuthScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Favorite Places App',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            return HomeScreen();
          }
          return const AuthScreen();
        },
      ),

      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/add-place': (context) => const AddPlaceScreen(),
        '/add-note': (context) => const AddNoteScreen(),
      },
    );
  }
}
