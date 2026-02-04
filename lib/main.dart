import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart';
import 'pages/login_page.dart';
import 'pages/main_nav_page.dart';
import 'pages/splash_page.dart';

void main() {
  runApp(const ConcertTixApp());
}

class ConcertTixApp extends StatelessWidget {
  const ConcertTixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Nah ini judulnya
      title: 'ConcerTix',
      debugShowCheckedModeBanner: false,
      theme: buildConcertTixTheme(),
      home: const RootGate(),
    );
  }
}

class RootGate extends StatefulWidget {
  const RootGate({super.key});

  @override
  State<RootGate> createState() => _RootGateState();
}

class _RootGateState extends State<RootGate> {
  bool? _loggedIn;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (!mounted) return;
    setState(() => _loggedIn = isLoggedIn);
  }

  @override
  Widget build(BuildContext context) {
    if (_loggedIn == null) {
      return const SplashPage();
    }
    return _loggedIn! ? const MainNavPage() : const LoginPage();
  }
}
