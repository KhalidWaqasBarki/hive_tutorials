import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_tutorials/models/notes_model.dart';

import 'boxes/boxes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notes',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ValueListenableBuilder<Box<NotesModel>>(
            valueListenable: Boxes.getData().listenable(),
            builder: (context, box, _) {
              var data = box.values.toList().cast<NotesModel>();
              return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  data[index].title.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                    onPressed: () {
                                      delete(data[index]);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    )),
                                const SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                    onPressed: () {
                                      _editMyDialogue(
                                          data[index],
                                          data[index].title,
                                          data[index].description);
                                    },
                                    icon: const Icon(Icons.edit)),
                              ],
                            ),
                            Text(data[index].description.toString()),
                          ],
                        ),
                      ),
                    );
                  });
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showMyDialogue();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void delete(NotesModel notesModel) async {
    await notesModel.delete();
  }

  Future<void> _editMyDialogue(
      NotesModel notesModel, String title, String description) async {
    titleController.text = title;
    descriptionController.text = description;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey[200],
            title: const Text('Edit Notes'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    titleController.clear();
                    descriptionController.clear();
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () async {
                    notesModel.title = titleController.text.toString();
                    notesModel.description =
                        descriptionController.text.toString();
                    await notesModel.save();
                    Navigator.pop(context);
                    titleController.clear();
                    descriptionController.clear();

                  },
                  child: const Text('Update')),
            ],
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                        fillColor: Colors.grey[300],
                        filled: true,
                        hintText: 'Edit Title',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25))),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      fillColor: Colors.grey[300],
                      filled: true,
                      hintText: 'Edit your notes',
                      border: OutlineInputBorder(

                          borderRadius: BorderRadius.circular(25)),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _showMyDialogue() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey[200],
            title: const Text('Add Notes'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    final data = NotesModel(
                        title: titleController.text,
                        description: descriptionController.text);
                    final box = Boxes.getData();
                    box.add(data);
                    data.save();
                    titleController.clear();
                    descriptionController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text('Add')),
            ],
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                        fillColor: Colors.grey[300],
                        filled: true,
                        hintText: 'Enter Title',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      fillColor: Colors.grey[300],
                      filled: true,
                      hintText: 'Enter Description',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
