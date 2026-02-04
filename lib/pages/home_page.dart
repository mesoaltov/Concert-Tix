import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/concert.dart';
import '../widgets/concert_card.dart';
import 'concert_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Concert>> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiService.getConcerts();
  }

  Future<void> _refresh() async {
    setState(() => _future = ApiService.getConcerts());
    await _future;
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
                  const Text('New Arrival', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  if (items.isEmpty) const Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Center(child: Text('Belum ada konser')),
                  ),
                  for (final c in items)
                    ConcertCard(
                      concert: c,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ConcertDetailPage(concert: c)),
                        );
                      },
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
