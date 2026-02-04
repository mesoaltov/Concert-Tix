import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/concert.dart';
import '../models/ticket.dart';

class ApiService {
  static const String baseUrl = 'https://altov.tif-lbj.my.id/api-altov';
  static const _timeout = Duration(seconds: 15);

  static Map<String, dynamic> _map(http.Response res) {
    final decoded = jsonDecode(res.body);
    if (decoded is Map<String, dynamic>) return decoded;
    throw Exception('Invalid JSON map: ${res.body}');
  }

  static List<dynamic> _list(http.Response res) {
    final decoded = jsonDecode(res.body);
    if (decoded is List) return decoded;
    throw Exception('Invalid JSON list: ${res.body}');
  }

  // ---------- AUTH ----------
  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/login.php');
    final res = await http
        .post(url, body: {'username': username, 'password': password})
        .timeout(_timeout);

    if (res.statusCode != 200) throw Exception('Login ${res.statusCode}: ${res.body}');
    return _map(res);
  }

  static Future<Map<String, dynamic>> register({
    required String username,
    required String password,
    required String fullName,
  }) async {
    final url = Uri.parse('$baseUrl/register.php');
    final res = await http.post(url, body: {
      'username': username,
      'password': password,
      'full_name': fullName,
    }).timeout(_timeout);

    if (res.statusCode != 200) throw Exception('Register ${res.statusCode}: ${res.body}');
    return _map(res);
  }


  // ---------- CONCERT ----------
  static Future<List<Concert>> getConcerts() async {
    final url = Uri.parse('$baseUrl/concerts.php');
    final res = await http.get(url).timeout(_timeout);

    if (res.statusCode != 200) throw Exception('Concerts ${res.statusCode}: ${res.body}');
    final data = _list(res);
    return data.map((e) => Concert.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<List<Concert>> searchConcerts(String q) async {
    final url = Uri.parse('$baseUrl/concerts.php?search=${Uri.encodeComponent(q)}');
    final res = await http.get(url).timeout(_timeout);

    if (res.statusCode != 200) throw Exception('Search ${res.statusCode}: ${res.body}');
    final data = _list(res);
    return data.map((e) => Concert.fromJson(e as Map<String, dynamic>)).toList();
  }

  // ---------- FAVORITES ----------
  static Future<Map<String, dynamic>> addFavorite({
    required int userId,
    required int concertId,
  }) async {
    final url = Uri.parse('$baseUrl/favorites_add.php');
    final res = await http
        .post(url, body: {'user_id': '$userId', 'concert_id': '$concertId'})
        .timeout(_timeout);

    if (res.statusCode != 200) throw Exception('FavAdd ${res.statusCode}: ${res.body}');
    return _map(res);
  }

  static Future<Map<String, dynamic>> deleteFavorite({
    required int userId,
    required int concertId,
  }) async {
    final url = Uri.parse('$baseUrl/favorites_delete.php');
    final res = await http
        .post(url, body: {'user_id': '$userId', 'concert_id': '$concertId'})
        .timeout(_timeout);

    if (res.statusCode != 200) throw Exception('FavDel ${res.statusCode}: ${res.body}');
    return _map(res);
  }

  static Future<List<Concert>> getFavorites(int userId) async {
    final url = Uri.parse('$baseUrl/favorites_list.php?user_id=$userId');
    final res = await http.get(url).timeout(_timeout);

    if (res.statusCode != 200) throw Exception('FavList ${res.statusCode}: ${res.body}');
    final data = _list(res);
    return data.map((e) => Concert.fromJson(e as Map<String, dynamic>)).toList();
  }

  // ---------- TICKETS ----------
  static Future<Map<String, dynamic>> addTicket({
    required int userId,
    required int concertId,
    required int qty,
  }) async {
    final url = Uri.parse('$baseUrl/tickets_add.php');
    final res = await http
        .post(url, body: {'user_id': '$userId', 'concert_id': '$concertId', 'qty': '$qty'})
        .timeout(_timeout);

    if (res.statusCode != 200) throw Exception('TicketAdd ${res.statusCode}: ${res.body}');
    return _map(res);
  }

  static Future<Map<String, dynamic>> cancelTicket({
    required int userId,
    required int ticketId,
  }) async {
    final url = Uri.parse('$baseUrl/tickets_cancel.php');
    final res = await http
        .post(url, body: {'user_id': '$userId', 'ticket_id': '$ticketId'})
        .timeout(_timeout);

    if (res.statusCode != 200) throw Exception('TicketCancel ${res.statusCode}: ${res.body}');
    return _map(res);
  }

  static Future<List<Ticket>> getTickets(int userId) async {
    final url = Uri.parse('$baseUrl/tickets_list.php?user_id=$userId');
    final res = await http.get(url).timeout(_timeout);

    if (res.statusCode != 200) throw Exception('TicketList ${res.statusCode}: ${res.body}');
    final data = _list(res);
    return data.map((e) => Ticket.fromJson(e as Map<String, dynamic>)).toList();
  }

  // ---------- ADMIN CRUD (pakai admin_id) ----------
  static Future<Map<String, dynamic>> adminAddConcert({
    required int adminId,
    required Concert concert,
  }) async {
    final url = Uri.parse('$baseUrl/admin_concerts_add.php');
    final res = await http.post(url, body: {
      'admin_id': '$adminId',
      ...concert.toWriteMap(),
    }).timeout(_timeout);

    if (res.statusCode != 200) throw Exception('AdminAdd ${res.statusCode}: ${res.body}');
    return _map(res);
  }

  static Future<Map<String, dynamic>> adminUpdateConcert({
    required int adminId,
    required Concert concert,
  }) async {
    final url = Uri.parse('$baseUrl/admin_concerts_update.php');
    final res = await http.post(url, body: {
      'admin_id': '$adminId',
      'id': '${concert.id}',
      ...concert.toWriteMap(),
    }).timeout(_timeout);

    if (res.statusCode != 200) throw Exception('AdminUpdate ${res.statusCode}: ${res.body}');
    return _map(res);
  }

  static Future<Map<String, dynamic>> adminDeleteConcert({
    required int adminId,
    required int id,
  }) async {
    final url = Uri.parse('$baseUrl/admin_concerts_delete.php');
    final res = await http.post(url, body: {
      'admin_id': '$adminId',
      'id': '$id',
    }).timeout(_timeout);

    if (res.statusCode != 200) throw Exception('AdminDelete ${res.statusCode}: ${res.body}');
    return _map(res);
  }
}
