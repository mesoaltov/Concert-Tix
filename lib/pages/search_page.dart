import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/concert.dart';
import '../widgets/concert_card.dart';
import 'concert_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _q = TextEditingController();
  List<Concert> _items = [];
  bool _loading = false;
  bool _searched = false;

  Future<void> _search() async {
    final q = _q.text.trim();
    if (q.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan kata kunci dulu')),
      );
      return;
    }

    setState(() {
      _loading = true;
      _searched = true;
    });

    try {
      final res = await ApiService.searchConcerts(q);
      if (!mounted) return;
      setState(() => _items = res);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Search error: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ConcerTix')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _q,
              decoration: InputDecoration(
                hintText: 'Search konser / artis / kota',
                suffixIcon: IconButton(icon: const Icon(Icons.search), onPressed: _search),
              ),
              onSubmitted: (_) => _search(),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                children: [
                  const Text('Pencarian', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  if (_searched && _items.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Center(child: Text('Tidak ada hasil')),
                    ),
                  for (final c in _items)
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
            ),
          ],
        ),
      ),
    );
  }
}
