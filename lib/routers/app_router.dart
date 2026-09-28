import 'package:go_router/go_router.dart';

import '../widgets/home_screen.dart';
import '../widgets/news_article_screen.dart';
import '../widgets/news_category_screen.dart';
import '../widgets/splash_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const home = '/home';
  static const newsCategory = '/news-category';
  static const newsArticle = '/news-article';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.newsCategory,
      builder: (context, state) => NewsCategoryScreen(
        category: state.uri.queryParameters['name'] ?? 'Tin tức',
      ),
    ),
    GoRoute(
      path: AppRoutes.newsArticle,
      builder: (context, state) => NewsArticleScreen(
        category: state.uri.queryParameters['category'] ?? '',
        id: state.uri.queryParameters['id'] ?? '',
      ),
    ),
  ],
);
