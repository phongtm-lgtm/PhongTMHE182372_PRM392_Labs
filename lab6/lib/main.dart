import 'package:flutter/material.dart';

void main() => runApp(const ResponsiveMovieApp());

class Movie {
  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;

  const Movie(this.title, this.year, this.genres, this.posterUrl, this.rating);
}

const allMovies = [
  Movie(
    'Mai',
    2024,
    ['Drama', 'Romance'],
    'https://picsum.photos/seed/mai/200/300',
    8.2,
  ),
  Movie(
    'Bố Già',
    2021,
    ['Drama', 'Comedy'],
    'https://picsum.photos/seed/bogia/200/300',
    7.8,
  ),
  Movie(
    'Lật Mặt 7',
    2024,
    ['Drama', 'Family'],
    'https://picsum.photos/seed/latmat/200/300',
    8.0,
  ),
  Movie(
    'Hai Phượng',
    2019,
    ['Action', 'Drama'],
    'https://picsum.photos/seed/haiphuong/200/300',
    7.5,
  ),
  Movie(
    'Tiệc Trăng Máu',
    2020,
    ['Comedy', 'Drama'],
    'https://picsum.photos/seed/tiectrangmau/200/300',
    7.9,
  ),
  Movie(
    'Quỷ Cẩu',
    2023,
    ['Horror'],
    'https://picsum.photos/seed/quycau/200/300',
    7.0,
  ),
];

const genres = ['Action', 'Drama', 'Comedy', 'Romance', 'Family', 'Horror'];
const sortOptions = ['A–Z', 'Z–A', 'Year', 'Rating'];

class ResponsiveMovieApp extends StatelessWidget {
  const ResponsiveMovieApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Lab 6 — Movie Genres',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const GenreScreen(),
  );
}

class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  final searchController = TextEditingController();
  final Set<String> selectedGenres = {};
  String searchQuery = '';
  String selectedSort = 'A–Z';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Movie> get visibleMovies {
    final movies = allMovies.where((movie) {
      final matchesTitle = movie.title.toLowerCase().contains(
        searchQuery.trim().toLowerCase(),
      );
      final matchesGenre =
          selectedGenres.isEmpty || movie.genres.any(selectedGenres.contains);
      return matchesTitle && matchesGenre;
    }).toList();
    movies.sort(
      (a, b) => switch (selectedSort) {
        'Z–A' => b.title.compareTo(a.title),
        'Year' => b.year.compareTo(a.year),
        'Rating' => b.rating.compareTo(a.rating),
        _ => a.title.compareTo(b.title),
      },
    );
    return movies;
  }

  @override
  Widget build(BuildContext context) {
    final movies = visibleMovies;
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 800;
            final padding = screenWidth < 600 ? 16.0 : 32.0;
            // Toàn trang cuộn để cả phần bộ lọc không tràn ở chế độ ngang.
            return SingleChildScrollView(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Lab 6.1: Hero và heading thích ứng với chiều rộng.
                  Container(
                    padding: EdgeInsets.all(wide ? 32 : 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [Colors.deepPurple, Colors.indigo],
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Find a Movie',
                                style: TextStyle(
                                  fontSize: wide ? 36 : 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Khám phá phim theo thể loại yêu thích',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        if (wide)
                          const Icon(
                            Icons.movie_outlined,
                            size: 80,
                            color: Colors.white70,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Lab 6.2: Search, chips và sort.
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Tìm theo tên phim...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onChanged: (value) => setState(() => searchQuery = value),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Genres (${selectedGenres.length} đã chọn)',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: genres
                        .map(
                          (genre) => FilterChip(
                            label: Text(genre),
                            selected: selectedGenres.contains(genre),
                            onSelected: (selected) => setState(() {
                              selected
                                  ? selectedGenres.add(genre)
                                  : selectedGenres.remove(genre);
                            }),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text('${movies.length} phim'),
                      DropdownButton<String>(
                        value: selectedSort,
                        items: sortOptions
                            .map(
                              (sort) => DropdownMenuItem(
                                value: sort,
                                child: Text(sort),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => selectedSort = value!),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.clear_all),
                        label: const Text('Clear filters'),
                        onPressed: () => setState(() {
                          searchController.clear();
                          searchQuery = '';
                          selectedGenres.clear();
                          selectedSort = 'A–Z';
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Lab 6.3: <800 px: list; >=800 px: grid hai cột.
                  if (movies.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Text('Không tìm thấy phim phù hợp.'),
                    )
                  else if (wide)
                    GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      mainAxisExtent:
                          190 * MediaQuery.textScalerOf(context).scale(1),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: movies
                          .map((movie) => MovieCard(movie: movie))
                          .toList(),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: movies.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: MovieCard(movie: movies[index]),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;
  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final posterWidth = constraints.maxWidth < 400 ? 70.0 : 90.0;
      return Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              SizedBox(
                width: posterWidth,
                height: posterWidth * 1.5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    movie.posterUrl,
                    width: posterWidth,
                    height: posterWidth * 1.5,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text('${movie.year}'),
                    Text(
                      movie.genres.join(' • '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '★ ${movie.rating}',
                      style: const TextStyle(color: Colors.deepOrange),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
