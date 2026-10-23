import 'package:flutter/material.dart';

class ReviewItem {
  final String id;
  final String movieId;
  final String movieTitle;
  final String userName;
  final int rating;
  final String comment;
  final DateTime date;

  ReviewItem({
    required this.id,
    required this.movieId,
    required this.movieTitle,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

class ReviewService {
  static final ReviewService instance = ReviewService._internal();
  ReviewService._internal();

  final ValueNotifier<List<ReviewItem>> reviewsNotifier =
      ValueNotifier<List<ReviewItem>>([]);

  List<ReviewItem> getReviewsForMovie(String movieId) {
    return reviewsNotifier.value.where((r) => r.movieId == movieId).toList();
  }

  int get totalReviewsCount => reviewsNotifier.value.length;

  int get totalReviewedMoviesCount {
    return reviewsNotifier.value.map((r) => r.movieId).toSet().length;
  }

  void addReview({
    required String movieId,
    required String movieTitle,
    required String userName,
    required int rating,
    required String comment,
  }) {
    final newItem = ReviewItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      movieId: movieId,
      movieTitle: movieTitle,
      userName: userName,
      rating: rating,
      comment: comment.trim(),
      date: DateTime.now(),
    );

    final current = List<ReviewItem>.from(reviewsNotifier.value);
    current.insert(0, newItem);
    reviewsNotifier.value = current;
  }
}
