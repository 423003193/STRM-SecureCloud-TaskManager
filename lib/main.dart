import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'utils/constants.dart';

/// Tracks whether Firebase was successfully initialized.
bool firebaseInitialized = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseInitialized = true;
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
    firebaseInitialized = false;
  }

  runApp(const STRMApp());
}

class STRMApp extends StatelessWidget {
  const STRMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'STRM SecureCloud',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.primaryBg,
        scaffoldBackgroundColor: AppColors.primaryBg,
        fontFamily: 'Inter',
      ),
      home: const LoginScreen(),
    );
  }
}
