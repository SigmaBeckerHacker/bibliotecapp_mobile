import 'package:bibliotecapp_mobile/scanner_codigo_barras/book_repository.dart';
import 'package:bibliotecapp_mobile/views/add_livro.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerScreen extends StatefulWidget {
  final List<Autor> autoresCadastrados;

  const BarcodeScannerScreen({super.key, required this.autoresCadastrados});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  final MobileScannerController _controller = MobileScannerController(
    formats: [BarcodeFormat.ean13], // ISBNs utilizam o formato EAN-13
  );
  bool _isLoading = false;

  void _onDetect(BarcodeCapture capture) async {
    if (_isLoading) return;

    for (final barcode in capture.barcodes) {
      if (barcode.rawValue != null) {
        setState(() {
          _isLoading = true;
        });

        _controller.stop(); // Pausa a câmera durante a busca

        final isbn = barcode.rawValue!;
        final livroInfo = await BookRepository.fetchByIsbn(isbn);

        if (!mounted) return;

        if (livroInfo != null) {
          // Navega para a tela de cadastro preenchendo os campos
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AddLivro(
                livro: livroInfo,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Livro não encontrado na base de dados.')),
          );
          _controller.start();
          setState(() {
            _isLoading = false;
          });
        }
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear ISBN do Livro')),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}