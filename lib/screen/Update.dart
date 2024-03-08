import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateStudent extends StatefulWidget {
  const UpdateStudent({Key? key}) : super(key: key);

  @override
  State<UpdateStudent> createState() => _UpdateStudentState();
}

class _UpdateStudentState extends State<UpdateStudent> {
  final CollectionReference studentlist =
      FirebaseFirestore.instance.collection('studentList');
  TextEditingController StdName = TextEditingController();
  TextEditingController StdBatch = TextEditingController();
  TextEditingController StdWeek = TextEditingController();
  TextEditingController StdDomain = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers here if needed
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final docId = args['id'];

    // Assign values to controllers only when the widget is initially built
    StdName.text = args['name'];
    StdBatch.text = args['batch'];
    StdWeek.text = args['week'];
    StdDomain.text = args['domain'];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Update Student"),
          backgroundColor: const Color.fromARGB(255, 47, 7, 193),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              TextField(
                controller: StdName,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "name",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: StdBatch,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "batch",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: StdWeek,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Week",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: StdDomain,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "domain",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  updateStudent(docId);
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(200, 50)),
                  backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 47, 7, 193),
                  ),
                ),
                child: const Text(
                  'Update',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateStudent(docId) {
    final data = {
      'name': StdName.text,
      'batch': StdBatch.text,
      'week': StdWeek.text,
      'domain': StdDomain.text,
    };
    studentlist.doc(docId).update(data);
  }
}
