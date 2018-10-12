import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'security_key.dart';

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

  void dispose() {
    myController.dispose();
    super.dispose();
  }

  void searchFilm() {
    var url = "http://www.omdbapi.com/?apikey=$API_KEY&s=${myController.text}";
    http.get(url).then((response) {
      print("response status: ${response.statusCode}");
      print("Response body: ${response.body}");
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Film Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          onEditingComplete: searchFilm,
          controller: myController,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: searchFilm,
        tooltip: 'Show me the value!',
        child: Icon(Icons.search),
      ),
    );
  }
}
