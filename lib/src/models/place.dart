import 'package:cloud_firestore/cloud_firestore.dart';

class Place {
  final String id;
  final String name;
  final String type;
  final String description;
  final DateTime? visitAgainDate;
  final String imageUrl;

  Place({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    this.visitAgainDate,
    required this.imageUrl,
  });

  // Factory constructor to create a Place from a Firestore document
  factory Place.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Place(
      id: doc.id,
      name: data['name'] ?? '',
      type: data['type'] ?? '',
      description: data['description'] ?? '',
      visitAgainDate: (data['visitAgainDate'] as Timestamp?)?.toDate(),
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  // Convert a Place object to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'type': type,
      'description': description,
      'visitAgainDate': visitAgainDate != null ? Timestamp.fromDate(visitAgainDate!) : null,
      'imageUrl': imageUrl,
    };
  }
}