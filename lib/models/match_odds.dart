// lib/models/match_odds.dart
//
// Parses the JSON structure returned by The Odds API v4.
// Each [MatchOdds] represents one game, containing a list of [Bookmaker]s
// which each contain a list of [Outcome]s (team prices).

class Outcome {
  final String name;
  final double price;

  const Outcome({required this.name, required this.price});

  factory Outcome.fromJson(Map<String, dynamic> json) {
    return Outcome(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }
}

class Market {
  final String key; // e.g. "h2h"
  final List<Outcome> outcomes;

  const Market({required this.key, required this.outcomes});

  factory Market.fromJson(Map<String, dynamic> json) {
    final rawOutcomes = json['outcomes'] as List<dynamic>? ?? [];
    return Market(
      key: json['key'] as String,
      outcomes: rawOutcomes
          .map((o) => Outcome.fromJson(o as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Bookmaker {
  final String key;
  final String title;
  final List<Market> markets;

  const Bookmaker({
    required this.key,
    required this.title,
    required this.markets,
  });

  factory Bookmaker.fromJson(Map<String, dynamic> json) {
    final rawMarkets = json['markets'] as List<dynamic>? ?? [];
    return Bookmaker(
      key: json['key'] as String,
      title: json['title'] as String,
      markets: rawMarkets
          .map((m) => Market.fromJson(m as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Convenience: returns the h2h market outcomes, or empty list if absent.
  List<Outcome> get h2hOutcomes {
    final h2h = markets.where((m) => m.key == 'h2h').firstOrNull;
    return h2h?.outcomes ?? [];
  }
}

class MatchOdds {
  final String id;
  final String sportKey;
  final DateTime commenceTime;
  final String homeTeam;
  final String awayTeam;
  final List<Bookmaker> bookmakers;

  const MatchOdds({
    required this.id,
    required this.sportKey,
    required this.commenceTime,
    required this.homeTeam,
    required this.awayTeam,
    required this.bookmakers,
  });

  factory MatchOdds.fromJson(Map<String, dynamic> json) {
    final rawBookmakers = json['bookmakers'] as List<dynamic>? ?? [];
    return MatchOdds(
      id: json['id'] as String,
      sportKey: json['sport_key'] as String,
      commenceTime: DateTime.parse(json['commence_time'] as String).toLocal(),
      homeTeam: json['home_team'] as String,
      awayTeam: json['away_team'] as String,
      bookmakers: rawBookmakers
          .map((b) => Bookmaker.fromJson(b as Map<String, dynamic>))
          .toList(),
    );
  }
}
