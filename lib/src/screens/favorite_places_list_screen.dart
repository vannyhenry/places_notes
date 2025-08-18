import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:places_notes_app/src/models/place.dart';
import 'package:places_notes_app/src/screens/place_details_screen.dart'; // For navigation

class FavoritePlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(child: Text('Please log in to view favorite places.'));
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/add-place'); // Define this route
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('favorite_places')
            .snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> placesSnapshot) {
          if (placesSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (placesSnapshot.hasError) {
            return Center(child: Text('Error: ${placesSnapshot.error}'));
          }
          if (!placesSnapshot.hasData || placesSnapshot.data!.docs.isEmpty) {
            return Center(child: Text('No favorite places yet. Add some!'));
          }

          final loadedPlaces = placesSnapshot.data!.docs
              .map((doc) => Place.fromFirestore(doc))
              .toList();

          return ListView.builder(
            itemCount: loadedPlaces.length,
            itemBuilder: (ctx, index) {
              final place = loadedPlaces[index];
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar( // Use CircleAvatar for leading image as per mockup
                    backgroundImage: NetworkImage(place.imageUrl),
                    radius: 30, // Adjust size as needed
                  ),
                  title: Text(place.name),
                  subtitle: Text(place.type),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      '/place-details', // Define this route
                      arguments: place,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}