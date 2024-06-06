import 'package:flutter/material.dart';
import 'package:notes/const/colors.dart';
import 'package:notes/data/firestore.dart';
import 'package:notes/model/notes_model.dart';

class Edit_Screen extends StatefulWidget {
  final Note _note;
  const Edit_Screen(this._note, {super.key});

  @override
  State<Edit_Screen> createState() => _Edit_ScreenState();
}

class _Edit_ScreenState extends State<Edit_Screen> {
  TextEditingController? title;
  TextEditingController? subtitle;

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  int indexx = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    title = TextEditingController(text: widget._note.title);
    subtitle = TextEditingController(text: widget._note.subtitle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Изменить заметку'),
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
          label: 'коснитесь дважды, чтобы сохранить изменения',
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent,
              minimumSize: const Size(170, 48),
            ),
            onPressed: () {
              Firestore_Datasource().Update_Note(
                  widget._note.id, indexx, title!.text, subtitle!.text);
              Navigator.pop(context);
            },
            child: const Text(
              'Сохранить',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Semantics(
          label: 'коснитесь дважды, чтобы отменить',
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              minimumSize: const Size(170, 48),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Отменить',
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
                indexx = index;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 2,
                  color: indexx == index ? custom_green : Colors.blueAccent,
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
        child: TextField(
          controller: title,
          focusNode: _focusNode1,
          style: const TextStyle(fontSize: 18, color: Colors.black),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            hintText: 'название заметки',
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
        child: TextField(
          maxLines: 3,
          controller: subtitle,
          focusNode: _focusNode2,
          style: const TextStyle(fontSize: 18, color: Colors.black),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            hintText: 'Введите свою заметку',
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
    );
  }
}
