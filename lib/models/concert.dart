class Concert {
  final int id;
  final String title;
  final String artist;
  final String date;
  final String time;
  final String city;
  final String venue;
  final int price;
  final String category;
  final String posterUrl;

  Concert({
    required this.id,
    required this.title,
    required this.artist,
    required this.date,
    required this.time,
    required this.city,
    required this.venue,
    required this.price,
    required this.category,
    required this.posterUrl,
  });

  factory Concert.fromJson(Map<String, dynamic> json) {
    return Concert(
      id: int.tryParse(json['id'].toString()) ?? 0,
      title: json['title']?.toString() ?? '',
      artist: json['artist']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      venue: json['venue']?.toString() ?? '',
      price: int.tryParse(json['price'].toString()) ?? 0,
      category: json['category']?.toString() ?? '',
      posterUrl: json['poster_url']?.toString() ?? '',
    );
  }

  /// ✅ INI YANG TADI BELUM ADA
  /// Dipakai untuk ADMIN ADD & UPDATE
  Map<String, String> toWriteMap() {
    return {
      'title': title,
      'artist': artist,
      'date': date,
      'time': time,
      'city': city,
      'venue': venue,
      'price': price.toString(),
      'category': category,
      'poster_url': posterUrl,
    };
  }
}
