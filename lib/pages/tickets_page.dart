import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_service.dart';
import '../models/ticket.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({super.key});

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  Future<int> _uid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId') ?? 0;
  }

  late Future<List<Ticket>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<Ticket>> _load() async {
    final id = await _uid();
    if (id == 0) return [];
    return ApiService.getTickets(id);
  }

  Future<void> _refresh() async {
    setState(() => _future = _load());
    await _future;
  }

  Future<void> _cancel(int ticketId) async {
    final userId = await _uid();
    if (userId == 0) return;

    final res = await ApiService.cancelTicket(userId: userId, ticketId: ticketId);
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
        child: FutureBuilder<List<Ticket>>(
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
                  const Text('Booked Ticket', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  if (items.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Center(child: Text('Belum ada tiket yang dibooking')),
                    ),
                  for (final t in items)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.concertTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text('${t.artist} • ${t.date} • ${t.city}'),
                          const SizedBox(height: 6),
                          Text('Qty: ${t.qty}  |  Total: Rp ${t.totalPrice}'),
                          const SizedBox(height: 6),
                          Text('Status: ${t.status}'),
                          const SizedBox(height: 10),
                          if (t.status.toLowerCase() == 'booked')
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final ok = await showDialog<bool>(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: const Text('Batalkan booking?'),
                                          content: Text('Batalkan tiket untuk ${t.concertTitle}?'),
                                          actions: [
                                            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Tidak')),
                                            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Ya')),
                                          ],
                                        ),
                                      );
                                      if (ok == true) await _cancel(t.id);
                                    },
                                    child: const Text('Cancel Booking'),
                                  ),
                                ),
                              ],
                            ),
                        ],
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
