import '../models/movie.dart';

const List<Movie> sampleMovies = [
  Movie(
    id: 'trai-buon-nguoi',
    title: 'Trại Buôn Người',
    posterUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFZ9SidOdrhSjBDDA0M3GAgMP5AcdpXqCOQyfcVgtUnDGemrlSR1fS9ao&s=10',
    overview: 'Phim trại bun người.',
    genres: ['Hành động', 'Kinh dị'],
    rating: 8.0,
    trailers: [Trailer(title: 'Trại Buôn Người — Trailer', url: 'youtube.com')],
  ),
  Movie(
    id: 'giai-cuu-quai-thu',
    title: 'Giải Cứu Quái Thú',
    posterUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRougX9W_PGlLQIH8zNKlrJW7SrM-V2eaz6zGgsg1RrBg&s',
    overview: 'Phim giải cứu quái thú',
    genres: ['Hành động', 'Kinh dị'],
    rating: 8.5,
    trailers: [
      Trailer(title: 'Giải Cứu Quái Thú — Trailer', url: 'youtube.com'),
    ],
  ),
];
