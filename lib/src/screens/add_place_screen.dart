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
    'Museum',
    'Attraction',
    'River',
    'Beach',
    'Restaurant'
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