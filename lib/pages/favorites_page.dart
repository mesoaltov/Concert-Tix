import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_service.dart';
import '../models/concert.dart';
import '../widgets/concert_card.dart';
import 'concert_detail_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  Future<int> _uid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId') ?? 0;
  }

  late Future<List<Concert>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<Concert>> _load() async {
    final id = await _uid();
    if (id == 0) return [];
    return ApiService.getFavorites(id);
  }

  Future<void> _refresh() async {
    setState(() => _future = _load());
    await _future;
  }

  Future<void> _removeFavorite(int concertId) async {
    final userId = await _uid();
    if (userId == 0) return;

    final res = await ApiService.deleteFavorite(userId: userId, concertId: concertId);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'].toString())));
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ConcerTix')),
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
                  const Text('My Favorit', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  if (items.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Center(child: Text('Belum ada favorit')),
                    ),
                  for (final c in items)
                    ConcertCard(
                      concert: c,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ConcertDetailPage(concert: c)),
                        );
                        // refresh setelah balik dari detail
                        await _refresh();
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () async {
                          final ok = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Hapus favorit?'),
                              content: Text('Hapus ${c.title} dari favorit?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
                                TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Hapus')),
                              ],
                            ),
                          );
                          if (ok == true) {
                            await _removeFavorite(c.id);
                          }
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
