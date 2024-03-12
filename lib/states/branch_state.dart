import 'package:DPTamDan/models/product.dart';
// import 'package:equatable/equatable.dart';

import '../models/branch.dart';

abstract class BranchScreenState {
  const BranchScreenState();

  @override
  List<Object> get props => [];
}

class InitialState extends BranchScreenState {}

class LoadingState extends BranchScreenState {}

class LoadedState extends BranchScreenState {
  final List<Branch> branchs;

  LoadedState({
    required this.branchs,
  });

  @override
  List<Object> get props => [branchs];
}

class SearchState extends BranchScreenState {
  final List<Product> products;

  SearchState({
    required this.products,
  });

  @override
  List<Object> get props => [products];
}

class ErrorState extends BranchScreenState {
  final String errorMessage;
  final int errorsCode;

  const ErrorState(this.errorMessage, {this.errorsCode = 400});

  @override
  List<Object> get props => [errorMessage];
}
