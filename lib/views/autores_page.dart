import 'package:flutter/material.dart';
import 'package:bibliotecapp_mobile/database/autor_dao.dart';
import 'package:bibliotecapp_mobile/models/autor.dart';
import 'package:bibliotecapp_mobile/views/add_autor.dart';
import 'package:bibliotecapp_mobile/views/autor_item.dart';

class AutoresPage extends StatefulWidget {
  const AutoresPage({super.key});

  @override
  State<AutoresPage> createState() => _AutoresPageState();
}

class _AutoresPageState extends State<AutoresPage> {
  void deleteAutor(Autor autor) async {
    await AutorDao.instance.remove(autor);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Autores",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<Autor>>(
        future: AutorDao.instance.getAutores(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "Nenhum Autor cadastrado",
                  style: TextStyle(color: colorScheme.onSurface),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Autor currentAutor = snapshot.data![index];
                return AutorItem(
                  autor: currentAutor,
                  deleteItem: () => deleteAutor(currentAutor),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: TextStyle(color: colorScheme.onSurface),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.surface,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddAutor()),
          );
          if (result == true) {
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}