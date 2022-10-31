import 'package:firebase_core/firebase_core.dart';
import 'package:hiklik_app/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:hiklik_app/ui/pages/profile_page.dart';
import 'package:hiklik_app/ui/pages/profile_edit_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    );
  }
}
