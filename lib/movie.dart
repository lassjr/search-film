class Movie {
  final String title;
  final String year;
  final String id;
  final String type;
  final String poster;

  Movie({this.title, this.year, this.id, this.type, this.poster});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['Title'],
      year: json['Year'],
      id: json['imdbID'],
      type: json['Type'],
      poster: json['Poster'],
    );
  }
}
