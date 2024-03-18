import 'package:DPTamDan/models/gallery.dart';
import 'package:DPTamDan/models/category.dart';
import 'package:DPTamDan/models/product.dart';
import 'package:DPTamDan/models/user.dart';

abstract class HomeScreenState {
  const HomeScreenState();

  @override
  List<Object> get props => [];
}

class InitialState extends HomeScreenState {}

class LoadingState extends HomeScreenState {}

class DataLoadedState extends HomeScreenState {
  UserProfile user;
  final Gallery galleries;
  final Category categories;
  final List<Product> products;

  DataLoadedState({
    required this.user,
    required this.galleries,
    required this.categories,
    required this.products,
  });

  @override
  List<Object> get props => [user, galleries, categories, products];
}

class SearchState extends HomeScreenState {
  final List<Product> products;
  final String key;

  SearchState({
    required this.products,
    required this.key,
  });

  @override
  List<Object> get props => [products];
}

class ErrorState extends HomeScreenState {
  final String errorMessage;
  final int errorsCode;

  const ErrorState(this.errorMessage, {this.errorsCode = 400});

  @override
  List<Object> get props => [errorMessage];
}
