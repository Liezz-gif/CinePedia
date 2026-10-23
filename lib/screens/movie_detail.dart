import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/auth_service.dart';
import '../services/favorite_service.dart';
import '../services/language_service.dart';
import '../services/review_service.dart';
import '../widgets/movie_poster.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  int _userRating = 0; // Default: 0 stars
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _submitReview() {
    final lang = LanguageService.instance;

    if (_userRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih rating bintang terlebih dahulu (1 - 5 bintang).'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final comment = _reviewController.text.trim();
    if (comment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan tuliskan pendapat atau ulasan Anda terlebih dahulu.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final currentUser = AuthService.instance.currentUserNotifier.value;
    final userName = currentUser?.fullName ?? 'Pengguna CinePedia';

    ReviewService.instance.addReview(
      movieId: widget.movie.id,
      movieTitle: widget.movie.title,
      userName: userName,
      rating: _userRating,
      comment: comment,
    );

    setState(() {
      _userRating = 0;
    });
    _reviewController.clear();
    FocusScope.of(context).unfocus();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${lang.getText('writeReview')}: Sukses!'),
        backgroundColor: Colors.amber,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;
    final lang = LanguageService.instance;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(movie.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          ValueListenableBuilder<Set<String>>(
            valueListenable: FavoriteService.instance.favoritesNotifier,
            builder: (context, favorites, _) {
              final isFav = favorites.contains(movie.id);
              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.redAccent : Colors.white,
                ),
                tooltip: isFav ? lang.getText('removeFavorite') : lang.getText('addFavorite'),
                onPressed: () {
                  FavoriteService.instance.toggleFavorite(movie.id);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFav
                            ? '${movie.title} - ${lang.getText('removeFavorite')}'
                            : '${movie.title} - ${lang.getText('addFavorite')}',
                      ),
                      action: SnackBarAction(
                        label: 'Batal',
                        onPressed: () {
                          FavoriteService.instance.toggleFavorite(movie.id);
                        },
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Banner Image
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 360,
                  child: MoviePoster(
                    imageUrl: movie.imageUrl,
                    title: movie.title,
                    width: double.infinity,
                    height: 360,
                    borderRadius: 0,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 90,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          const Color(0xFF121212).withValues(alpha: 0.9),
                          const Color(0xFF121212),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Genre, Duration & Rating Badges
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.amber.withValues(alpha: 0.5)),
                        ),
                        child: Text(
                          movie.genre,
                          style: const TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Icon(Icons.access_time, color: Colors.grey, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        movie.duration,
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(width: 14),
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        movie.rating,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Prominent Favorite Action Button
                  SizedBox(
                    width: double.infinity,
                    child: ValueListenableBuilder<Set<String>>(
                      valueListenable: FavoriteService.instance.favoritesNotifier,
                      builder: (context, favorites, _) {
                        final isFav = favorites.contains(movie.id);
                        return ElevatedButton.icon(
                          onPressed: () {
                            FavoriteService.instance.toggleFavorite(movie.id);
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isFav
                                      ? '${movie.title} - ${lang.getText('removeFavorite')}'
                                      : '${movie.title} - ${lang.getText('addFavorite')}',
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.redAccent : Colors.black,
                          ),
                          label: Text(
                            isFav ? lang.getText('removeFavorite') : lang.getText('addFavorite'),
                            style: TextStyle(
                              color: isFav ? Colors.redAccent : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isFav ? Colors.grey[900] : Colors.amber,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: isFav
                                  ? const BorderSide(color: Colors.redAccent)
                                  : BorderSide.none,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Sinopsis Lengkap
                  Row(
                    children: [
                      const Icon(Icons.menu_book, color: Colors.amber, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        lang.getText('synopsisHeader'),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[800]!),
                    ),
                    child: Text(
                      movie.description,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.7,
                        color: Colors.grey[200],
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Write Review Section
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[800]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.rate_review, color: Colors.amber, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              lang.getText('writeReview'),
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              lang.getText('selectRating'),
                              style: const TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                            Text(
                              _userRating == 0 ? lang.getText('notSelected') : '$_userRating ${lang.getText('stars')}',
                              style: TextStyle(
                                color: _userRating == 0 ? Colors.grey : Colors.amber,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: List.generate(5, (index) {
                            final starIndex = index + 1;
                            return IconButton(
                              padding: const EdgeInsets.only(right: 6),
                              constraints: const BoxConstraints(),
                              icon: Icon(
                                starIndex <= _userRating ? Icons.star : Icons.star_border,
                                color: starIndex <= _userRating ? Colors.amber : Colors.grey[600],
                                size: 32,
                              ),
                              onPressed: () {
                                setState(() {
                                  _userRating = starIndex;
                                });
                              },
                            );
                          }),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: _reviewController,
                          style: const TextStyle(color: Colors.white),
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: '${lang.getText('writeReview')}...',
                            hintStyle: const TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.black45,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _submitReview,
                            icon: const Icon(Icons.send, color: Colors.black, size: 18),
                            label: Text(
                              lang.getText('submitReview'),
                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Reviews List Section
                  ValueListenableBuilder<List<ReviewItem>>(
                    valueListenable: ReviewService.instance.reviewsNotifier,
                    builder: (context, allReviews, _) {
                      final movieReviews = ReviewService.instance.getReviewsForMovie(movie.id);

                      if (movieReviews.isEmpty) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              const Icon(Icons.chat_bubble_outline, color: Colors.grey, size: 36),
                              const SizedBox(height: 8),
                              Text(
                                lang.getText('noReviews'),
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                lang.getText('noReviewsSub'),
                                style: const TextStyle(color: Colors.grey, fontSize: 13),
                              ),
                            ],
                          ),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${lang.getText('userReviews')} (${movieReviews.length})',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: movieReviews.length,
                            itemBuilder: (context, index) {
                              final review = movieReviews[index];
                              return Card(
                                color: Colors.grey[900],
                                margin: const EdgeInsets.only(bottom: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const CircleAvatar(
                                                radius: 14,
                                                backgroundColor: Colors.amber,
                                                child: Icon(Icons.person, size: 16, color: Colors.black),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                review.userName,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: List.generate(
                                              review.rating,
                                              (_) => const Icon(Icons.star, color: Colors.amber, size: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        review.comment,
                                        style: TextStyle(color: Colors.grey[300], fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
