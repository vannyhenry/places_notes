// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:places_notes_app/src/models/place.dart';

// class AddPlaceScreen extends StatefulWidget {
//   @override
//   _AddPlaceScreenState createState() => _AddPlaceScreenState();
// }

// class _AddPlaceScreenState extends State<AddPlaceScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   String? _selectedType;
//   DateTime? _selectedDate;
//   File? _pickedImage;
//   bool _isLoading = false;

//   final List<String> _placeTypes = [
//     'museum', 'attraction', 'river', 'beach', 'restaurant'
//   ];

//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _pickedImage = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2030),
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }

//   Future<void> _submitPlace() async {
//     if (_formKey.currentState!.validate() && _pickedImage != null) {
//       setState(() {
//         _isLoading = true;
//       });

//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) {
//         // Handle no logged-in user
//         print('User not logged in!');
//         setState(() {
//           _isLoading = false;
//         });
//         return;
//       }

//       try {
//         // Upload image to Firebase Storage
//         final storageRef = FirebaseStorage.instance
//             .ref()
//             .child('users/${user.uid}/places/${DateTime.now().millisecondsSinceEpoch}.jpg');
//         await storageRef.putFile(_pickedImage!);
//         final imageUrl = await storageRef.getDownloadURL();

//         // Save place data to Firestore
//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(user.uid)
//             .collection('favorite_places')
//             .add(Place(
//               id: '', // ID will be assigned by Firestore
//               name: _nameController.text,
//               type: _selectedType!,
//               description: _descriptionController.text,
//               visitAgainDate: _selectedDate,
//               imageUrl: imageUrl,
//             ).toFirestore());

//         Navigator.of(context).pop(); // Go back after successful addition
//       } catch (e) {
//         print('Error submitting place: $e');
//         // Show an error message to the user
//       } finally {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     } else if (_pickedImage == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please pick an image.')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Favorite Place'),
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: <Widget>[
//                     TextFormField(
//                       controller: _nameController,
//                       decoration: InputDecoration(labelText: 'Place Name'),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter a name';
//                         }
//                         return null;
//                       },
//                     ),
//                     DropdownButtonFormField<String>(
//                       value: _selectedType,
//                       decoration: InputDecoration(labelText: 'Type of Place'),
//                       items: _placeTypes.map((String type) {
//                         return DropdownMenuItem<String>(
//                           value: type,
//                           child: Text(type),
//                         );
//                       }).toList(),
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           _selectedType = newValue;
//                         });
//                       },
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please select a type';
//                         }
//                         return null;
//                       },
//                     ),
//                     TextFormField(
//                       controller: _descriptionController,
//                       decoration: InputDecoration(labelText: 'Description'),
//                       maxLines: 3,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter a description';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 20),
//                     Row(
//                       children: <Widget>[
//                         Expanded(
//                           child: Text(
//                             _selectedDate == null
//                                 ? 'No date chosen'
//                                 : 'Visit Again Date: ${(_selectedDate!).toLocal().toString().split(' ')[0]}',
//                           ),
//                         ),
//                         TextButton(
//                           onPressed: () => _selectDate(context),
//                           child: Text('Choose Date'),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     _pickedImage != null
//                         ? Image.file(
//                             _pickedImage!,
//                             height: 150,
//                             fit: BoxFit.cover,
//                           )
//                         : Text('No image selected.'),
//                     ElevatedButton.icon(
//                       onPressed: _pickImage,
//                       icon: Icon(Icons.image),
//                       label: Text('Pick Image'),
//                     ),
//                     SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: _submitPlace,
//                       child: Text('Add Place'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }
// lib/src/screens/add_place_screen.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class AddPlaceScreen extends StatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedType;
  DateTime? _selectedDate;
  File? _pickedImage;
  bool _isLoading = false;

  final List<String> _placeTypes = [
    'museum',
    'attraction',
    'river',
    'beach',
    'restaurant'
  ];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitPlace() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_pickedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please pick an image.')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in!')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('users/${user.uid}/places/${DateTime.now().millisecondsSinceEpoch}.jpg');
        await storageRef.putFile(_pickedImage!);
        final imageUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('favorite_places')
            .add({
          'name': _nameController.text,
          'type': _selectedType!,
          'description': _descriptionController.text,
          'visitAgainDate': _selectedDate != null ? Timestamp.fromDate(_selectedDate!) : null,
          'imageUrl': imageUrl,
        });

        Navigator.of(context).pop();
      } catch (e) {
        print('Error submitting place: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add place.')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Favorite Place'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Place Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedType,
                      decoration: const InputDecoration(labelText: 'Type of Place'),
                      items: _placeTypes.map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedType = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a type';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _pickedImage == null
                        ? const Text('No image selected.')
                        : Image.file(
                            _pickedImage!,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.image),
                      label: const Text('Pick Image'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitPlace,
                      child: const Text('Add Place'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}