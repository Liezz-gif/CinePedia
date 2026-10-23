import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/movie.dart';
import 'screens/auth_screen.dart';
import 'screens/movie_detail.dart';
import 'screens/movie_list.dart';
import 'services/auth_service.dart';
import 'services/favorite_service.dart';
import 'services/language_service.dart';
import 'services/review_service.dart';
import 'widgets/movie_poster.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.instance.init();
  await LanguageService.instance.init();
  runApp(const CinePediaApp());
}

class CinePediaApp extends StatelessWidget {
  const CinePediaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: LanguageService.instance.currentLangNotifier,
      builder: (context, currentLang, _) {
        return MaterialApp(
          title: 'CinePedia',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.amber,
            scaffoldBackgroundColor: const Color(0xFF121212),
            colorScheme: const ColorScheme.dark(
              primary: Colors.amber,
              secondary: Colors.amberAccent,
            ),
          ),
          home: ValueListenableBuilder<UserModel?>(
            valueListenable: AuthService.instance.currentUserNotifier,
            builder: (context, user, _) {
              if (user == null) {
                return const AuthScreen();
              }
              return const HomePage();
            },
          ),
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final lang = LanguageService.instance;

    final List<Widget> pages = [
      _buildHomeContent(context),
      _buildFavoritesContent(context),
      _buildProfileContent(context),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle(_selectedIndex)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (_selectedIndex == 0)
            IconButton(
              icon: const Icon(Icons.notifications_none),
              tooltip: 'Notifikasi',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tidak ada notifikasi baru saat ini.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: lang.getText('home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            label: lang.getText('favorites'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: lang.getText('profile'),
          ),
        ],
      ),
    );
  }

  String _getAppBarTitle(int index) {
    final lang = LanguageService.instance;
    switch (index) {
      case 0:
        return lang.getText('welcome');
      case 1:
        return lang.getText('favoriteTitle');
      case 2:
        return lang.getText('profileTitle');
      default:
        return 'CinePedia';
    }
  }

  // --- TAB 1: HOME VIEW ---
  Widget _buildHomeContent(BuildContext context) {
    final lang = LanguageService.instance;

    return FutureBuilder<List<Movie>>(
      future: loadMoviesFromJson(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.amber),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Gagal memuat data: ${snapshot.error}',
              style: const TextStyle(color: Colors.white),
            ),
          );
        }

        final movies = snapshot.data ?? [];

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Interactive Search Container
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MovieListScreen(category: 'Semua'),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[800]!),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.amber),
                        const SizedBox(width: 12),
                        Text(
                          lang.getText('searchHint'),
                          style: const TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Categories Header & Grid
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      lang.getText('genreCategory'),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MovieListScreen(category: 'Semua'),
                          ),
                        );
                      },
                      child: Text(
                        lang.getText('seeAll'),
                        style: const TextStyle(color: Colors.amber),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCategoryIcon(Icons.flash_on, 'Action', context),
                    _buildCategoryIcon(Icons.theater_comedy, 'Drama', context),
                    _buildCategoryIcon(Icons.rocket_launch, 'Sci-Fi', context),
                    _buildCategoryIcon(Icons.animation, 'Animation', context),
                    _buildCategoryIcon(Icons.apps, 'Semua', context),
                  ],
                ),

                const SizedBox(height: 28),

                // Featured Movies (Horizontal Scroll)
                Text(
                  lang.getText('popularToday'),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 210,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return Container(
                        width: 130,
                        margin: const EdgeInsets.only(right: 14),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieDetailScreen(movie: movie),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MoviePoster(
                                imageUrl: movie.imageUrl,
                                title: movie.title,
                                width: 130,
                                height: 150,
                                borderRadius: 12,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                movie.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.star, size: 14, color: Colors.amber),
                                  const SizedBox(width: 4),
                                  Text(
                                    movie.rating,
                                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Quick List Section
                Text(
                  lang.getText('recommendedForYou'),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return Card(
                      color: Colors.grey[900],
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: MoviePoster(
                          imageUrl: movie.imageUrl,
                          title: movie.title,
                          width: 50,
                          height: 70,
                          borderRadius: 8,
                        ),
                        title: Text(
                          movie.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(movie.genre, style: const TextStyle(color: Colors.amber)),
                        trailing: ValueListenableBuilder<Set<String>>(
                          valueListenable: FavoriteService.instance.favoritesNotifier,
                          builder: (context, favorites, _) {
                            final isFav = favorites.contains(movie.id);
                            return IconButton(
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: isFav ? Colors.redAccent : Colors.grey,
                              ),
                              onPressed: () {
                                FavoriteService.instance.toggleFavorite(movie.id);
                              },
                            );
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetailScreen(movie: movie),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryIcon(IconData icon, String label, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieListScreen(category: label),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 30, color: Colors.amber),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // --- TAB 2: FAVORITES VIEW ---
  Widget _buildFavoritesContent(BuildContext context) {
    final lang = LanguageService.instance;

    return FutureBuilder<List<Movie>>(
      future: loadMoviesFromJson(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.amber),
          );
        }

        final allMovies = snapshot.data ?? [];

        return ValueListenableBuilder<Set<String>>(
          valueListenable: FavoriteService.instance.favoritesNotifier,
          builder: (context, favorites, _) {
            final favoriteMovies = allMovies.where((m) => favorites.contains(m.id)).toList();

            if (favoriteMovies.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      lang.getText('noFavTitle'),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      lang.getText('noFavSub'),
                      style: const TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 0;
                        });
                      },
                      icon: const Icon(Icons.explore, color: Colors.black),
                      label: Text(
                        lang.getText('exploreMovies'),
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteMovies.length,
              itemBuilder: (context, index) {
                final movie = favoriteMovies[index];
                return Card(
                  color: Colors.grey[900],
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: MoviePoster(
                      imageUrl: movie.imageUrl,
                      title: movie.title,
                      width: 50,
                      height: 70,
                      borderRadius: 8,
                    ),
                    title: Text(movie.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(movie.genre, style: const TextStyle(color: Colors.amber)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () {
                        FavoriteService.instance.toggleFavorite(movie.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${movie.title} dihapus dari Favorit'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailScreen(movie: movie),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  // --- TAB 3: PROFILE VIEW ---
  Widget _buildProfileContent(BuildContext context) {
    return _ProfileView();
  }
}

class _ProfileView extends StatefulWidget {
  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  bool _notifications = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationPref();
  }

  Future<void> _loadNotificationPref() async {
    try {
      final sp = await SharedPreferences.getInstance();
      if (mounted) {
        setState(() {
          _notifications = sp.getBool('notifications_enabled') ?? true;
        });
      }
    } catch (_) {}
  }

  void _showLanguageSelectionDialog(BuildContext context) {
    final lang = LanguageService.instance;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.language, color: Colors.amber, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    lang.getText('language'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: LanguageService.languageNames.length,
                  separatorBuilder: (context, index) => const Divider(color: Colors.grey, height: 1),
                  itemBuilder: (context, index) {
                    final code = LanguageService.languageNames.keys.elementAt(index);
                    final name = LanguageService.languageNames[code]!;
                    final flag = LanguageService.languageFlags[code] ?? '🌐';
                    final isSelected = lang.currentLangNotifier.value == code;

                    return ListTile(
                      leading: Text(
                        flag,
                        style: const TextStyle(fontSize: 22),
                      ),
                      title: Text(
                        name,
                        style: TextStyle(
                          color: isSelected ? Colors.amber : Colors.white,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: Colors.amber)
                          : null,
                      onTap: () async {
                        final messenger = ScaffoldMessenger.of(context);
                        Navigator.pop(context);
                        await lang.changeLanguage(code);

                        messenger.hideCurrentSnackBar();
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              '${lang.getText('language')}: $name',
                            ),
                            backgroundColor: Colors.amber[800],
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = LanguageService.instance;
    final currentUser = AuthService.instance.currentUserNotifier.value;
    final userName = currentUser?.fullName ?? 'Penggemar Film';
    final userEmail = currentUser?.email ?? 'user@gmail.com';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Profile Header
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.amber,
                  child: const CircleAvatar(
                    radius: 46,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  userName,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  userEmail,
                  style: const TextStyle(color: Colors.amber, fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // User Stats Cards
          ValueListenableBuilder<Set<String>>(
            valueListenable: FavoriteService.instance.favoritesNotifier,
            builder: (context, favorites, _) {
              return ValueListenableBuilder<List<ReviewItem>>(
                valueListenable: ReviewService.instance.reviewsNotifier,
                builder: (context, reviews, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatCard(lang.getText('myFavoritesStat'), '${favorites.length}'),
                      _buildStatCard(lang.getText('myReviewsStat'), '${ReviewService.instance.totalReviewsCount}'),
                    ],
                  );
                },
              );
            },
          ),

          const SizedBox(height: 32),

          // Settings Options
          Material(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(16),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.notifications, color: Colors.amber),
                  title: Text(lang.getText('newReleaseNotif')),
                  subtitle: Text(
                    lang.getText('notifSub'),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  value: _notifications,
                  activeTrackColor: Colors.amber,
                  onChanged: (val) async {
                    setState(() {
                      _notifications = val;
                    });
                    final messenger = ScaffoldMessenger.of(context);
                    try {
                      final sp = await SharedPreferences.getInstance();
                      await sp.setBool('notifications_enabled', val);
                    } catch (_) {}

                    messenger.hideCurrentSnackBar();
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(
                          val
                              ? '🔔 ${lang.getText('newReleaseNotif')}: ON'
                              : '🔕 ${lang.getText('newReleaseNotif')}: OFF',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, color: Colors.grey),
                ListTile(
                  leading: const Icon(Icons.language, color: Colors.amber),
                  title: Text(lang.getText('language')),
                  trailing: Text(lang.currentLanguageName, style: const TextStyle(color: Colors.grey)),
                  onTap: () => _showLanguageSelectionDialog(context),
                ),
                const Divider(height: 1, color: Colors.grey),
                ListTile(
                  leading: const Icon(Icons.info_outline, color: Colors.amber),
                  title: Text(lang.getText('about')),
                  trailing: const Text('v1.0.0', style: TextStyle(color: Colors.grey)),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'CinePedia',
                      applicationVersion: '1.0.0',
                      applicationLegalese: '© 2026 CinePedia UTS Mobile Programming',
                    );
                  },
                ),
                const Divider(height: 1, color: Colors.grey),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.redAccent),
                  title: Text(
                    lang.getText('logout'),
                    style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                  ),
                  onTap: () => _logoutDialog(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String count) {
    return Container(
      width: 140,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _logoutDialog(BuildContext context) {
    final lang = LanguageService.instance;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(lang.getText('logout'), style: const TextStyle(color: Colors.white)),
          content: const Text('Apakah Anda yakin ingin keluar dari akun CinePedia Anda?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () {
                Navigator.pop(context);
                AuthService.instance.logout();
              },
              child: Text(lang.getText('logout'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}
