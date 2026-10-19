import 'package:flutter/material.dart';
import 'package:bibliotecapp_mobile/models/autor.dart';
import 'package:bibliotecapp_mobile/views/add_autor.dart';

class AutorItem extends StatelessWidget {
  final Autor autor;
  final VoidCallback deleteItem;
  final VoidCallback onAutorUpdated;

  const AutorItem({
    super.key,
    required this.autor,
    required this.deleteItem,
    required this.onAutorUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade900,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(
            autor.nome.isNotEmpty ? autor.nome[0].toUpperCase() : '?',
            style: TextStyle(
              color: Theme.of(context).colorScheme.surface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          autor.nome,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white70, size: 22),
              onPressed: () async {
                final updated = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddAutor(autor: autor),
                  ),
                );

                if (updated == true) {
                  onAutorUpdated();
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent, size: 22),
              onPressed: deleteItem,
            ),
          ],
        ),
      ),
    );
  }
}