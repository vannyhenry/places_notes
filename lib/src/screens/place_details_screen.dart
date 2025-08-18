import 'package:flutter/material.dart';
import 'package:places_notes_app/src/models/place.dart';
import 'package:intl/intl.dart'; // Add intl dependency to pubspec.yaml if not already there

class PlaceDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Place place = ModalRoute.of(context)!.settings.arguments as Place;

    return Scaffold(
      appBar: AppBar(
        title: Text(place.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (place.imageUrl.isNotEmpty)
              Image.network(
                place.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: Icon(Icons.broken_image, size: 50, color: Colors.grey[600]),
                  );
                },
              ),
            SizedBox(height: 16),
            Text(
              place.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Type: ${place.type}',
              style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 16),
            Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              place.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            if (place.visitAgainDate != null)
              Text(
                'Visit Again Date: ${DateFormat.yMMMd().format(place.visitAgainDate!)}',
                style: TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}