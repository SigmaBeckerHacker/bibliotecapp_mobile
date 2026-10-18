import 'package:flutter/material.dart';
import 'package:bibliotecapp_mobile/models/user.dart';
import 'package:bibliotecapp_mobile/database/database_helper.dart';

class CadastroUserPage extends StatefulWidget {
  const CadastroUserPage({super.key});

  @override
  State<CadastroUserPage> createState() => _CadastroUserPageState();
}

class _CadastroUserPageState extends State<CadastroUserPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _ocultarSenha = true;

  Future<void> _cadastrarUsuario() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      String senhaHash = User.gerarHash(_senhaController.text);

      final db = await DatabaseHelper.instance.database;

      List<Map<String, dynamic>> existente = await db.query(
        'usuarios',
        where: 'email = ?',
        whereArgs: [email],
      );

      if (!mounted) return;

      if (existente.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Este e-mail já está cadastrado!'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      await db.insert('usuarios', {
        'email': email,
        'senha': senhaHash,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuário cadastrado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Cadastro'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.person_add_rounded,
                  size: 80,
                  color: Colors.blueAccent,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Crie sua conta',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Preencha os campos abaixo',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o e-mail';
                    }
                    if (!value.contains('@')) {
                      return 'Informe um e-mail válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _senhaController,
                  obscureText: _ocultarSenha,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _ocultarSenha
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _ocultarSenha = !_ocultarSenha;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe a senha';
                    }
                    if (value.length < 4) {
                      return 'A senha deve ter pelo menos 4 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _cadastrarUsuario,
                    child: const Text(
                      'CADASTRAR',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
