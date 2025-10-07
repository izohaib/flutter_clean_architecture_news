import 'package:clean_architecture/core/extensions.dart';
import 'package:clean_architecture/features/news/presentation/HomeScreen/Bloc/BlocStates.dart';
import 'package:clean_architecture/features/news/presentation/HomeScreen/Bloc/HomeBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: context.colors.onSurface,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    article.description,
                                    maxLines: 3,
                                    style: TextStyle(
                                      color: context.colors.onSurface,
                                    ),
                                  ),
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
