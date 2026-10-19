import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LivroInfo {
  final String titulo;
  final String autor;
  final String genero;

  LivroInfo({
    required this.titulo,
    required this.autor,
    required this.genero,
  });
}

class BookRepository {
  /// Busca as informações do livro pelo ISBN.
  static Future<LivroInfo?> fetchByIsbn(String rawIsbn) async {
    final cleanIsbn = rawIsbn.replaceAll(RegExp(r'[^0-9X]'), '');

    if (cleanIsbn.isEmpty) return null;

    // 1. Tenta primeiro a Google Books API (Resposta muito mais rápida)
    try {
      final googleBooksResult = await _fetchFromGoogleBooks(cleanIsbn);
      if (googleBooksResult != null) {
        return googleBooksResult;
      }
    } catch (e) {
      print('Erro no Google Books: $e');
    }

    // 2. Fallback: Open Library API com timeout de 4 segundos para não travar
    try {
      final openLibraryResult = await _fetchFromOpenLibrary(cleanIsbn);
      if (openLibraryResult != null) {
        return openLibraryResult;
      }
    } catch (e) {
      print('Erro na Open Library: $e');
    }

    return null;
  }

  static Future<LivroInfo?> _fetchFromGoogleBooks(String isbn) async {
    final url = Uri.parse(
      'https://www.googleapis.com/books/v1/volumes?q=isbn:$isbn',
    );

    // Define timeout de 4 segundos
    final response = await http.get(url).timeout(const Duration(seconds: 4));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data['totalItems'] != null && data['totalItems'] > 0) {
        final volumeInfo = data['items'][0]['volumeInfo'];

        final String titulo = volumeInfo['title'] ?? 'Título Desconhecido';

        String autor = 'Autor não identificado';
        if (volumeInfo['authors'] != null &&
            (volumeInfo['authors'] as List).isNotEmpty) {
          autor = volumeInfo['authors'][0];
        }

        String genero = 'Geral';
        if (volumeInfo['categories'] != null &&
            (volumeInfo['categories'] as List).isNotEmpty) {
          genero = volumeInfo['categories'][0];
        }

        return LivroInfo(titulo: titulo, autor: autor, genero: genero);
      }
    }
    return null;
  }

  static Future<LivroInfo?> _fetchFromOpenLibrary(String isbn) async {
    final url = Uri.parse(
      'https://openlibrary.org/api/books?bibkeys=ISBN:$isbn&jscmd=data&format=json',
    );

    // Define timeout de 4 segundos
    final response = await http.get(url).timeout(const Duration(seconds: 4));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final key = 'ISBN:$isbn';

      if (data.containsKey(key)) {
        final bookData = data[key];

        final String titulo = bookData['title'] ?? 'Título Desconhecido';

        String autor = 'Autor não identificado';
        if (bookData['authors'] != null &&
            (bookData['authors'] as List).isNotEmpty) {
          autor = bookData['authors'][0]['name'] ?? autor;
        }

        String genero = 'Geral';
        if (bookData['subjects'] != null &&
            (bookData['subjects'] as List).isNotEmpty) {
          genero = bookData['subjects'][0]['name'] ?? genero;
        }

        return LivroInfo(titulo: titulo, autor: autor, genero: genero);
      }
    }
    return null;
  }
}