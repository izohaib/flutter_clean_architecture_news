import 'package:clean_architecture/features/news/data/NewsDataSource/NewsRemoteDataSource.dart';
import 'package:clean_architecture/features/news/domain/entities/ArticleEntity.dart';
import 'package:clean_architecture/features/news/presentation/HomeScreen/Bloc/BlocStates.dart';
import 'package:clean_architecture/features/news/presentation/HomeScreen/Bloc/HomeBloc.dart';
import 'package:clean_architecture/features/news/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
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
    );
  }
}

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Top Headlines")),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NewsLoaded) {
            return ListView.builder(
              itemCount: state.articles.length,
              itemBuilder: (context, index) {
                final article = state.articles[index];
                return InkWell(
                  onTap: () {
                    context.push('/article', extra: article);
                  },
                  child: Card(
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                article.urlToImage,
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width * 0.3,
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    article.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 8),
                                  Text(article.description, maxLines: 3),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is NewsError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return const Center(child: Text("No news loaded"));
        },
      ),
    );
  }
}

class ArticleDetailScreen extends StatelessWidget {
  final ArticleEntity article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                article.urlToImage,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.6,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    article.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 8),

                  Text(
                    article.content,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        print("url is here: ${article.url}");
                        try {
                          final url = Uri.parse(article.url!.trim());
                          // Don't use canLaunchUrl - just try to launch directly
                          await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          );
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Could not launch article: $e'),
                              ),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.open_in_new),
                      label: const Text("Read Full Article"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
