import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes/data/firestore.dart';
import 'package:notes/widget/Category_Widget.dart';

class StreamNoteCategory extends StatelessWidget {
  final String categoryId;
  StreamNoteCategory({required this.categoryId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore_Datasource().streamNotesInCategory(categoryId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        final notesList = Firestore_Datasource().getCategoryNotes(snapshot);
        return ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final note = notesList[index];
            return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                Firestore_Datasource()
                    .deleteNoteInCategory(categoryId, note.id);
              },
              child: Task_Widget_Category(note, categoryId),
            );
          },
          itemCount: notesList.length,
        );
      },
    );
  }
}
