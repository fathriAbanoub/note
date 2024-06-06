import 'package:flutter/material.dart';
import 'package:notes/const/colors.dart';
import 'package:notes/data/firestore.dart';
import 'package:notes/screen/edit_screen.dart';
import '../model/notes_model.dart';

class Task_Widget_Category extends StatefulWidget {
  final Note note;
  final String categoryId;

  const Task_Widget_Category(this.note, this.categoryId, {super.key});

  @override
  State<Task_Widget_Category> createState() => _Task_Widget_CategoryState();
}

class _Task_Widget_CategoryState extends State<Task_Widget_Category> {
  bool isDone = false;

  @override
  void initState() {
    super.initState();
    isDone = widget.note.isDon;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              // Image
              imageee(),
              const SizedBox(width: 20),
              // Title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.note.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Checkbox(
                          activeColor: custom_green,
                          value: isDone,
                          onChanged: (value) {
                            setState(() {
                              isDone = value ?? false;
                            });
                            Firestore_Datasource().updateNoteInCategory(
                              widget.categoryId,
                              widget.note.id,
                              widget.note.image,
                              widget.note.title,
                              widget.note.subtitle,
                            );
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.note.subtitle,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const Spacer(),
                    edit_time(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget edit_time() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 90,
            height: 28,
            decoration: BoxDecoration(
              color: custom_green,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              child: Row(
                children: [
                  Image.asset('images/icon_time.png'),
                  const SizedBox(width: 10),
                  Text(
                    widget.note.time,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 20),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Edit_Screen(widget.note),
              ));
            },
            child: Container(
              width: 90,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0xffE2F6F1),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: Row(
                  children: [
                    Image.asset('images/icon_edit.png'),
                    const SizedBox(width: 10),
                    const Text(
                      'edit',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget imageee() {
    return Container(
      height: 130,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('images/${widget.note.image}.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
