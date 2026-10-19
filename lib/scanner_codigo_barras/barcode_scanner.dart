import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  final MobileScannerController _controller = MobileScannerController(
    formats: [BarcodeFormat.ean13], // ISBNs utilizam o padrão EAN-13
  );

  bool _isScanned = false; // Garante que a leitura só seja disparada uma vez

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isScanned) return;

    for (final barcode in capture.barcodes) {
      if (barcode.rawValue != null && barcode.rawValue!.isNotEmpty) {
        // Limpa o código lido deixando apenas números/caracteres válidos do ISBN
        final String isbnLimpo =
            barcode.rawValue!.replaceAll(RegExp(r'[^0-9X]'), '');

        if (isbnLimpo.isNotEmpty) {
          setState(() {
            _isScanned = true;
          });

          _controller.stop();

          // Retorna apenas a String do ISBN limpo para a AddLivro
          Navigator.pop(context, isbnLimpo);
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear ISBN do Livro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            tooltip: 'Alternar Lanterna',
            onPressed: () => _controller.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            tooltip: 'Alternar Câmera',
            onPressed: () => _controller.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(
        controller: _controller,
        onDetect: _onDetect,
      ),
    );
  }
}