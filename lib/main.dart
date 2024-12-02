import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Firebase 설정 파일
import 'auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // 앱의 루트 위젯
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Auth Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthWrapper(),
    );
  }
}
