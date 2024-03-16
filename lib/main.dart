import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';

class Movie {
  final String title;
  final String overview;
  final String releaseDate;
  final double rating;
  final String? posterPath; // URL de la portada de la película

  Movie({
    required this.title,
    required this.overview,
    required this.releaseDate,
    required this.rating,
    required this.posterPath,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'],
      overview: json['overview'],
      releaseDate: json['release_date'],
      rating: (json['vote_average'] ?? 0.0).toDouble(),
      posterPath: json['poster_path'], // URL de la portada de la película
    );
  }
}

class PopularM extends StatefulWidget {
  const PopularM({Key? key}) : super(key: key);

  @override
  _PopularMState createState() => _PopularMState();
}

class _PopularMState extends State<PopularM> {
  late Future<List<Movie>> futurepopular;

  List<String> customImages = [];

  @override
  void initState() {
    super.initState();
    futurepopular = fetchpopular();
  }

  Future<List<Movie>> fetchpopular() async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/popular?api_key=58c207bd5cc2dd27d2fa1429c5dfade7&language=en-US&page=1'),
    );

    if (response.statusCode == 200) {
      final List<Movie> movies = [];
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic> results = jsonData['results'];
      results.forEach((movieData) {
        final Movie movie = Movie.fromJson(movieData);
        movies.add(movie);
      });
      return movies;
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Widget _buildCarousel(List<Movie> movies) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        viewportFraction: 0.8,
      ),
      items: [
        for (var movie in movies)
          if (movie.posterPath != null)
            Image.network(
              'https://image.tmdb.org/t/p/w185${movie.posterPath}',
              fit: BoxFit.cover,
            ),
        for (var imageUrl in customImages)
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
      ),
      body: FutureBuilder<List<Movie>>(
        future: futurepopular,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final movie = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCarousel([movie]),
                      ListTile(
                        title: Text(movie.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Release Date: ${movie.releaseDate}'),
                            Text('Overview: ${movie.overview}'),
                            Text('Rating: ${movie.rating}'),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Agregar Imagen'),
                                content: TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      customImages.add(value);
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'URL de la imagen',
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Aceptar'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Text('Agregar Imagen'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PopularM(),
  ));
}
