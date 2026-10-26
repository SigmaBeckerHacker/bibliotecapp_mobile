import 'package:flutter/material.dart';
import 'package:bibliotecapp_mobile/models/user.dart';
import 'package:bibliotecapp_mobile/database/user_dao.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      String senhaHash = User.gerarHash(_senhaController.text);

      bool jaExiste = await UserDao.instance.emailExiste(email);

      if (!mounted) return;

      if (jaExiste) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Este e-mail já está cadastrado!'),
            backgroundColor: colorScheme.primary,
          ),
        );
        return;
      }

      await UserDao.instance.cadastrarUsuario(email, senhaHash);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Usuário cadastrado com sucesso!'),
          backgroundColor: colorScheme.secondary,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Cadastro'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_add_rounded,
                  size: 80,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Crie sua conta',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Preencha os campos abaixo',
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 32),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: colorScheme.onSurface),
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    labelStyle: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: colorScheme.primary,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: colorScheme.onSurface.withValues(alpha: 0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: colorScheme.primary,
                        width: 2,
                      ),
                    ),
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
                  style: TextStyle(color: colorScheme.onSurface),
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    labelStyle: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    prefixIcon: Icon(
                      Icons.lock_outlined,
                      color: colorScheme.primary,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _ocultarSenha
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: colorScheme.primary,
                      ),
                      onPressed: () {
                        setState(() {
                          _ocultarSenha = !_ocultarSenha;
                        });
                      },
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: colorScheme.onSurface.withValues(alpha: 0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: colorScheme.primary,
                        width: 2,
                      ),
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
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.surface,
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