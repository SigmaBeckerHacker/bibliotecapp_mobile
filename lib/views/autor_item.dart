import 'package:flutter/material.dart';
import 'package:bibliotecapp_mobile/models/autor.dart';
import 'package:bibliotecapp_mobile/views/add_autor.dart';

class AutorItem extends StatefulWidget {
  final Autor autor;
  final Function() deleteItem;

  const AutorItem({
    super.key,
    required this.autor,
    required this.deleteItem,
  });

  @override
  State<AutorItem> createState() => _AutorItemState();
}

class _AutorItemState extends State<AutorItem> {
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
            widget.autor.nome.isNotEmpty ? widget.autor.nome[0].toUpperCase() : '?',
            style: TextStyle(
              color: Theme.of(context).colorScheme.surface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          widget.autor.nome,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddAutor(autor: widget.autor),
                  ),
                );
                if (result == true) {
                  setState(() {});
                }
              },
              child: const Icon(Icons.edit, color: Colors.white70, size: 22),
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: widget.deleteItem,
              child: const Icon(Icons.delete, color: Colors.redAccent, size: 22),
            ),
          ],
        ),
      ),
    );
  }
}