import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  void _saveNote() async {
    final title = _titleController.text;
    final content = _contentController.text;

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and content cannot be empty.')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('notes').add({
        'title': title,
        'content': content,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Navigate back to the previous screen after saving
      Navigator.of(
        context,
      ).pop(true); // Optionally pass true to indicate success
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save note: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a New Note')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Note Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Note Content',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                expands: true,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveNote,
                child: const Text('Save Note'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
