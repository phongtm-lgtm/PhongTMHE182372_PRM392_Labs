// Single-file DartPad edition of Lab 5.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Trailer {
  final String title;
  final String url;

  const Trailer({required this.title, required this.url});
}

class Movie {
  final String id;
  final String title;
  final String posterUrl;
  final String overview;
  final List<String> genres;
  final double rating;
  final List<Trailer> trailers;

  const Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.overview,
    required this.genres,
    required this.rating,
    required this.trailers,
  });
}

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

class MoviePoster extends StatelessWidget {
  final String url;
  final double width;
  final double height;

  const MoviePoster({
    super.key,
    required this.url,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(url, width: width, height: height, fit: BoxFit.cover);
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const MovieCard({super.key, required this.movie, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: MoviePoster(url: movie.posterUrl, width: 50, height: 75),
        title: Text(movie.title),
        subtitle: Text('★ ${movie.rating} / 10'),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  bool isFavorite = false;
  int? userRating;

  Movie get movie => widget.movie;

  // Chọn điểm trong hộp thoại, cập nhật màn hình bằng setState.
  Future<void> rateMovie() async {
    double selected = (userRating ?? 8).toDouble();
    final result = await showDialog<int>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, updateDialog) => AlertDialog(
          title: const Text('Chấm điểm phim'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${selected.round()} / 10'),
              Slider(
                value: selected,
                min: 1,
                max: 10,
                divisions: 9,
                onChanged: (value) => updateDialog(() => selected = value),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Hủy'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, selected.round()),
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );
    if (mounted && result != null) setState(() => userRating = result);
  }

  // Dùng Flutter SDK để xem/sao chép nội dung, không cần plugin cho DartPad.
  void showContent(String title, String content) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(child: SelectableText(content)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Đóng'),
          ),
          FilledButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: content));
              if (!dialogContext.mounted || !mounted) return;
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Đã sao chép.')));
            },
            child: const Text('Sao chép'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết phim')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Stack(
                    children: [
                      MoviePoster(
                        url: movie.posterUrl,
                        width: double.infinity,
                        height: 300,
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black87],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Wrap(
                          spacing: 8,
                          children: movie.genres
                              .map((genre) => Chip(label: Text(genre)))
                              .toList(),
                        ),
                        Text('★ ${movie.rating} / 10'),
                        if (userRating != null)
                          Text('Điểm của bạn: $userRating / 10'),
                        const SizedBox(height: 16),
                        Text(
                          'Nội dung phim',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(movie.overview),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              tooltip: 'Favorite',
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite ? Colors.pinkAccent : null,
                              ),
                              onPressed: () =>
                                  setState(() => isFavorite = !isFavorite),
                            ),
                            IconButton(
                              tooltip: 'Rate',
                              icon: const Icon(Icons.star_outline),
                              onPressed: rateMovie,
                            ),
                            IconButton(
                              tooltip: 'Share',
                              icon: const Icon(Icons.share_outlined),
                              onPressed: () => showContent(
                                'Chia sẻ phim',
                                '${movie.title}\n★ ${movie.rating} / 10\n${movie.overview}',
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Trailers',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: movie.trailers.length,
                          itemBuilder: (context, index) => ListTile(
                            leading: const Icon(Icons.play_circle_outline),
                            title: Text(movie.trailers[index].title),
                            subtitle: const Text('Xem / sao chép liên kết'),
                            onTap: () => showContent(
                              movie.trailers[index].title,
                              movie.trailers[index].url,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movie List')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sampleMovies.length,
        itemBuilder: (context, index) {
          final movie = sampleMovies[index];
          return MovieCard(
            movie: movie,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailScreen(movie: movie),
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() => runApp(const MovieApp());

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF12121C),
      ),
      home: const HomeScreen(),
    );
  }
}
