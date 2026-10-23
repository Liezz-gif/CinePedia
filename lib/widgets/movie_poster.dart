import 'package:flutter/material.dart';

class MoviePoster extends StatefulWidget {
  final String imageUrl;
  final String? title;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;

  const MoviePoster({
    super.key,
    required this.imageUrl,
    this.title,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 8.0,
  });

  @override
  State<MoviePoster> createState() => _MoviePosterState();
}

class _MoviePosterState extends State<MoviePoster> {
  bool _useFallbackUrl = false;

  @override
  Widget build(BuildContext context) {
    final String currentUrl = _useFallbackUrl
        ? _getFallbackUrl(widget.title, widget.imageUrl)
        : widget.imageUrl;

    final bool isAsset = currentUrl.startsWith('assets/');

    Widget imageWidget;
    if (isAsset) {
      imageWidget = Image.asset(
        currentUrl,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        errorBuilder: (context, error, stackTrace) => _buildFallbackPoster(),
      );
    } else {
      imageWidget = Image.network(
        currentUrl,
        headers: const {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
        },
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: widget.width,
            height: widget.height,
            color: Colors.grey[900],
            child: const Center(
              child: CircularProgressIndicator(color: Colors.amber, strokeWidth: 2),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          if (!_useFallbackUrl) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _useFallbackUrl = true;
                });
              }
            });
            return Container(
              width: widget.width,
              height: widget.height,
              color: Colors.grey[900],
            );
          }
          return _buildFallbackPoster();
        },
      );
    }

    if (widget.borderRadius > 0) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  String _getFallbackUrl(String? title, String originalUrl) {
    if (title != null && title.toLowerCase().contains('joker')) {
      return 'https://image.tmdb.org/t/p/w500/udDclSub2A1kKqB3Pwh929B3Lwo.jpg';
    }
    if (title != null && title.toLowerCase().contains('oppenheimer')) {
      return 'https://image.tmdb.org/t/p/w500/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg';
    }
    if (title != null && title.toLowerCase().contains('spider')) {
      return 'https://image.tmdb.org/t/p/w500/8Vt6mWEReuy4Of61Lnj5Xj704m8.jpg';
    }
    if (title != null && title.toLowerCase().contains('dune')) {
      return 'https://image.tmdb.org/t/p/w500/1pdfLvkbY9ohJlCjQH2TDpiO9JC.jpg';
    }
    if (title != null && title.toLowerCase().contains('dark knight')) {
      return 'https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg';
    }
    if (title != null && title.toLowerCase().contains('interstellar')) {
      return 'https://image.tmdb.org/t/p/w500/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg';
    }
    if (title != null && title.toLowerCase().contains('parasite')) {
      return 'https://image.tmdb.org/t/p/w500/7Ii2B6K2K20o2S6C18RToce59pC.jpg';
    }
    if (title != null && title.toLowerCase().contains('avengers')) {
      return 'https://image.tmdb.org/t/p/w500/or06FN3Dka5tukK1e91Sq13L305.jpg';
    }
    if (title != null && title.toLowerCase().contains('inception')) {
      return 'https://image.tmdb.org/t/p/w500/oYuLE1311oA8hA8O23B92AoxL2U.jpg';
    }
    if (title != null && title.toLowerCase().contains('conjuring')) {
      return 'https://image.tmdb.org/t/p/w500/wVYREutA13A3qR3rm428m9vR3as.jpg';
    }
    return 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=600&auto=format&fit=crop';
  }

  Widget _buildFallbackPoster() {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.amber.shade900.withValues(alpha: 0.8),
            Colors.grey.shade900,
            Colors.black87,
          ],
        ),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.movie, color: Colors.amber, size: 36),
          const SizedBox(height: 6),
          if (widget.title != null && widget.title!.isNotEmpty) ...[
            Text(
              widget.title!,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ] else ...[
            const Text(
              'CinePedia',
              style: TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ],
        ],
      ),
    );
  }
}
