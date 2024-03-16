// ignore_for_file: camel_case_types, non_constant_identifier_names, library_private_types_in_public_api, invalid_annotation_target
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
part 'popular.freezed.dart';
part 'popular.g.dart';

@HiveType(typeId: 0)
@freezed
class Popular with _$Popular {
  const factory Popular({
    @HiveField(0) @JsonKey(name: 'page') required int page,
    @HiveField(1) @JsonKey(name: 'results') required List<Object> results,
    @HiveField(2) @JsonKey(name: 'total_pages') required int total_pages,
    @HiveField(3) @JsonKey(name: 'total_results') required int total_results,
  }) = _Popular;

  factory Popular.fromJson(Map<String, dynamic> json) =>
      _$PopularFromJson(json);
}

class PopularM extends StatefulWidget {
  const PopularM({super.key});

  @override
  _PopularMState createState() => _PopularMState();
}

class _PopularMState extends State<PopularM> {
  late Future<Popular> futurepopular;

  @override
  void initState() {
    super.initState();
    futurepopular = fetchpopular();
  }

  Future<Popular> fetchpopular() async {
    final movieResponse = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/popular?api_key=58c207bd5cc2dd27d2fa1429c5dfade7&language=en-US&page=1'),
    );

    if (movieResponse.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(movieResponse.body);
      return Popular.fromJson(jsonData);
    } else {
      throw Exception('Fallo al obtener los datos de las películas');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Moviesa'),
      ),
      body: Center(
        child: FutureBuilder<Popular>(
          future: futurepopular,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final popularData = snapshot.data!;
              final List<Map<String, dynamic>> results =
                  popularData.results.cast<Map<String, dynamic>>();

              return SizedBox(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: results.map((result) {
                    final title = result['title'] as String;
                    final overview = result['overview'] as String;
                    return Container(
                      width: 200,
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(title),
                          const SizedBox(height: 4.0),
                          Text(overview),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
