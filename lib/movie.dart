class Movie extends Object {
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

  Map<String, String> toJson() {
    var map = Map<String, String>();
    map['Title'] = this.title;
    map['Year'] = this.year;
    map['imdbID'] = this.id;
    map['Type'] = this.type;
    map['Poster'] = this.poster;

    return map;
  }

  @override
  bool operator ==(dynamic other) {
    if (other is! Movie) return false;

    return other.id == this.id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
