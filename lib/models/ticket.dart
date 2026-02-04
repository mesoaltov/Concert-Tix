class Ticket {
  final int id;
  final int qty;
  final int totalPrice;
  final String status;
  final String concertTitle;
  final String artist;
  final String date;
  final String city;

  Ticket({
    required this.id,
    required this.qty,
    required this.totalPrice,
    required this.status,
    required this.concertTitle,
    required this.artist,
    required this.date,
    required this.city,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: int.tryParse(json['id'].toString()) ?? 0,
      qty: int.tryParse(json['qty'].toString()) ?? 0,
      totalPrice: int.tryParse(json['total_price'].toString()) ?? 0,
      status: json['status']?.toString() ?? '',
      concertTitle: json['title']?.toString() ?? '',
      artist: json['artist']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
    );
  }
}
