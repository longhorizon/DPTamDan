import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:DPTamDan/models/gallery.dart';
import 'package:DPTamDan/models/category.dart';
import 'package:DPTamDan/models/product.dart';
import 'package:meta/meta.dart';

import '../events/home_event.dart';
import '../services/api_service.dart';
import '../states/home_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  final APIService apiService;

  HomeScreenBloc({required this.apiService}) : super(InitialState());

  @override
  Stream<HomeScreenState> mapEventToState(
    HomeScreenEvent event,
  ) async* {
    if (event is FetchDataEvent) {
      yield* _mapFetchDataToState();
    }
  }

  Stream<HomeScreenState> _mapFetchDataToState() async* {
    yield LoadingState();
    try {
      final responseData = await apiService.fetchData();print(responseData);
      final List<Gallery> galleries = (responseData['galleries'] as List)
          .map((item) => Gallery.fromJson(item))
          .toList();
      final List<Category> categories = (responseData['categories'] as List)
          .map((item) => Category.fromJson(item))
          .toList();
      final List<Product> products = (responseData['products'] as List)
          .map((item) => Product.fromJson(item))
          .toList();
      yield DataLoadedState(
        galleries: galleries,
        categories: categories,
        products: products,
      );
    } catch (error) {
      yield ErrorState(error.toString());
    }
  }
}

