import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_service.dart';
import 'main_nav_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _u = TextEditingController();
  final _p = TextEditingController();
  bool _loading = false;

  Future<void> _doLogin() async {
    final u = _u.text.trim();
    final p = _p.text;

    if (u.isEmpty || p.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username & password wajib diisi')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final res = await ApiService.login(username: u, password: p);
      if (!mounted) return;

      if (res['success'] != true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message'].toString())),
        );
        return;
      }

      final user = res['user'] as Map<String, dynamic>;

      final userId = int.tryParse(user['id'].toString()) ?? 0;
      if (userId == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User ID tidak valid')),
        );
        return;
      }

      final username = (user['username'] ?? '').toString();
      final fullName = (user['full_name'] ?? '').toString(); // ✅ dari login.php
      final role = (user['role'] ?? 'user').toString();       // ✅ dari login.php
      final isAdmin = role == 'admin';

      // SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;

      await prefs.setBool('isLoggedIn', true);
      await prefs.setInt('userId', userId);
      await prefs.setString('username', username);
      await prefs.setString('fullName', fullName); // ✅ simpan nama lengkap
      await prefs.setString('role', role);         // ✅ simpan role
      await prefs.setBool('isAdmin', isAdmin);     // ✅ optional, biar gampang cek

      if (!mounted) return;

      // ✅ Welcome message sesuai request
      final welcome = isAdmin
          ? 'Selamat datang, Admin.'
          : 'Selamat datang, ${fullName.isNotEmpty ? fullName : username}.';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(welcome)),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavPage()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal login: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _u.dispose();
    _p.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ConcerTix')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            const Text('Welcome Back!', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Let's get started to meet your idol!"),
            const SizedBox(height: 20),
            TextField(controller: _u, decoration: const InputDecoration(hintText: 'Username')),
            const SizedBox(height: 12),
            TextField(controller: _p, obscureText: true, decoration: const InputDecoration(hintText: 'Password')),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: _loading ? null : _doLogin,
              child: _loading
                  ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Login'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _loading
                  ? null
                  : () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage()));
              },
              child: const Text('Belum punya akun? Register'),
            ),
          ],
        ),
      ),
    );
  }
}
