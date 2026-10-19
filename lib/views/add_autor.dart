import 'package:flutter/material.dart';
import 'package:bibliotecapp_mobile/database/autor_dao.dart';
import 'package:bibliotecapp_mobile/models/autor.dart';

class AddAutor extends StatefulWidget {
  final Autor? autor;
  const AddAutor({super.key, this.autor});

  @override
  State<AddAutor> createState() => _AddAutorState();
}

class _AddAutorState extends State<AddAutor> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.autor != null) {
      _nomeController.text = widget.autor!.nome;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.autor == null
            ? const Text("Adicionar Autor")
            : const Text("Alterando o Autor"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: "Nome do Autor",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Informe o nome do autor' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final nome = _nomeController.text.trim();

                    if (widget.autor == null) {
                      Autor novoAutor = Autor(nome: nome);
                      int id = await AutorDao.instance.add(novoAutor);
                      novoAutor = Autor(id: id, nome: nome);
                    } else {
                      final autorAtualizado = Autor(
                        id: widget.autor!.id,
                        nome: nome,
                      );
                      await AutorDao.instance.update(autorAtualizado);
                    }

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Autor salvo com sucesso!")),
                    );
                    
                    Navigator.pop(context, true);
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