import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';

import './movie.dart';

class MovieStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/movies.txt');
  }

  Future<List<Movie>> readMovies() async {
    try {
      final file = await _localFile;

      String contents = await file.readAsString();
      List<Movie> movies = <Movie>[];
      json.decode(contents).toList().forEach((movieData) {
        movies.add(Movie.fromJson(movieData));
      });

      return movies;
    } catch (e) {
      return [];
    }
  }

  Future<File> writeMovies(List<Movie> movies) async {
    final file = await _localFile;
    String content = json.encode(movies);
    return file.writeAsString('$content');
  }
}
