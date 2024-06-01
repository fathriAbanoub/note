import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/data/firestore.dart';
import 'package:notes/screen/Category_Detail_Page.dart';
import './Category_Notes.dart';
import '../widget/Stream_Category_notes.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final Firestore_Datasource _firestoreDatasource = Firestore_Datasource();
  final TextEditingController _categoryController = TextEditingController();

  String? categoryId; // Define categoryId variable

  void _addCategory() async {
    if (_categoryController.text.isNotEmpty) {
      await _firestoreDatasource.addCategory(_categoryController.text);
      _categoryController.clear();
    }
  }

  void _editCategory(String id, String currentName) {
    _categoryController.text = currentName;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Category'),
        content: TextField(
          controller: _categoryController,
          decoration: InputDecoration(labelText: 'Category Name'),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (_categoryController.text.isNotEmpty) {
                await _firestoreDatasource.updateCategory(
                    id, _categoryController.text);
                _categoryController.clear();
                Navigator.pop(context);
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteCategory(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Category'),
        content: Text('Are you sure you want to delete this category?'),
        actions: [
          TextButton(
            onPressed: () async {
              await _firestoreDatasource.deleteCategory(id);
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestoreDatasource.streamCategories(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final categories = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final categoryName = category['name'];
                    final categoryId = category.id;

                    return Dismissible(
                      key: Key(categoryId),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) async {
                        await _firestoreDatasource.deleteCategory(categoryId);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Category $categoryName deleted'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      },
                      background: Container(color: Colors.red),
                      child: ListTile(
                        title: Text(categoryName),
                        trailing: IconButton(
                          icon: Icon(Icons.edit, color: Colors.red),
                          onPressed: () =>
                              _editCategory(categoryId, categoryName),
                        ),
                        onTap: () {
                          setState(() {
                            this.categoryId = categoryId;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CategoryDetailPage(categoryId: categoryId),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          if (categoryId != null)
            StreamNoteCategory(
              categoryId: categoryId!,
            ), // Display notes within the category
          SizedBox(height: 20),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _categoryController.clear();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Add Category'),
              content: TextField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: 'Category Name'),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _addCategory();
                    Navigator.pop(context);
                  },
                  child: Text('Add'),
                ),
              ],
            ),
          );
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add),
      ),
    );
  }
}
