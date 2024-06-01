import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes/const/colors.dart'; // Ensure this import is correct based on your project structure
import 'package:notes/data/firestore.dart';
import 'package:notes/screen/t.dart';

class add_Note extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  add_Note({required this.categoryId, required this.categoryName});

  @override
  _add_NoteState createState() => _add_NoteState();
}

class _add_NoteState extends State<add_Note> {
  final Firestore_Datasource _firestoreDatasource = Firestore_Datasource();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes in ${widget.categoryName}'),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreDatasource.streamNotesInCategory(widget.categoryId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final notes = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              final noteTitle = note['title'];
              final noteSubtitle = note['subtitle'];
              final noteId = note.id;
              final noteImageIndex = note['image'];

              return Dismissible(
                key: Key(noteId),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) async {
                  await _firestoreDatasource.deleteNoteInCategory(
                      widget.categoryId, noteId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Note $noteTitle deleted'),
                        backgroundColor: Colors.red),
                  );
                },
                background: Container(color: Colors.red),
                child: ListTile(
                  leading: Image.asset(
                      'images/$noteImageIndex.png'), // Display the selected image
                  title: Text(noteTitle),
                  subtitle: Text(noteSubtitle),
                  trailing: IconButton(
                    icon: Icon(Icons.edit, color: Colors.red),
                    onPressed: () => _editNote(
                        noteId, noteTitle, noteSubtitle, noteImageIndex),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotesPage()),
          );
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add),
      ),
    );
  }

  void _editNote(String noteId, String currentTitle, String currentSubtitle,
      int currentImageIndex) {
    // Implement your edit note functionality here
  }
}
