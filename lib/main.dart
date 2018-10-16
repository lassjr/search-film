import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './security_key.dart';
import './movie.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Film Search',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyCustomForm(),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final myController = TextEditingController();
  final _movies = <Movie>[];

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

  Widget _buildRow(String movieTitle, int index) {
    return ListTile(
      title: Text(movieTitle),
      onTap: () {
        _pushInfo(_movies[index]);
      },
    );
  }

  List<Widget> _buildListViewChildren() {
    final listWidget = <Widget>[];
    for (int i = 0; i < _movies.length; i++) {
      listWidget.add(_buildRow(_movies[i].title, i));
      listWidget.add(Divider());
    }
    return listWidget;
  }

  void favorite() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          // final Iterable<ListTile> tiles = _saved.map(
          //   (WordPair pair) {
          //     return new ListTile(
          //       title: new Text(
          //         pair.asPascalCase,
          //         style: _biggerFont,
          //       ),
          //     );
          //   },
          // );
          // final List<Widget> divided = ListTile.divideTiles(
          //   context: context,
          //   tiles: tiles,
          // ).toList();

          return new Scaffold(
            appBar: new AppBar(
              title: const Text('Favorite Movies'),
            ),
            // body: new ListView(children: divided),
          );
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
          tooltip: 'PC',
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

class InfoMovie extends StatefulWidget {
  final Movie movie;
  InfoMovie(this.movie);

  _InfoMovieState createState() => _InfoMovieState();
}

class _InfoMovieState extends State<InfoMovie> {
  var newsMovie = Map<String, String>();

  void _infoMovieState(Movie movie) {
    var url = "http://www.omdbapi.com/?apikey=$API_KEY&i=${movie.id}&plot=full";
    http.get(url).then((response) {
      var data = json.decode(response.body);
      setState(() {
        newsMovie['rated'] = data['Rated'];
        newsMovie['plot'] = data['Plot'];
        newsMovie['released'] = data['Released'];
        newsMovie['runtime'] = data['Runtime'];
        newsMovie['genre'] = data['Genre'];
        newsMovie['director'] = data['Director'];
        newsMovie['writer'] = data['Writer'];
        newsMovie['actors'] = data['Actors'];
        //print(data);
      });
    });
  }

  @override
  initState() {
    super.initState();
    _infoMovieState(widget.movie);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text('Info'),
      ),
      body: ListView(children: [
        widget.movie.poster != 'N/A'
            ? Image.network(widget.movie.poster)
            : Icon(Icons.account_box),
        _titleSection(widget.movie),
        _textSection(widget.movie),
      ]),
    );
  }

  Widget _textSection(Movie movie) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.ltr,
        children: <Widget>[
          Text('Plot', style: TextStyle(fontWeight: FontWeight.bold)),
          Padding(padding: const EdgeInsets.only(bottom: 12.0)),
          Container(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Text(
              newsMovie.containsKey('plot') ? newsMovie['plot'] : '',
              softWrap: true,
            ),
          ),
          Container(
            child: Text(
              'Genre',
              style: TextStyle(fontWeight: FontWeight.bold),
              softWrap: true,
            ),
          ),
          Padding(padding: const EdgeInsets.only(bottom: 12.0)),
          Container(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Text(
              newsMovie.containsKey('genre') ? newsMovie['genre'] : '',
              softWrap: true,
            ),
          ),
          Container(
            child: Text(
              'Relased',
              style: TextStyle(fontWeight: FontWeight.bold),
              softWrap: true,
            ),
          ),
          Padding(padding: const EdgeInsets.only(bottom: 12.0)),
          Container(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Text(
              newsMovie.containsKey('released') ? newsMovie['released'] : '',
              softWrap: true,
            ),
          ),
          Container(
            child: Text(
              'Runtime',
              style: TextStyle(fontWeight: FontWeight.bold),
              softWrap: true,
            ),
          ),
          Padding(padding: const EdgeInsets.only(bottom: 12.0)),
          Container(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Text(
              newsMovie.containsKey('runtime') ? newsMovie['runtime'] : '',
              softWrap: true,
            ),
          ),
          Container(
            child: Text(
              'Director',
              style: TextStyle(fontWeight: FontWeight.bold),
              softWrap: true,
            ),
          ),
          Padding(padding: const EdgeInsets.only(bottom: 12.0)),
          Container(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Text(
              newsMovie.containsKey('director') ? newsMovie['director'] : '',
              softWrap: true,
            ),
          ),
          Container(
            child: Text(
              'Writer',
              style: TextStyle(fontWeight: FontWeight.bold),
              softWrap: true,
            ),
          ),
          Padding(padding: const EdgeInsets.only(bottom: 12.0)),
          Container(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Text(
              newsMovie.containsKey('writer') ? newsMovie['writer'] : '',
              softWrap: true,
            ),
          ),
          Container(
            child: Text(
              'Actors',
              style: TextStyle(fontWeight: FontWeight.bold),
              softWrap: true,
            ),
          ),
          Padding(padding: const EdgeInsets.only(bottom: 12.0)),
          Container(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Text(
              newsMovie.containsKey('actors') ? newsMovie['actors'] : '',
              softWrap: true,
            ),
          ),
          Container(
            child: Text(
              'Rated',
              style: TextStyle(fontWeight: FontWeight.bold),
              softWrap: true,
            ),
          ),
          Padding(padding: const EdgeInsets.only(bottom: 12.0)),
          Container(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Text(
              newsMovie.containsKey('rated') ? newsMovie['rated'] : '',
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _titleSection(Movie movie) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              movie.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              movie.type,
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              movie.year,
            ),
          ),
        ],
      ),
    );
    // return new ListTile(
    //   title: new Text(

    //   ),
    //   trailing: new Icon()
    // );
  }
}
