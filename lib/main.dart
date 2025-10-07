import 'package:clean_architecture/features/news/data/NewsDataSource/NewsRemoteDataSource.dart';
import 'package:clean_architecture/features/news/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/news/data/repository/NewsRepositoryImpl.dart';
import 'features/news/domain/usecases/GetTopHeadlines.dart';
import 'features/news/presentation/router/AppRouter.dart';
import 'package:dio/dio.dart';

void main() {
  final remoteDataSource = NewsRemoteDataSourceImpl(Dio());
  final repository = NewsRepositoryImpl(remoteDataSource);
  final getTopHeadlines = GetTopHeadlines(repository);

  final appRouter = AppRouter(getTopHeadlines);

  runApp(MyApp(router: appRouter.router));
}

class MyApp extends StatelessWidget {
  final GoRouter router;

  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      routerConfig: router,
      theme: lightTheme,
      darkTheme: darkTheme,
    );
  }
}
