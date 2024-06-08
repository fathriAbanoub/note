import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/firestore.dart';
import 'Category_Widget.dart';

class StreamNoteCategory extends StatelessWidget {
  final String categoryId;
  final bool? isDone;

  const StreamNoteCategory({
    required this.categoryId,
    this.isDone,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore_Datasource().streamNotesInCategory(categoryId, isDone: isDone),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          print('Snapshot does not have data');
          return const CircularProgressIndicator();
        }

        final notesList = Firestore_Datasource().getCategoryNotes(snapshot);
        print('Notes List Length: ${notesList.length} for isDone: $isDone');

        return ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final note = notesList[index];
            return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                Firestore_Datasource().deleteNoteInCategory(categoryId, note.id);
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

