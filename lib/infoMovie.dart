import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './security_key.dart';
import './movie.dart';

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
        mainAxisSize: MainAxisSize.min,
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
  }
}
