import 'package:flutter/material.dart';

import '../models/movie.dart';
import 'movie_poster.dart';

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
