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

  Widget _buildRow(String movieTitle) {
    return ListTile(
      title: Text(movieTitle),
    );
  }

  List<Widget> _buildListViewChildren() {
    final listWidget = <Widget>[];
    _movies.forEach((element) {
      listWidget.add(_buildRow(element.title));
      listWidget.add(Divider());
    });
    return listWidget;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Film Search'),
      ),
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
}
