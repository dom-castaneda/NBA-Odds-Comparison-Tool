import 'package:flutter/material.dart';
import '../models/match_odds.dart';

class BookMakerOddsTable extends StatelessWidget {
  final MatchOdds match;

  const BookMakerOddsTable({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    if (match.bookmakers.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Text(
          'No bookmakers available for this match.',
        )
      );
    }

    final teamNames = <String>{match.awayTeam, match.homeTeam}.toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          child: DataTable(
            columnSpacing: 24,
            horizontalMargin: 16,
            columns: [
              const DataColumn(label: Text('BOOKMAKER')),
              //convert each name in teamNames into a DataColumn
              ...teamNames.map(
                (name) => DataColumn(
                  label: Flexible(
                    child: Text(
                      _shortName(name).toUpperCase(),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  numeric: true,
                ),
              ),
            ],
            rows: match.bookmakers.map((bm) {
              final outcomes = {for (var o in bm.h2hOutcomes) o.name: o.price};
              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      bm.title,
                    ),
                  ),
                  ...teamNames.map((team) {
                    final price = outcomes[team];
                    return DataCell(
                      price != null
                        ? _OddsChip(price: price)
                        : Text(
                          '-',
                        )
                    );
                  }),
                ]
              );
            }).toList(),
          )
        )
      )
    );
  }
  
  //Shorten Team Name

  String _shortName(String full) => full.split(' ').last;
}


class _OddsChip extends StatelessWidget {
  final double price;

  const _OddsChip({required this.price});

  @override
  Widget build(BuildContext context) {
    // Favourite = lower price (< 2.00 in decimal odds)
    final isFavourite = price < 2.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        price.toStringAsFixed(2),
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 13,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}