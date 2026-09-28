import 'package:flutter/material.dart';
import 'package:bibliotecapp_mobile/database/livro_dao.dart';
import 'package:bibliotecapp_mobile/views/add_livro.dart';
import 'package:bibliotecapp_mobile/views/livro_item.dart';
import 'package:bibliotecapp_mobile/models/livro.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void deleteLivro(Livro livro) {
    setState(() {
      LivroDao.instance.remove(livro);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bibliotecapp", style: TextStyle(fontWeight: FontWeight.w900),),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Bem Vindo!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),),
            ),
          ),
          Row(
            children: [
              
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Text(
              "Seus livros:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: LivroDao.instance.getLivros(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!.isEmpty
                      ? Center(child: Text("Nenhum Livro cadastrado", style: TextStyle(color: colorScheme.onSurface)))
                      : GridView.builder(
                          padding: const EdgeInsets.all(12.0),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12.0,
                            mainAxisSpacing: 12.0,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Livro currentLivro = snapshot.data![index];
                            return LivroItem(
                              livro: currentLivro,
                              deleteItem: () => deleteLivro(currentLivro),
                            );
                          },
                        );
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString(), style: TextStyle(color: colorScheme.onSurface)));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.surface,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddLivro()),
          );
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}