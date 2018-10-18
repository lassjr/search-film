import 'package:flutter/material.dart';

import './movie.dart';
import './infoMovie.dart';
import './movieStorage.dart';

class FavoritePage extends StatefulWidget {
  _MyFavoritePage createState() => _MyFavoritePage();
}

class _MyFavoritePage extends State<FavoritePage> {
  final _movieStorage = new MovieStorage();
  var divided = new List<Widget>();
  Widget build(BuildContext context) {
    _movieStorage.readMovies().then((movies) {
      final Iterable<ListTile> tiles = movies.map(
        (Movie movie) {
          return new ListTile(
            title: new Text(
              movie.title,
            ),
            onTap: () {
              Navigator.of(context).push(
                new MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return new InfoMovie(movie);
                  },
                ),
              );
            },
          );
        },
      );
      setState(() {
        divided = ListTile.divideTiles(
          context: context,
          tiles: tiles,
        ).toList();
      });
    });

    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Favorite Movies'),
      ),
      body: new ListView(children: divided),
    );
  }
}
