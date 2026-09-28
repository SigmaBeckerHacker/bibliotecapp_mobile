class Livro {
  int? id;
  String titulo;
  String autor;
  String genero;
  bool foi_lido;

  Livro({
    this.id,
    required this.titulo,
    required this.autor,
    required this.genero,
    this.foi_lido = false, 
  });

  void alternarStatusLeitura() {
    foi_lido = !foi_lido; 
  }

  factory Livro.fromMap(Map<String, dynamic> json) => Livro(
    id: json['id'],
    titulo: json['titulo'],
    autor: json['autor'],
    genero: json['genero'],
    foi_lido: json['foi_lido'] == 0 ? false : true,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'titulo': titulo,
    'autor': autor,
    'genero': genero,
    'foi_lido': foi_lido ? 1 : 0,
  };
}