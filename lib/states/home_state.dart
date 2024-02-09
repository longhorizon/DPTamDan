import 'package:DPTamDan/models/gallery.dart';
import 'package:DPTamDan/models/category.dart';
import 'package:DPTamDan/models/product.dart';
import 'package:equatable/equatable.dart';

abstract class HomeScreenState extends Equatable {
  const HomeScreenState();

  @override
  List<Object> get props => [];
}

class InitialState extends HomeScreenState {}

class LoadingState extends HomeScreenState {}

class DataLoadedState extends HomeScreenState {
  final Gallery galleries;
  final Category categories;
  final List<Product> products;

  const DataLoadedState({
    required this.galleries,
    required this.categories,
    required this.products,
  });

  @override
  List<Object> get props => [galleries, categories, products];
}

class ErrorState extends HomeScreenState {
  final String errorMessage;

  const ErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
