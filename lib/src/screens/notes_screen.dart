import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_note_screen.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notes')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No note yet. Add some!',
                style: TextStyle(fontSize: 14),
              ),
            );
          }
          final notes = snapshot.data!.docs;
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return ListTile(
                title: Text(note['title'] ?? ''),
                subtitle: Text(
                  note['content'] ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      note['timestamp'] != null
                          ? (note['timestamp'] as Timestamp)
                              .toDate()
                              .toLocal()
                              .toString()
                              .substring(0, 16)
                          : '',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      tooltip: 'Delete',
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Note'),
                            content: const Text('Are you sure you want to delete this note?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text('Delete', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await note.reference.delete();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Note deleted')),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddNoteScreen()),
          );
          if (result == true && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Note saved successfully!')),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}