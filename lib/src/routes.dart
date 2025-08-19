import 'package:flutter/material.dart';
import 'package:places_notes_app/src/screens/login_screen.dart';
import 'package:places_notes_app/src/screens/register_screen.dart';
import 'package:places_notes_app/src/screens/home_screen.dart';
import 'package:places_notes_app/src/screens/add_place_screen.dart';
import 'package:places_notes_app/src/screens/place_details_screen.dart';
import 'package:places_notes_app/src/screens/profile_screen.dart';
import 'package:places_notes_app/src/screens/notes_screen.dart'; 
import 'package:places_notes_app/src/screens/add_note_screen.dart';

class RouteNames {
  static const String intro = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String addPlace = '/add-place';
  static const String placeDetails = '/place-details';
  static const String profile = '/profile';
  static const String notes = '/notes';
  static const String addNotes = '/add-notes';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
    
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case RouteNames.register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case RouteNames.addPlace:
        return MaterialPageRoute(builder: (_) => AddPlaceScreen());
      case RouteNames.placeDetails:
        return MaterialPageRoute(builder: (_) => PlaceDetailsScreen());
      case RouteNames.profile:
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      case RouteNames.notes:
        return MaterialPageRoute(builder: (_) => NotesScreen());
        case RouteNames.addNotes:
        return MaterialPageRoute(builder: (_) => AddNoteScreen());
      default:
        return MaterialPageRoute(builder: (_) => Text('Error: Unknown route'));
    }
  }
}