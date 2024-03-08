// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webapp/screen/home.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({Key? key});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  TextEditingController StdName = TextEditingController();
  TextEditingController StdBatch = TextEditingController();
  TextEditingController StdWeek = TextEditingController();
  TextEditingController StdDomain = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final CollectionReference studentlist =
      FirebaseFirestore.instance.collection('studentList');

  Future<String?> uploadImage(Uint8List imageData, String fileName) async {
    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref('studentimage')
          .child(fileName);
      final metadata =
          firebase_storage.SettableMetadata(contentType: 'image/jpeg');
      await ref.putData(imageData, metadata);

      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      return null;
    }
  }

  void addStudent() async {
    if (_formKey.currentState!.validate()) {
      String? imageUrl;
      if (_isPhotoSelected) {
        imageUrl = await uploadImage(selectedImageInBytes!, imagePath!);
      }

      final data = {
        'name': StdName.text,
        'batch': StdBatch.text,
        'week': StdWeek.text,
        'domain': StdDomain.text,
        'imageURL': imageUrl ?? 'asset/45678.png',
      };

      studentlist.add(data);
    }
  }

  Future<void> selectImage() async {
    var picked = await FilePicker.platform.pickFiles();

    if (picked != null) {
      setState(() {
        imagePath = picked.files.first.name;
        selectedImageInBytes = picked.files.first.bytes;
        _isPhotoSelected = true;
        photoerrorVisible = false;
      });
    }
  }

  String? groupValue;
  String? imagePath;
  Uint8List? selectedImageInBytes;

  bool _isPhotoSelected = false;
  bool photoerrorVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Student"),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    selectImage(); // Call the selectImage function here
                  },
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle, // Set the shape to circle
                      color: Colors.cyan,
                    ),
                    child: selectedImageInBytes == null
                        ? ClipOval(
                            child: Image.network(
                              'https://st4.depositphotos.com/11574170/25191/v/450/depositphotos_251916955-stock-illustration-user-glyph-color-icon.jpg',
                              fit: BoxFit.cover,
                              width: 160,
                              height: 160,
                            ),
                          )
                        : ClipOval(
                            child: Image.memory(
                              selectedImageInBytes!,
                              fit: BoxFit.cover,
                              width: 160,
                              height: 160,
                            ),
                          ),
                  ),
                ),
                const Positioned(
                  right: 0,
                  top: 120,
                  child: CircleAvatar(
                    radius: 17,
                    backgroundColor: Color.fromARGB(255, 10, 199, 251),
                  ),
                ),
                const Positioned(
                  right: 5,
                  top: 127,
                  child: Icon(Icons.add_a_photo),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            if (photoerrorVisible && imagePath == null)
              const Text(
                'Please add a photo',
                style: TextStyle(color: Colors.red),
              ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: StdName,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Student Name",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: StdBatch,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Batch",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a class';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: StdWeek,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Week",
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a division';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: StdDomain,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Domain",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a division';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all(const Size(250, 50)),
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                    ),
                    onPressed: () async {
                      if (!_isPhotoSelected) {
                        setState(() {
                          photoerrorVisible = true;
                        });
                      }

                      if (_formKey.currentState!.validate() &&
                          _isPhotoSelected == true) {
                        String? url = await uploadImage(
                            selectedImageInBytes!, imagePath!);
                        addStudent();
                        Navigator.of(context).pop();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const HomePage()),
                            (route) => false);
                      } else {
                        return;
                      }
                    },
                    child: const Text("Submit"),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
