import 'dart:convert';
import 'package:bibliotecapp_mobile/models/livro.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class BookRepository {
  static Future<Livro?> fetchByIsbn(String isbn) async {
    final cleanIsbn = isbn.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanIsbn.isEmpty) return null;

    // 1. Tenta buscar no Open Library
    Livro? info = await _fetchFromOpenLibrary(cleanIsbn);
    
    // 2. Fallback: Tenta no Google Books se o Open Library não encontrar
    info ??= await _fetchFromGoogleBooks(cleanIsbn);

    return info;
  }

  /// Busca no Open Library API
  static Future<Livro?> _fetchFromOpenLibrary(String isbn) async {
    final url = Uri.parse(
      'https://openlibrary.org/api/books?bibkeys=ISBN:$isbn&format=json&jscmd=data',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final bookKey = 'ISBN:$isbn';

        if (data.containsKey(bookKey)) {
          final bookData = data[bookKey];
          
          final String titulo = bookData['title'] ?? 'Sem Título';

          String nomeAutor = 'Não Identificado';
          if (bookData['authors'] != null &&
              (bookData['authors'] as List).isNotEmpty) {
            nomeAutor = bookData['authors'][0]['name'] ?? 'Não Identificado';
          }

          String genero = 'Desconhecido';
          if (bookData['subjects'] != null &&
              (bookData['subjects'] as List).isNotEmpty) {
            genero = bookData['subjects'][0]['name'] ?? 'Desconhecido';
          }

          return Livro(
            titulo: titulo,
            autor: nomeAutor,
            genero: genero,
          );
        }
      }
    } catch (e) {
      debugPrint('Erro na Open Library API: $e');
    }
    return null;
  }

  /// Busca no Google Books API (Fallback)
  static Future<Livro?> _fetchFromGoogleBooks(String isbn) async {
    final url = Uri.parse(
      'https://www.googleapis.com/books/v1/volumes?q=isbn:$isbn',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['totalItems'] != null && (data['totalItems'] as int) > 0) {
          final volumeInfo = data['items'][0]['volumeInfo'];

          final String titulo = volumeInfo['title'] ?? 'Sem Título';

          String nomeAutor = 'Não Identificado';
          if (volumeInfo['authors'] != null &&
              (volumeInfo['authors'] as List).isNotEmpty) {
            nomeAutor = volumeInfo['authors'][0] ?? 'Não Identificado';
          }

          String genero = 'Desconhecido';
          if (volumeInfo['categories'] != null &&
              (volumeInfo['categories'] as List).isNotEmpty) {
            genero = volumeInfo['categories'][0] ?? 'Desconhecido';
          }

          return Livro(
            titulo: titulo,
            autor: nomeAutor,
            genero: genero,
          );
        }
      }
    } catch (e) {
      debugPrint('Erro na Google Books API: $e');
    }
    return null;
  }
}