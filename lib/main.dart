import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'Theme/theme.dart';
import 'Login/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  
  // await windowManager.setFullScreen(true);

  

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "PLSP",
      theme: MyTheme.lightTheme,
      home: const LoginWidget(),
    );
  }
}