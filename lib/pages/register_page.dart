import 'package:flutter/material.dart';
import '../api/api_service.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _fullName = TextEditingController();
  final _u = TextEditingController();
  final _p = TextEditingController();
  bool _loading = false;

  Future<void> _doRegister() async {
    final fullName = _fullName.text.trim();
    final u = _u.text.trim();
    final p = _p.text;

    if (fullName.isEmpty || u.isEmpty || p.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field wajib diisi')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      final res = await ApiService.register(
        username: u,
        password: p,
        fullName: fullName,
      );

      if (!mounted) return;

      if (res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Register berhasil ✅ Silakan login')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message'].toString())),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Register gagal: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _fullName.dispose();
    _u.dispose();
    _p.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            const Text(
              'Create Account',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // ✅ NAMA LENGKAP
            TextField(
              controller: _fullName,
              decoration: const InputDecoration(hintText: 'Nama Lengkap'),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _u,
              decoration: const InputDecoration(hintText: 'Username'),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _p,
              obscureText: true,
              decoration: const InputDecoration(hintText: 'Password'),
            ),
            const SizedBox(height: 18),

            ElevatedButton(
              onPressed: _loading ? null : _doRegister,
              child: _loading
                  ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
