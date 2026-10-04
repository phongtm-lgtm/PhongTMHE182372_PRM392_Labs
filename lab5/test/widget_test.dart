import 'package:flutter_test/flutter_test.dart';
import 'package:lab5/data/sample_data.dart';
import 'package:lab5/models/movie.dart';

void main() {
  test('Sample data contains two to three movies', () {
    expect(sampleMovies.length, inInclusiveRange(2, 3));
    expect(sampleMovies, everyElement(isA<Movie>()));
  });
}
