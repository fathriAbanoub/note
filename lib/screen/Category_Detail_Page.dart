import 'package:flutter/material.dart';
import 'package:notes/widget/Stream_Category_notes.dart';

class CategoryDetailPage extends StatelessWidget {
  final String categoryId;

  CategoryDetailPage({required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Notes'),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamNoteCategory(categoryId: categoryId),
    );
  }
}
