import 'package:equatable/equatable.dart';

abstract class HomeScreenEvent extends Equatable {
  const HomeScreenEvent();

  @override
  List<Object> get props => [];
}

class FetchDataEvent extends HomeScreenEvent {}

class DataLoadedEvent extends HomeScreenEvent {}

class LoadingEvent extends HomeScreenEvent {}
