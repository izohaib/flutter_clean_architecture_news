import 'package:clean_architecture/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/ArticleEntity.dart';
import '../../domain/usecases/GetTopHeadlines.dart';
import '../HomeScreen/Bloc/BlocEvents.dart';
import '../HomeScreen/Bloc/HomeBloc.dart';

class AppRouter {
  final GetTopHeadlines getTopHeadlines;

  AppRouter(this.getTopHeadlines);

  late final GoRouter router = GoRouter(
    initialLocation: "/news",
    routes: [
      GoRoute(
        path: '/news',
        builder: (context, state) {
          return BlocProvider(
            create: (context) =>
                NewsBloc(getTopHeadlines)..add(FetchNews(country: "pakistan")),
            child: const NewsPage(),
          );
        },
      ),

      GoRoute(
        path: '/article',
        builder: (context, state) {
          final article = state.extra as ArticleEntity;
          return ArticleDetailScreen(article: article);
        },
      ),
    ],
  );
}
