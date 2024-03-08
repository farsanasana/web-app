import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webapp/screen/Update.dart';
import 'package:webapp/screen/addStudent.dart';
import 'package:webapp/screen/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAmde8cRtWo-mHtTcDx4KSt5L9Dng9B5Rs",
            authDomain: "webapp-c8f37.firebaseapp.com",
            projectId: "webapp-c8f37",
            storageBucket: "webapp-c8f37.appspot.com",
            messagingSenderId: "983965515734",
            appId: "1:983965515734:web:5a6519964a865c2764ae77"));
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student List',
      routes: {
        '/': (context) => const HomePage(),
        '/add': (context) => const AddStudent(),
        '/update': (context) => const UpdateStudent(),
      },
      initialRoute: '/',
    );
  }
}
