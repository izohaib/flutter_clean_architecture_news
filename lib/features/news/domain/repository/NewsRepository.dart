import 'package:clean_architecture/features/news/domain/entities/ArticleEntity.dart';

abstract class NewsRepository {
  Future<List<ArticleEntity>> getTopHeadlines(String country);
}
