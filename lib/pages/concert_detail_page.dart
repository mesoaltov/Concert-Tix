import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_service.dart';
import '../models/concert.dart';

class ConcertDetailPage extends StatefulWidget {
  final Concert concert;
  const ConcertDetailPage({super.key, required this.concert});

  @override
  State<ConcertDetailPage> createState() => _ConcertDetailPageState();
}

class _ConcertDetailPageState extends State<ConcertDetailPage> {
  final _qtyC = TextEditingController();
  int _total = 0;

  void _calcTotal() {
    final qty = int.tryParse(_qtyC.text) ?? 0;
    setState(() => _total = qty * widget.concert.price);
  }

  Future<int> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId') ?? 0;
  }

  Future<void> _book() async {
    final qty = int.tryParse(_qtyC.text) ?? 0;
    if (qty <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Jumlah tiket minimal 1')));
      return;
    }

    final userId = await _getUserId();
    if (userId == 0) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Silakan login dulu')));
      return;
    }

    try {
      final res = await ApiService.addTicket(
        userId: userId,
        concertId: widget.concert.id,
        qty: qty,
      );
      if (!mounted) return;

      if (res['success'] == true) {
        // Message menggunakan AlertDialog; Ketika booked ticket sukses.
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Booked Ticket: OK'),
            content: Text('Berhasil booking ${widget.concert.title}\nTotal: Rp $_total'),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking sukses!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'].toString())));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal booking: $e')));
    }
  }

  Future<void> _favorite() async {
    final userId = await _getUserId();
    if (userId == 0) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Silakan login dulu')));
      return;
    }

    try {
      final res = await ApiService.addFavorite(userId: userId, concertId: widget.concert.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'].toString())));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal favorit: $e')));
    }
  }

  @override
  void initState() {
    super.initState();
    _qtyC.addListener(_calcTotal);
  }

  @override
  void dispose() {
    _qtyC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.concert;

    return Scaffold(
      appBar: AppBar(title: const Text('ConcerTix')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('CONCERT DETAIL', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // Ketika ga ada image di Network, akan menggunakan image bawaan yaitu poster_placeholder
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: c.posterUrl.isNotEmpty
                  ? Image.network(
                c.posterUrl,
                fit: BoxFit.fitWidth,
                errorBuilder: (_, __, ___) => Image.asset(
                  'assets/images/poster_placeholder.jpg',
                  height: 260,
                  fit: BoxFit.cover,
                ),
              )
                  : Image.asset('assets/images/poster_placeholder.jpg', height: 260, fit: BoxFit.cover),
            ),

            const SizedBox(height: 14),
            Text(c.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(c.artist),
            const SizedBox(height: 10),
            Text('${c.date} • ${c.time}'),
            Text('${c.city} • ${c.venue}'),

            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ticket', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Rp ${c.price}', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 6),
                  Text('Kategori : ${c.category}'),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _qtyC,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(hintText: 'Jumlah Tiket (contoh: 2)'),
                  ),
                  const SizedBox(height: 12),
                  Text('Total : Rp $_total'),
                ],
              ),
            ),

            const SizedBox(height: 16),
            ElevatedButton(onPressed: _book, child: const Text('Beli')),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _favorite, child: const Text('Favoritkan')),
          ],
        ),
      ),
    );
  }
}
