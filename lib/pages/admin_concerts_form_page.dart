import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_service.dart';
import '../models/concert.dart';

class AdminConcertFormPage extends StatefulWidget {
  final Concert? existing;
  const AdminConcertFormPage({super.key, this.existing});

  @override
  State<AdminConcertFormPage> createState() => _AdminConcertFormPageState();
}

class _AdminConcertFormPageState extends State<AdminConcertFormPage> {
  final _title = TextEditingController();
  final _artist = TextEditingController();
  final _date = TextEditingController();
  final _time = TextEditingController();
  final _city = TextEditingController();
  final _venue = TextEditingController();
  final _price = TextEditingController();
  final _category = TextEditingController();
  final _poster = TextEditingController();

  bool _loading = false;

  Future<int> _uid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId') ?? 0;
  }

  @override
  void initState() {
    super.initState();
    final c = widget.existing;
    if (c != null) {
      _title.text = c.title;
      _artist.text = c.artist;
      _date.text = c.date;
      _time.text = c.time;
      _city.text = c.city;
      _venue.text = c.venue;
      _price.text = c.price.toString();
      _category.text = c.category;
      _poster.text = c.posterUrl;
    }
  }

  String _fmtDate(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}'; // yyyy-MM-dd
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (picked == null) return;
    setState(() => _date.text = _fmtDate(picked));
  }


  @override
  void dispose() {
    _title.dispose();
    _artist.dispose();
    _date.dispose();
    _time.dispose();
    _city.dispose();
    _venue.dispose();
    _price.dispose();
    _category.dispose();
    _poster.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final price = int.tryParse(_price.text.trim()) ?? 0;
    if (_title.text.trim().isEmpty || _artist.text.trim().isEmpty || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul, artis, dan harga wajib valid')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      final adminId = await _uid();
      final concert = Concert(
        id: widget.existing?.id ?? 0,
        title: _title.text.trim(),
        artist: _artist.text.trim(),
        date: _date.text.trim(),
        time: _time.text.trim(),
        city: _city.text.trim(),
        venue: _venue.text.trim(),
        price: price,
        category: _category.text.trim(),
        posterUrl: _poster.text.trim(),
      );

      final res = widget.existing == null
          ? await ApiService.adminAddConcert(adminId: adminId, concert: concert)
          : await ApiService.adminUpdateConcert(adminId: adminId, concert: concert);

      if (!mounted) return;
      if (res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'].toString())));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'].toString())));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal simpan: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Konser' : 'Tambah Konser')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: _title, decoration: const InputDecoration(hintText: 'Title')),
            const SizedBox(height: 10),
            TextField(controller: _artist, decoration: const InputDecoration(hintText: 'Artist')),
            const SizedBox(height: 10),
            TextField(
              controller: _date,
              readOnly: true,
              decoration: const InputDecoration(
                hintText: 'Tanggal Konser',
                suffixIcon: Icon(Icons.date_range),
              ),
              onTap: _pickDate,
            ),
            TextField(controller: _time, decoration: const InputDecoration(hintText: 'Time (contoh: 18:00)')),
            const SizedBox(height: 10),
            TextField(controller: _city, decoration: const InputDecoration(hintText: 'City')),
            const SizedBox(height: 10),
            TextField(controller: _venue, decoration: const InputDecoration(hintText: 'Venue')),
            const SizedBox(height: 10),
            TextField(controller: _price, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'Price')),
            const SizedBox(height: 10),
            TextField(controller: _category, decoration: const InputDecoration(hintText: 'Category')),
            const SizedBox(height: 10),
            TextField(controller: _poster, decoration: const InputDecoration(hintText: 'Poster URL')),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _save,
              child: _loading
                  ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(isEdit ? 'Update' : 'Tambah'),
            ),
          ],
        ),
      ),
    );
  }
}