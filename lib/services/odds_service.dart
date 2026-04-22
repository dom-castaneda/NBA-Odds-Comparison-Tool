// lib/services/odds_service.dart
//
// Dart equivalent of the Python requests logic in odds_scraper_nba.py.
// Encapsulates all HTTP interaction with The Odds API v4.

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/match_odds.dart';

/// Thrown when the API returns a non-200 status code.
class OddsApiException implements Exception {
  final int statusCode;
  final String message;

  const OddsApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'OddsApiException($statusCode): $message';
}

/// Result envelope that also surfaces API credit metadata from response headers.
class OddsResult {
  final List<MatchOdds> matches;
  final int? creditsRemaining;
  final int? creditsUsed;

  const OddsResult({
    required this.matches,
    this.creditsRemaining,
    this.creditsUsed,
  });
}

class OddsService {
  // ---------------------------------------------------------------------------
  // Configuration — mirrors the constants in odds_scraper_nba.py
  // ---------------------------------------------------------------------------
  static const String _apiKey = 'YOUR_API_KEY_HERE';
  static const String _sport = 'basketball_nba';
  static const String _regions = 'au';
  static const String _markets = 'h2h';
  static const String _oddsFormat = 'decimal';
  static const String _dateFormat = 'iso';

  static const String _baseUrl = 'https://api.the-odds-api.com';

  final http.Client _client;

  /// Inject an [http.Client] to make the service easily testable.
  OddsService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches the latest H2H odds for NBA games.
  ///
  /// Throws [OddsApiException] on non-200 responses.
  /// Throws [Exception] / [FormatException] on network or parse errors.
  Future<OddsResult> fetchNbaOdds() async {
    final uri = Uri.parse('$_baseUrl/v4/sports/$_sport/odds').replace(
      queryParameters: {
        'api_key': _apiKey,
        'regions': _regions,
        'markets': _markets,
        'oddsFormat': _oddsFormat,
        'dateFormat': _dateFormat,
      },
    );

    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      // Surface the API error message if available
      String detail = response.body;
      try {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        detail = body['message'] as String? ?? detail;
      } catch (_) {}

      throw OddsApiException(statusCode: response.statusCode, message: detail);
    }

    final List<dynamic> raw = jsonDecode(response.body) as List<dynamic>;
    final matches = raw
        .map((e) => MatchOdds.fromJson(e as Map<String, dynamic>))
        .toList();

    // Parse credit headers (same values the Python script prints)
    final remaining =
        int.tryParse(response.headers['x-requests-remaining'] ?? '');
    final used = int.tryParse(response.headers['x-requests-used'] ?? '');

    return OddsResult(
      matches: matches,
      creditsRemaining: remaining,
      creditsUsed: used,
    );
  }

  void dispose() => _client.close();
}
