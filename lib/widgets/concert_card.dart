import 'package:flutter/material.dart';
import '../models/concert.dart';

class ConcertCard extends StatelessWidget {
  final Concert concert;
  final VoidCallback onTap;
  final Widget? trailing;

  const ConcertCard({
    super.key,
    required this.concert,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: concert.posterUrl.isNotEmpty
                    ? Image.network(
                  concert.posterUrl,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.asset(
                    'assets/images/poster_placeholder.jpg',
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                )
                    : Image.asset(
                  'assets/images/poster_placeholder.jpg',
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(concert.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(concert.artist),
                    const SizedBox(height: 4),
                    Text('${concert.city} • Rp ${concert.price}'),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
