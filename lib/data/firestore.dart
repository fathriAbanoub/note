import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/model/notes_model.dart';
import 'package:uuid/uuid.dart';

class Firestore_Datasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> CreateUser(String email) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .set({"id": _auth.currentUser!.uid, "email": email});
      return true;
    } catch (e) {
      return true;
    }
  }

  Future<bool> AddNote(String subtitle, String title, int image) async {
    try {
      var uuid = const Uuid().v4();
      DateTime data = DateTime.now();
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(uuid)
          .set({
        'id': uuid,
        'subtitle': subtitle,
        'isDon': false,
        'image': image,
        'time': '${data.hour}:${data.minute}',
        'title': title,
      });
      return true;
    } catch (e) {
      print(e);
      return true;
    }
  }

  List getNotes(AsyncSnapshot snapshot) {
    try {
      final notesList = snapshot.data!.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Note(
          data['id'],
          data['subtitle'],
          data['time'],
          data['image'],
          data['title'],
          data['isDon'],
        );
      }).toList();
      return notesList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Stream<QuerySnapshot> stream(bool isDone) {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('notes')
        .where('isDon', isEqualTo: isDone)
        .snapshots();
  }

  Future<bool> isdone(String uuid, bool isDon) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(uuid)
          .update({'isDon': isDon});
      return true;
    } catch (e) {
      print(e);
      return true;
    }
  }

  Future<bool> Update_Note(String uuid, int image, String title,
      String subtitle) async {
    try {
      DateTime data = DateTime.now();
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(uuid)
          .update({
        'time': '${data.hour}:${data.minute}',
        'subtitle': subtitle,
        'title': title,
        'image': image,
      });
      return true;
    } catch (e) {
      print(e);
      return true;
    }
  }

  Future<bool> delet_note(String uuid) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(uuid)
          .delete();
      return true;
    } catch (e) {
      print(e);
      return true;
    }
  }

  Future<bool> addCategory(String name) async {
    try {
      var uuid = const Uuid().v4();
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('categories')
          .doc(uuid)
          .set({
        'id': uuid,
        'name': name,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateCategory(String id, String newName) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('categories')
          .doc(id)
          .update({
        'name': newName,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> deleteCategory(String id) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('categories')
          .doc(id)
          .delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> addNoteToCategory(String categoryId, String subtitle,
      String title, int image) async {
    try {
      var uuid = const Uuid().v4();
      DateTime now = DateTime.now();
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('categories')
          .doc(categoryId)
          .collection('notes')
          .doc(uuid)
          .set({
        'id': uuid,
        'subtitle': subtitle,
        'isDon': false,
        'image': image,
        'time': '${now.hour}:${now.minute}',
        'title': title,
      });
      print('Note added to category: $categoryId'); // Added print statement
      return true;
    } catch (e) {
      print('Error adding note to category: $e'); // Added print statement
      return false;
    }
  }

  List getCategoryNotes(AsyncSnapshot snapshot) {
    try {
      final notesList = snapshot.data!.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Note(
          data['id'],
          data['subtitle'],
          data['time'],
          data['image'],
          data['title'],
          data['isDon'],
        );
      }).toList();
      return notesList;
    } catch (e) {
      print('Error getting category notes: $e'); // Added print statement
      return [];
    }
  }

  Future<bool> updateNoteInCategory(String categoryId, String noteId, int image,
      String title, String subtitle) async {
    try {
      DateTime now = DateTime.now();
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('categories')
          .doc(categoryId)
          .collection('notes')
          .doc(noteId)
          .update({
        'time': '${now.hour}:${now.minute}',
        'subtitle': subtitle,
        'title': title,
        'image': image,
      });
      print('Note updated in category: $categoryId'); // Added print statement
      return true;
    } catch (e) {
      print('Error updating note in category: $e'); // Added print statement
      return false;
    }
  }

  Future<bool> deleteNoteInCategory(String categoryId, String noteId) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('categories')
          .doc(categoryId)
          .collection('notes')
          .doc(noteId)
          .delete();
      print('Note deleted from category: $categoryId'); // Added print statement
      return true;
    } catch (e) {
      print('Error deleting note from category: $e'); // Added print statement
      return false;
    }
  }

  Stream<QuerySnapshot> streamCategories() {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('categories')
        .snapshots();
  }

  Stream<QuerySnapshot> streamNotesInCategory(String categoryId,
      {bool? isDone}) {
    CollectionReference categoryRef = _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('categories')
        .doc(categoryId)
        .collection('notes');

    if (isDone != null) {
      return categoryRef.where('isDon', isEqualTo: isDone).snapshots();
    } else {
      return categoryRef.snapshots();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
class FirestoreDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String generateEventId() {
    return _firestore.collection('events').doc().id;
  }

  Future<void> addEventToFirestore(String eventId, String eventName, DateTime startDateTime, DateTime endDateTime) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('events').doc(eventId).set({
        'eventName': eventName,
        'startDateTime': startDateTime,
        'endDateTime': endDateTime,
        'userId': user.uid,
      });
    }
  }

  Future<void> updateEventInFirestore(String eventId, String eventName, DateTime startDateTime, DateTime endDateTime) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('events').doc(eventId).update({
        'eventName': eventName,
        'startDateTime': startDateTime,
        'endDateTime': endDateTime,
        'userId': user.uid,
      });
    }
  }
}


