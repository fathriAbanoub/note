import 'package:flutter/material.dart';
import 'package:notes/const/colors.dart';
import 'package:notes/data/firestore.dart';

class NotesPage extends StatefulWidget {
  final String categoryId;
  final String categoryName; // Add category name parameter

  const NotesPage({Key? key, required this.categoryId, required this.categoryName}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {

  final title = TextEditingController();
  final subtitle = TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  int indxx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Add a note'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            tittle_widgets(),
            const SizedBox(height: 20),
            subtitle_wedgite(),
            const SizedBox(height: 20),
            imagess(),
            const SizedBox(height: 20),
            button(),
          ],
        ),
      ),
    );
  }

  Widget button() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Semantics(
          label: 'Add button Double tap to add note',
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent,
              minimumSize: const Size(170, 48),
            ),
            onPressed: () {
              print("Adding note to category: ${widget.categoryId}");
              Firestore_Datasource().addNoteToCategory(
                  widget.categoryId,
                  subtitle.text,
                  title.text,
                  indxx);
              Navigator.pop(context);
            },

            child: const Text(
              'Add',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Semantics(
          label: 'Double tap to cancel',
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              minimumSize: const Size(170, 48),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  SizedBox imagess() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        itemCount: 5,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                indxx = index;
              });
            },
            child: Semantics(
              label: 'Image ${index + 1}',
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 2,
                    color: indxx == index ? custom_green : Colors.blueAccent,
                  ),
                ),
                width: 140,
                margin: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Image.asset('images/$index.png'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  Widget tittle_widgets() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Semantics(
          label: 'Title input field',
          child: TextField(
            controller: title,
            focusNode: _focusNode1,
            style: const TextStyle(fontSize: 18, color: Colors.black),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              hintText: 'Title',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.blueAccent,
                  width: 2.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: custom_green,
                  width: 2.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  Padding subtitle_wedgite() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Semantics(
          label: 'Description input field',
          child: TextField(
            maxLines: 3,
            controller: subtitle,
            focusNode: _focusNode2,
            style: const TextStyle(fontSize: 18, color: Colors.black),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              hintText: 'Description',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.blueAccent,
                  width: 2.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: custom_green,
                  width: 2.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}