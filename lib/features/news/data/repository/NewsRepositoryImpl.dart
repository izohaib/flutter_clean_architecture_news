import 'package:clean_architecture/features/news/domain/entities/ArticleEntity.dart';
import 'package:clean_architecture/features/news/domain/repository/NewsRepository.dart';

import '../NewsDataSource/NewsRemoteDataSource.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;

  NewsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ArticleEntity>> getTopHeadlines(String country) async {
    final response = await remoteDataSource.getTopHeadlines(country: country);

    // Convert the list of Articles to a list of ArticleEntity
    return response.articles!.map((article) => article.toEntity()).toList() ??
        [];
  }
}
