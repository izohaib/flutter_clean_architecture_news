import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/GetTopHeadlines.dart';
import 'BlocEvents.dart';
import 'BlocStates.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetTopHeadlines getTopHeadlines;

  NewsBloc(this.getTopHeadlines) : super(NewsInitial()) {
    on<FetchNews>((event, emit) async {
      emit(NewsLoading());

      try {
        final articles = await getTopHeadlines(event.country);
        emit(NewsLoaded(articles));
      } catch (e) {
        emit(NewsError(e.toString()));
      }
    });
  }
}
