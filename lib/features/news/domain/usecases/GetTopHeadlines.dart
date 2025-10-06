import 'package:clean_architecture/features/news/domain/repository/NewsRepository.dart';
import '../entities/ArticleEntity.dart';

class GetTopHeadlines {
  final NewsRepository repository;
  GetTopHeadlines(this.repository);

  Future<List<ArticleEntity>> call(String country) async {
    return await repository.getTopHeadlines(country);
  }
}
