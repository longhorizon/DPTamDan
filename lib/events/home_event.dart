abstract class HomeScreenEvent {
  const HomeScreenEvent();

  @override
  List<Object> get props => [];
}

class FetchDataEvent extends HomeScreenEvent {}

class SearchEvent extends HomeScreenEvent {
  final String key;

  SearchEvent(this.key);}

class DataLoadedEvent extends HomeScreenEvent {}

class LoadingEvent extends HomeScreenEvent {}
