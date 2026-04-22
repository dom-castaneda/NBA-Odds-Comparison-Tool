import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/match_odds.dart';
import 'bookmaker_odds_table.dart';


class MatchTile extends StatelessWidget {
  final MatchOdds match;

  const MatchTile({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('EEE, MMM d').format(match.commenceTime);
    final timeStr = DateFormat('h:mm a').format(match.commenceTime);
    final bookmakerCount = match.bookmakers.length;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide()
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal:20, vertical: 8),
        childrenPadding: EdgeInsets.zero,
        shape: const Border(), //remove default divider lines
        collapsedShape: const Border(),
        title: _MatchupHeader(match: match),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            children: [
              Icon(Icons.schedule_rounded,
              size: 13),
              const SizedBox(width: 4),
              Text('$dateStr . $timeStr'),
              const SizedBox(width: 12),
              Icon(Icons.storefront_rounded,size: 13),
              const SizedBox(width: 4),
              Text('$bookmakerCount bookmaker${bookmakerCount == 1 ? '' : 's'}')
            ]
          )
        ),
        children: [
          Divider(
            height: 1,
            indent: 20,
            endIndent: 20,
          ),
          const SizedBox(height: 12),
          BookMakerOddsTable(match: match,)
        ],
      ),
    );
  }
}




class _MatchupHeader extends StatelessWidget {
  final MatchOdds match;

  const _MatchupHeader({
    required this.match,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            match.awayTeam,
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: Text('VS')
        ),
        Expanded(
          child: Text(match.homeTeam)
        )
      ],
    );
  }
}