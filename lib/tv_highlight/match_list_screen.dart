import 'package:flutter/material.dart';
import 'package:sporttvs/tv_highlight/api_service.dart';
import 'package:sporttvs/tv_highlight/video_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'match_model.dart';

class MatchListScreen extends StatefulWidget {
  const MatchListScreen({super.key});

  @override
  _MatchListScreenState createState() => _MatchListScreenState();
}

class _MatchListScreenState extends State<MatchListScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Match>> futureMatches;

  @override
  void initState() {
    super.initState();
    futureMatches = apiService.fetchMatches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Football Match Hub'),
      //   backgroundColor: Colors.green[700],
      // ),
      body: FutureBuilder<List<Match>>(
        future: futureMatches,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No matches found.'));
          } else {
            final matches = snapshot.data!;
            final matchesByCompetition = _groupMatchesByCompetition(matches);

            return ListView(
              padding: const EdgeInsets.all(8.0),
              children: matchesByCompetition.entries.map((entry) {
                final competitionName = entry.key;
                final competitionMatches = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Text(
                        competitionName,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 1.5, // Adjusted for compact design
                      ),
                      itemCount: competitionMatches.length,
                      itemBuilder: (context, index) {
                        final match = competitionMatches[index];
                        return Column(
                          children: [
                            Expanded(
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Stack(
                                  children: [
                                    // Background image
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        match.thumbnail,
                                        fit: BoxFit.cover,
                                        width: double
                                            .infinity, // Ensure the image covers the whole card
                                        height: double
                                            .infinity, // Ensure the image covers the whole card
                                      ),
                                    ),
                                    // Overlay for text and button
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.black.withOpacity(0.5),
                                              Colors.black.withOpacity(0),
                                            ],
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Align(
                                              alignment: Alignment.center,
                                              child: TextButton(
                                                style: TextButton.styleFrom(
                                                  foregroundColor: Colors.white,
                                                  backgroundColor: Colors.green,
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          VideoScreen(
                                                        videoUrl: match
                                                                .videoEmbeds
                                                                .isNotEmpty
                                                            ? match
                                                                .videoEmbeds[0]
                                                            : '', // Use the first video embed
                                                        matchDate: match.date
                                                            .toLocal()
                                                            .toString(),
                                                        team1Name:
                                                            match.side1Name,
                                                        team2Name:
                                                            match.side2Name,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child:
                                                    const Text('Watch Video'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                                height:
                                    4), // Spacing between the card and the text
                            Text(
                              match.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        );
                      },
                    )
                  ],
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }

  Map<String, List<Match>> _groupMatchesByCompetition(List<Match> matches) {
    final Map<String, List<Match>> groupedMatches = {};
    for (var match in matches) {
      final competition = match.competitionName;
      if (groupedMatches.containsKey(competition)) {
        groupedMatches[competition]!.add(match);
      } else {
        groupedMatches[competition] = [match];
      }
    }
    return groupedMatches;
  }
}

class MatchDetailScreen extends StatelessWidget {
  final Match match;

  const MatchDetailScreen({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(match.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(match.competitionName,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Image.network(match.thumbnail),
            const SizedBox(height: 20),
            Text('Match between ${match.side1Name} and ${match.side2Name}'),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                _launchURL(Uri.parse(match.url));
              },
              child: const Text('Watch Live'),
            ),
            const SizedBox(height: 10),
            Text('Date: ${match.date.toLocal()}'),
            const SizedBox(height: 20),
            const Text('Highlights',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  crossAxisSpacing: 8.0, // Spacing between columns
                  mainAxisSpacing: 8.0, // Spacing between rows
                  childAspectRatio: 1.0, // Aspect ratio of each grid item
                ),
                itemCount: match.videoEmbeds.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: WebViewWidget(
                      controller: WebViewController()
                        ..setJavaScriptMode(JavaScriptMode.unrestricted)
                        ..setBackgroundColor(const Color(0x00000000))
                        ..loadHtmlString(
                            "<html><body>${match.videoEmbeds[index]}</body></html>"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
