import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:notes/widget/Stream_Category_notes.dart';
import 'package:notes/screen/t.dart'; // Import the NotesPage

class CategoryDetailPage extends StatefulWidget {
  final String categoryId;
  final String categoryName; // Add category name parameter

  const CategoryDetailPage({Key? key, required this.categoryId, required this.categoryName}) : super(key: key);

  @override
  _CategoryDetailPageState createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  bool show = true;

  // Function to navigate to the NotesPage
  void navigateToNotesPage(BuildContext context) {
    print('Navigating to NotesPage with categoryId: ${widget.categoryId}, categoryName: ${widget.categoryName}');
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>  NotesPage(categoryId: widget.categoryId, categoryName: widget.categoryName)), // Navigate to NotesPage with category name
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Building CategoryDetailPage');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName), // Display category name in app bar
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        // hide add button while scrolling
        child: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            if (notification.direction == ScrollDirection.forward) {
              print('Scrolling forward');
              setState(() {
                show = true;
                print('Show updated: $show');
              });
            }
            if (notification.direction == ScrollDirection.reverse) {
              print('Scrolling reverse');
              setState(() {
                show = false;
                print('Show updated: $show');
              });
            }
            return true;
          },
          child: Column(
            children: [
              StreamNoteCategory(categoryId: widget.categoryId), // Display notes from StreamNoteCategory
              Text(
                'isDone',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.bold),
              ),
              StreamNoteCategory( categoryId: widget.categoryId), // Display notes from StreamNoteCategory for done notes
            ],
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: show,
        child: FloatingActionButton(
          onPressed: () {
            print('Floating action button pressed');
            // Call the function to navigate to the NotesPage
            navigateToNotesPage(context);
          },
          backgroundColor: Colors.blueAccent,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
