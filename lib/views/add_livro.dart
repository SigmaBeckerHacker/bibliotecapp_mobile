import 'package:flutter/material.dart';
import 'package:bibliotecapp_mobile/database/livro_dao.dart';
import 'package:bibliotecapp_mobile/models/livro.dart';
import 'package:bibliotecapp_mobile/scanner_codigo_barras/barcode_scanner.dart';
import 'package:bibliotecapp_mobile/scanner_codigo_barras/book_repository.dart';

class AddLivro extends StatefulWidget {
  final Livro? livro;
  const AddLivro({super.key, this.livro});

  @override
  State<AddLivro> createState() => _AddLivroState();
}

class _AddLivroState extends State<AddLivro> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _autorController = TextEditingController();
  final TextEditingController _generoController = TextEditingController();
  
  bool _foiLido = false;
  bool _isCarregandoBook = false; // Controla o estado de loading ao buscar API

  @override
  void initState() {
    super.initState();
    if(widget.livro != null) {
      _tituloController.text = widget.livro!.titulo;
      _autorController.text = widget.livro!.autor;
      _generoController.text = widget.livro!.genero;
      _foiLido = widget.livro!.foi_lido; 
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _autorController.dispose();
    _generoController.dispose();
    super.dispose();
  }

  Future<void> _escanearEPreencher() async {
    final String? isbnLido = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const BarcodeScannerScreen()),
    );

    if (isbnLido == null || isbnLido.isEmpty || !mounted) return;

    setState(() {
      _isCarregandoBook = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Buscando informações do livro...')),
    );

    // Consulta a API pública pelo ISBN
    final livroInfo = await BookRepository.fetchByIsbn(isbnLido);

    if (!mounted) return;

    setState(() {
      _isCarregandoBook = false;
    });

    if (livroInfo != null) {
      // Preenche os campos de texto com os dados retornados
      setState(() {
        _tituloController.text = livroInfo.titulo;
        _autorController.text = livroInfo.nomeAutor;
        _generoController.text = livroInfo.genero;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dados do livro preenchidos com sucesso!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Livro não encontrado para este código de barras.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.livro == null ? const Text("Adicionar Livro") : const Text("Alterando o Livro"),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Botão para ler o código de barras
                  ElevatedButton.icon(
                    onPressed: _isCarregandoBook ? null : _escanearEPreencher,
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text("Escanear Código de Barras (ISBN)"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 15),

                  TextFormField(
                    controller: _tituloController,
                    decoration: const InputDecoration(labelText: "Título do Livro", border: OutlineInputBorder()),
                    validator: (value) => value == null || value.isEmpty ? 'Informe o título' : null,
                  ),
                  const SizedBox(height: 10),
                  
                  TextFormField(
                    controller: _autorController,
                    decoration: const InputDecoration(labelText: "Autor", border: OutlineInputBorder()),
                    validator: (value) => value == null || value.isEmpty ? 'Informe o autor' : null,
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: _generoController,
                    decoration: const InputDecoration(labelText: "Gênero (ex: Ficção, Fantasia)", border: OutlineInputBorder()),
                    validator: (value) => value == null || value.isEmpty ? 'Informe o gênero' : null,
                  ),
                  const SizedBox(height: 10),

                  DropdownButtonFormField<bool>(
                    value: _foiLido,
                    decoration: const InputDecoration(
                      labelText: "Status de Leitura", 
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: true, child: Text("Sim (Lido)")),
                      DropdownMenuItem(value: false, child: Text("Não (Quero Ler)")),
                    ],
                    onChanged: (bool? novoValor) {
                      if (novoValor != null) {
                        setState(() {
                          _foiLido = novoValor;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  ElevatedButton(
                    onPressed: _isCarregandoBook ? null : () async {
                      if (_formKey.currentState!.validate()) {
                        
                        if (widget.livro == null) {
                          Livro novoLivro = Livro(
                            titulo: _tituloController.text,
                            autor: _autorController.text,
                            genero: _generoController.text,
                            foi_lido: _foiLido,
                          ); 
                          int id = await LivroDao.instance.add(novoLivro);
                          novoLivro.id = id;
                        } else {
                          widget.livro!.titulo = _tituloController.text;
                          widget.livro!.autor = _autorController.text;
                          widget.livro!.genero = _generoController.text;
                          widget.livro!.foi_lido = _foiLido;
                          await LivroDao.instance.update(widget.livro!);
                        }

                        if (!context.mounted) {
                          return; 
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Salvando livro..."))
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Salvar"),
                  ),
                ],
              ),
            ),
          ),
          
          // Overlay de carregamento enquanto busca dados da API
          if (_isCarregandoBook)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}