import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi-Section App',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _sections = ['Characters', 'Planets', 'Movies'];
  int _selectedSection = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(_sections[_selectedSection]),
      ),
      body: Row(
        children: [
          Container(
            width: 100,
            color: Colors.black12,
            child: Column(
              children: [
                _buildSectionButton(0, 'Characters'),
                _buildSectionButton(1, 'Planets'),
                _buildSectionButton(2, 'Movies'),
              ],
            ),
          ),
          Expanded(
            child: _buildSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionButton(int index, String title) {
    return TextButton(
      onPressed: () {
        setState(() {
          _selectedSection = index;
        });
      },
      child: Text(title),
      style: ButtonStyle(
        backgroundColor: _selectedSection == index
            ? MaterialStateProperty.all(Colors.deepOrange)
            : MaterialStateProperty.all(Colors.transparent),
        foregroundColor: _selectedSection == index
            ? MaterialStateProperty.all(Colors.white)
            : MaterialStateProperty.all(Colors.white),
      ),
    );
  }

  Widget _buildSection() {
    switch (_selectedSection) {
      case 0:
        return _buildCharacterSection();
      case 1:
        return _buildPlanetSection();
      case 2:
        return _buildMovieSection();
      default:
        return Container();
    }
  }

  Future<List<dynamic>> _fetchData(String apiUrl) async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to fetch data from the API');
    }
  }

  Widget _buildCharacterSection() {
    return FutureBuilder<List<dynamic>>(
      future: _fetchData('https://swapi.dev/api/people/'),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final characters = snapshot.data!;
          return Container(
            color: Colors.black,
            child: ListView.builder(
              itemCount: characters.length,
              itemBuilder: (context, index) {
                final character = characters[index];
                return ListTile(
                  title: Text(character['name'],
                  style:TextStyle(color: Colors.white),),
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('${snapshot.error}'));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildPlanetSection() {
    return FutureBuilder<List<dynamic>>(
      future: _fetchData('https://swapi.dev/api/planets/'),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final planets = snapshot.data!;
          return Container(
            color: Colors.black,
            child: ListView.builder(
              itemCount: planets.length,
              itemBuilder: (context, index) {
                final planet = planets[index];
                return ListTile(
                  title: Text(planet['name'],
                  style: TextStyle(color: Colors.white),),
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('${snapshot.error}'));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildMovieSection() {
    return FutureBuilder<List<dynamic>>(
      future: _fetchData('https://swapi.dev/api/films/'),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final movies = snapshot.data!;
          return Container(
            color: Colors.black,
            child: ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return ListTile(
                  title: Text(movie['title'],
                  style: TextStyle(color: Colors.white),),
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('${snapshot.error}'));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}