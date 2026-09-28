import 'package:flutter/material.dart';
import 'package:bibliotecapp_mobile/database/livro_dao.dart';
import 'package:bibliotecapp_mobile/models/livro.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.livro == null ? const Text("Adicionar Livro") : const Text("Alterando o Livro")
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
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
                onPressed: () async {
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
                      LivroDao.instance.update(widget.livro!);
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
    );
  }
}