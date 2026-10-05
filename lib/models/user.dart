import 'dart:convert';

import 'package:crypto/crypto.dart';

class User {
  int id;
  String email;
  String senhaHash;

  User({
    required this.id,
    required this.email,
    required this.senhaHash, 
  });

  static String gerarHash(String senha) {
    var bytes = utf8.encode(senha);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  factory User.fromMap(Map<String, dynamic> json) => User(
    id: json['id'],
    email: json['email'],
    senhaHash: json['senha'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'email': email,
    'senha': senhaHash,
  };
}