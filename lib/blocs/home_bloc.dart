import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:DPTamDan/models/gallery.dart';
import 'package:DPTamDan/models/category.dart';
import 'package:DPTamDan/models/product.dart';

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
      final responseData = await apiService.fetchData();
      final Gallery galleries = Gallery.fromJson(responseData[0]);
      final Category categories = Category.fromJson(responseData[1]);
      final List<Product> products = (responseData[2]['data'] as List<dynamic>)
          .map<Product>(
              (item) => Product.fromJson(item as Map<String, dynamic>))
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
