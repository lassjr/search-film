import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './movieStorage.dart';
import './security_key.dart';
import './movie.dart';
import './infoMovie.dart';
import './favoritePage.dart';

class MyCustomForm extends StatefulWidget {
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final myController = TextEditingController();
  final _movies = <Movie>[];
  final Set<Movie> _favoriteMovies = new Set<Movie>();
  final _movieStorage = new MovieStorage();

  _MyCustomFormState() {
    _movieStorage.readMovies().then((movies) {
      setState(() {
        _favoriteMovies.addAll(movies);
      });
    });
  }

  void dispose() {
    myController.dispose();
    super.dispose();
  }

  void searchFilm() {
    if (myController.text.trim().isNotEmpty) {
      var url =
          "http://www.omdbapi.com/?apikey=$API_KEY&s=${myController.text.trim()}";

      http.get(url).then((response) {
        final film = json.decode(response.body)['Search'].toList();
        setState(() {
          _movies.clear();
          film.forEach((element) {
            _movies.add(Movie.fromJson(element));
          });
        });
      });
    }
  }

  Widget _buildRow(Movie movie) {
    Movie movieFound = _favoriteMovies.firstWhere((element) {
      return element == movie;
    }, orElse: () {
      return null;
    });
    final bool saved = movieFound != null;
    return ListTile(
      title: Text(movie.title),
      trailing: new Icon(
        saved ? Icons.favorite : Icons.favorite_border,
        color: saved ? Colors.red : null,
      ),
      onTap: () {
        _pushInfo(movie);
      },
      onLongPress: () {
        setState(() {
          if (saved) {
            _favoriteMovies.remove(movie);
          } else {
            _favoriteMovies.add(movie);
          }
          _movieStorage.writeMovies(_favoriteMovies.toList());
        });
      },
    );
  }

  List<Widget> _buildListViewChildren() {
    final listWidget = <Widget>[];

    _movies.forEach((movie) {
      listWidget.add(_buildRow(movie));
      listWidget.add(Divider());
    });

    return listWidget;
  }

  void favorite() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return new FavoritePage();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Film Search'), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.favorite),
          tooltip: 'Favorite Movie',
          onPressed: () {
            favorite();
          },
        )
      ]),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onEditingComplete: searchFilm,
              controller: myController,
            ),
          ),
          Flexible(
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: _buildListViewChildren(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: searchFilm,
        tooltip: 'Show me the value!',
        child: Icon(Icons.search),
      ),
    );
  }

  void _pushInfo(Movie movie) {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return new InfoMovie(movie);
        },
      ),
    );
  }
}
