import 'package:flutter/material.dart';
import 'package:bibliotecapp_mobile/views/home_page.dart';

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
        ),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          
          backgroundColor: Colors.amber, 
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}