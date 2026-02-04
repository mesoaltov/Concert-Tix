import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_service.dart';
import '../models/concert.dart';
import '../widgets/concert_card.dart';
import 'admin_concerts_form_page.dart';

class AdminConcertsPage extends StatefulWidget {
  const AdminConcertsPage({super.key});

  @override
  State<AdminConcertsPage> createState() => _AdminConcertsPageState();
}

class _AdminConcertsPageState extends State<AdminConcertsPage> {
  late Future<List<Concert>> _future;

  Future<int> _uid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId') ?? 0;
  }

  @override
  void initState() {
    super.initState();
    _future = ApiService.getConcerts();
  }

  Future<void> _refresh() async {
    setState(() => _future = ApiService.getConcerts());
    await _future;
  }

  Future<void> _deleteConcert(int concertId) async {
    final adminId = await _uid();
    final res = await ApiService.adminDeleteConcert(adminId: adminId, id: concertId);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'].toString())));
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin - CRUD Konser')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminConcertFormPage()));
          await _refresh();
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<Concert>>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));
            final items = snap.data ?? [];

            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                children: [
                  const Text('Daftar Konser', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  for (final c in items)
                    ConcertCard(
                      concert: c,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AdminConcertFormPage(existing: c)),
                        );
                        await _refresh();
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () async {
                          final ok = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Hapus konser?'),
                              content: Text('Hapus "${c.title}"? (juga akan hapus tiket & favorit terkait)'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
                                TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Hapus')),
                              ],
                            ),
                          );
                          if (ok == true) await _deleteConcert(c.id);
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
