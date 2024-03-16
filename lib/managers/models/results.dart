import 'package:freezed_annotation/freezed_annotation.dart';

part 'results.freezed.dart';
part 'results.g.dart';

@freezed
class Results with _$Results {
  const factory Results({
    @JsonKey(name: "adult") required bool adult,
    @JsonKey(name: "backdrop_path") required String backdrop_path,
    @JsonKey(name: "genre_ids") required List<int> genre_ids,
    @JsonKey(name: "id") required int id,
    @JsonKey(name: "original_language") required String original_language,
    @JsonKey(name: "original_title") required String original_title,
    @JsonKey(name: "overview") required String overview,
    @JsonKey(name: "popularity") required double popularity,
    @JsonKey(name: "poster_path") required String poster_path,
    @JsonKey(name: "release_date") required String release_date,
    @JsonKey(name: "title") required String title,
    @JsonKey(name: "video") required String video,
    @JsonKey(name: "vote_average") required double vote_average,
    @JsonKey(name: "vote_count") required int vote_count,
  }) = _Results;

  factory Results.fromJson(Map<String, Object?> json) =>
      _$ResultsFromJson(json);
}
