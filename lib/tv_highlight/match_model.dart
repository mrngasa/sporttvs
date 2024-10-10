// lib/match_model.dart
class Match {
  final String title;
  final String embed;
  final String url;
  final String thumbnail;
  final DateTime date;
  final String side1Name;
  final String side2Name;
  final String competitionName;
  final List<String> videoEmbeds; // List of highlight video embeds

  Match({
    required this.title,
    required this.embed,
    required this.url,
    required this.thumbnail,
    required this.date,
    required this.side1Name,
    required this.side2Name,
    required this.competitionName,
    required this.videoEmbeds,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      title: json['title'],
      embed: json['embed'],
      url: json['url'],
      thumbnail: json['thumbnail'],
      date: DateTime.parse(json['date']),
      side1Name: json['side1']['name'],
      side2Name: json['side2']['name'],
      competitionName: json['competition']['name'],
      videoEmbeds: List<String>.from(json['videos']
          .map((video) => video['embed'])), // Extract highlight embeds
    );
  }
}
