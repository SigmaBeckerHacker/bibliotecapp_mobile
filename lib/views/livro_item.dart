import 'package:flutter/material.dart';
import 'package:bibliotecapp_mobile/database/livro_dao.dart';
import 'package:bibliotecapp_mobile/models/livro.dart';
import 'package:bibliotecapp_mobile/views/add_livro.dart';

class LivroItem extends StatefulWidget {
  final Livro livro; 
  final Function() deleteItem;

  const LivroItem({super.key, required this.livro, required this.deleteItem});

  @override
  State<LivroItem> createState() => _LivroItemState();
}

class _LivroItemState extends State<LivroItem> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.livro.alternarStatusLeitura();
                    });
                    LivroDao.instance.update(widget.livro);
                  },
                  child: Icon(
                    widget.livro.foi_lido ? Icons.book : Icons.book_outlined,
                    color: widget.livro.foi_lido ? colorScheme.primary : colorScheme.shadow,
                    size: 28,
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddLivro(livro: widget.livro),
                          ),
                        );
                        setState(() {});
                      },
                      child:  Icon(Icons.edit, color: colorScheme.onSurface, size: 20),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: widget.deleteItem,
                      child: Icon(Icons.delete, color: colorScheme.error, size: 20),
                    ),
                  ],
                ),
              ],
            ),
            
            const Spacer(),

            Text(
              widget.livro.titulo,
              style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colorScheme.onSurface),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              widget.livro.autor,
              style:  TextStyle(fontSize: 14, color: colorScheme.onSurface),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            
            const Spacer(),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                widget.livro.genero,
                style: TextStyle(fontSize: 12, color: colorScheme.primary, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}