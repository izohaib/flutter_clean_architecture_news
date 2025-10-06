import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../model/news_model.dart';

abstract class NewsRemoteDataSource {
  Future<NewsModel> getTopHeadlines({String country});
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  Dio dio;

  NewsRemoteDataSourceImpl(this.dio); //

  @override
  Future<NewsModel> getTopHeadlines({String country = "pakistan"}) async {
    final response = await dio.get(ApiConstants.HeadlineUrl(country));
    return NewsModel.fromJson(response.data);
  }
}
