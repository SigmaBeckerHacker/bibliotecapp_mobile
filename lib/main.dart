import 'package:bibliotecapp_mobile/views/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catalogo de Livros',
      theme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(
          surface: Colors.black,
          primary: Colors.amber,
          onSurface: Colors.white,
          secondary: Colors.green,
          primaryContainer: Color.fromARGB(255, 32, 32, 32),
          shadow: Colors.grey,
        ),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          
          backgroundColor: Colors.amber, 
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}