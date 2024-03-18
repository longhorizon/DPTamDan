import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:DPTamDan/models/gallery.dart';
import 'package:DPTamDan/models/category.dart';
import 'package:DPTamDan/models/product.dart';

import '../events/home_event.dart';
import '../models/user.dart';
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
    }else if (event is SearchEvent) {
      yield* _mapSearchToState(event);
    }
  }

  Stream<HomeScreenState> _mapFetchDataToState() async* {
    yield LoadingState();
    try {
      final dataRaw = await apiService.fetchUserInfo();
      final userData = json.decode(dataRaw);
      if(userData['status'] == 419)
        {
          yield ErrorState("Phiên đang nhập đã hết hạn!", errorsCode: 419);
        }
      if(userData['status'] == 400)
        {
          yield ErrorState(userData['message']);
        }
      final userResponseData =  userData['result'];
      UserProfile userInfo = UserProfile.fromJson(userResponseData);
      final responseData = await apiService.fetchData();
      final Gallery galleries = Gallery.fromJson(responseData[0]);
      final Category categories = Category.fromJson(responseData[1]);
      final List<Product> products = (responseData[2]['data'] as List<dynamic>)
          .map<Product>(
              (item) => Product.fromJson(item as Map<String, dynamic>))
          .toList();
      yield DataLoadedState(
        user: userInfo,
        galleries: galleries,
        categories: categories,
        products: products,
      );
    } catch (error) {
      yield ErrorState(error.toString());
    }
  }

  Stream<HomeScreenState> _mapSearchToState(SearchEvent event) async* {
    try {
      final responseData = await apiService.search(event.key);
      final List<Product> products = (responseData as List<dynamic>)
          .map<Product>(
              (item) => Product.fromJson(item as Map<String, dynamic>))
          .toList();
      yield SearchState(
        products: products,
        key: event.key,
      );
    } catch (error) {
      yield ErrorState(error.toString());
    }
  }
}
