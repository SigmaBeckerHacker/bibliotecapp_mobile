import 'package:bibliotecapp_mobile/database/autor_dao.dart';
import 'package:flutter/material.dart';
import 'package:bibliotecapp_mobile/database/livro_dao.dart';
import 'package:bibliotecapp_mobile/models/autor.dart';
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
  final TextEditingController _generoController = TextEditingController();

  final Autor _autorNaoIdentificado = Autor(id: 0, nome: 'Autor não identificado');
  List<Autor> _listaAutores = [];
  Autor? _autorSelecionado;

  bool _foiLido = false;
  bool _isCarregandoBook = false;
  bool _isCarregandoAutores = true;

  @override
  void initState() {
    super.initState();
    _carregarAutores();
  }

  Future<void> _carregarAutores() async {
    final autoresDoBanco = await AutorDao.instance.getAutores();

    if (!mounted) return;

    setState(() {
      _listaAutores = [_autorNaoIdentificado, ...autoresDoBanco];

      if (widget.livro != null) {
        _tituloController.text = widget.livro!.titulo;
        _generoController.text = widget.livro!.genero;
        _foiLido = widget.livro!.foi_lido;

        _autorSelecionado = _encontrarOuFallback(widget.livro!.autor);
      } else {
        _autorSelecionado = _autorNaoIdentificado;
      }

      _isCarregandoAutores = false;
    });
  }

  Autor _encontrarOuFallback(String nomeAutor) {
    return _listaAutores.firstWhere(
      (a) => a.nome.toLowerCase().trim() == nomeAutor.toLowerCase().trim(),
      orElse: () => _autorNaoIdentificado,
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _generoController.dispose();
    super.dispose();
  }

  Future<void> _escanearEPreencher() async {
  final dynamic resultado = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const BarcodeScannerScreen()),
  );

  if (resultado == null || resultado.toString().isEmpty || !mounted) return;

  final String isbnLido = resultado.toString();

  setState(() {
    _isCarregandoBook = true;
  });

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Buscando informações do livro...')),
  );

  final livroInfo = await BookRepository.fetchByIsbn(isbnLido);

  if (!mounted) return;

  setState(() {
    _isCarregandoBook = false;
  });

  if (livroInfo != null) {
    setState(() {
      _tituloController.text = livroInfo.titulo;
      _generoController.text = livroInfo.genero;
      _autorSelecionado = _encontrarOuFallback(livroInfo.autor);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dados preenchidos! Clique em Salvar para registrar.')),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Livro não encontrado para este código de barras.')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: widget.livro == null
            ? const Text("Adicionar Livro")
            : const Text("Alterando o Livro"),
      ),
      body: _isCarregandoAutores
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [                    
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
                          decoration: const InputDecoration(
                            labelText: "Título do Livro",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              value == null || value.isEmpty ? 'Informe o título' : null,
                        ),
                        const SizedBox(height: 10),
                    
                        DropdownButtonFormField<Autor>(
                          value: _autorSelecionado,
                          decoration: const InputDecoration(
                            labelText: "Autor",
                            border: OutlineInputBorder(),
                          ),
                          items: _listaAutores.map((autor) {
                            return DropdownMenuItem<Autor>(
                              value: autor,
                              child: Text(autor.nome),
                            );
                          }).toList(),
                          onChanged: (Autor? novoAutor) {
                            if (novoAutor != null) {
                              setState(() {
                                _autorSelecionado = novoAutor;
                              });
                            }
                          },
                          validator: (value) =>
                              value == null ? 'Selecione um autor' : null,
                        ),
                        const SizedBox(height: 10),

                        TextFormField(
                          controller: _generoController,
                          decoration: const InputDecoration(
                            labelText: "Gênero (ex: Ficção, Fantasia)",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              value == null || value.isEmpty ? 'Informe o gênero' : null,
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
                          onPressed: _isCarregandoBook
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    final String autorNome =
                                        _autorSelecionado?.nome ?? 'Autor não identificado';

                                    if (widget.livro == null) {
                                      Livro novoLivro = Livro(
                                        titulo: _tituloController.text,
                                        autor: autorNome,
                                        genero: _generoController.text,
                                        foi_lido: _foiLido,
                                      );
                                      int id = await LivroDao.instance.add(novoLivro);
                                      novoLivro.id = id;
                                    } else {
                                      widget.livro!.titulo = _tituloController.text;
                                      widget.livro!.autor = autorNome;
                                      widget.livro!.genero = _generoController.text;
                                      widget.livro!.foi_lido = _foiLido;
                                      await LivroDao.instance.update(widget.livro!);
                                    }

                                    if (!context.mounted) return;

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Salvando livro...")),
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
 
                if (_isCarregandoBook)
                  Container(
                    color: colorScheme.surface,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
    );
  }
}