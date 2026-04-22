import 'package:flutter/material.dart';
import '../models/match_odds.dart';
import '../services/odds_service.dart';
import '../widgets/match_tile.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState()=> _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final OddsService _oddsService = OddsService();

  List<MatchOdds> _matches = [];
  bool _isLoading = false;
  int? _creditsRemaining;
  int? _creditsUsed;

  //Cycle
  @override
  void dispose() {
    _oddsService.dispose();
    super.dispose();
  }

  //Actions
  Future<void> _fetchOdds() async {
    setState(() => _isLoading = true);
    
    final result = await _oddsService.fetchNbaOdds();

    setState(() {
      _matches = result.matches;
      _creditsRemaining = result.creditsRemaining;
      _creditsUsed = result.creditsUsed;
      _isLoading = false;
    });
  }

  //Build the Widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 140,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("NBA Matches Odds Comparison Tool")
            ),
          ),
          SliverToBoxAdapter(child: _buildBody()),
        ],
      ),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: _isLoading ? null: _fetchOdds,
      icon: _isLoading ? SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
        )
      )
      : const Icon(Icons.refresh_rounded),
      label: Text(_isLoading ? "Loading,,,": "Get NBA Odds"),
      )
    );
  }

  Widget _buildBody() {
    //Not loading and no data yet (for launch)
    if (!_isLoading && _matches.isEmpty) {
      return _EmptyState();
    }

    //Loading but no data
    if (_isLoading && _matches.isEmpty) {
      return const SizedBox(
        height: 400,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: Text('${_matches.length} MATCH${_matches.length == 1 ? '' : 'ES'} TODAY')
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 100), // clearance for FAB
          itemCount: _matches.length,
          itemBuilder: (_, i) => MatchTile(match: _matches[i]),
        )
      ]

      //To Do, build tile logic and add it here
    );
  }
}


class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(
        child: Column(
          children: [
            Text(
              'No odds Data yet',
              style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Tap 'Get Latest NBA Odds' to get started")
          ]
        )
      )
    );
  }
}