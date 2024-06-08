import 'package:cloud_firestore/cloud_firestore.dart';

class Note1 {
  String id;
  String title;
  String subtitle;
  int image;
  String categoryId; // Define categoryId property
  final bool isDon;

  Note1({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.categoryId,
    required this.isDon, required time,
  });
  factory Note1.fromSnapshot(DocumentSnapshot doc) {
    return Note1(
      id: doc.id,
      title: doc['title'],
      subtitle: doc['subtitle'],
      image: doc['image'],
      time: doc['time'],
      isDon: doc['isDon'], categoryId: '',
    );
  }
}
