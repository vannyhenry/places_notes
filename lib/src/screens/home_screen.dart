import 'package:flutter/material.dart';
import 'package:places_notes_app/src/screens/add_place_screen.dart';
import 'package:places_notes_app/src/screens/favourite_places_list_screen.dart';
import 'package:places_notes_app/src/screens/notes_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    NotesScreen(),
    FavoritePlacesListScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<String> _titles = [
    'Your Notes',
    'Favourite Places',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green[900],
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.white,
            fontFamily: 'TitilliumWeb',
            fontSize: 22,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.25),
                blurRadius: 24, // Add blur radius to the top container
                offset: const Offset(0, 6),
      ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8F5E9), Color(0xFFB2DFDB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () async {
                // Open add note screen
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const NotesScreen()),
                );
                // Optionally handle result
              },
              backgroundColor: Colors.grey,
              child: const Icon(Icons.add),
              tooltip: 'Add Note',
            )
            : _selectedIndex == 1
              ? FloatingActionButton(
                  onPressed: () async {
                    // Open add favourite place screen
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const AddPlaceScreen()),
                    );
                    // Optionally handle result
                  },
                  backgroundColor: Colors.grey,
                  child: const Icon(Icons.add_location_alt),
                  tooltip: 'Add Favourite Place',
              )
          : null,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.sticky_note_2_outlined),
                activeIcon: Icon(Icons.sticky_note_2, color: Colors.green),
                label: 'Notes',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.place_outlined),
                activeIcon: Icon(Icons.place, color: Colors.green),
                label: 'Favourite Places',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.green[900],
            unselectedItemColor: Colors.grey[600],
            backgroundColor: Colors.white,
            elevation: 0,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
          ),
        ),
      ),
    );
  }
}