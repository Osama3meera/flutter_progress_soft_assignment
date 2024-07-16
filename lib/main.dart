import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:osama_hasan_progress_soft/di/injection.dart';
import 'package:osama_hasan_progress_soft/presentation/splash_screen/splash_screen.dart';

Future<void> main() async {
  await MyApp.initApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: false,
        ),
        home: SplashScreen());
  }

  static Future initApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    configureDependencies();
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCY46jDRWtuAQBuhnIPKBXfhjr0fpYVwXo",
            appId: "1:814513121974:android:3f0df5793fe065a151d417",
            messagingSenderId: "814513121974",
            projectId: "osama-hasan-progsoft1996"));
  }
}
