import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../const/const.dart';
import '../events/order_event.dart';
import '../states/order_state.dart';
import '../models/order.dart';

class OrderScreenBloc extends Bloc<OrderScreenEvent, OrderScreenState> {
  OrderScreenBloc() : super(InitialState());

  @override
  Stream<OrderScreenState> mapEventToState(
    OrderScreenEvent event,
  ) async* {
    if (event is FetchDataEvent) {
      yield* _mapFetchDataToState();
    }
  }

  Stream<OrderScreenState> _mapFetchDataToState() async* {
    yield LoadingState();
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String uid = prefs.getString('user_id').toString();
      String token = prefs.getString('token').toString();
      var uri = Uri.https(Constants.apiUrl, 'api/client/orders');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'text/plain'},
        body: json.encode({
          "uid": uid,
          "token": token,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 200) {
          final List<Order> orders = (data['result'] as List<dynamic>)
              .map<Order>(
                  (item) => Order.fromJson(item as Map<String, dynamic>))
              .toList();
          yield LoadedState(
            orders: orders,
          );
        } else if (data['status'] == 419)
          yield ErrorState("Phiên đang nhập đã hết hạn!", errorsCode: 419);
        else if (data['status'] == 400) yield ErrorState(data['message']);
      } else {
        print('Failed to fetch orders: ${response.statusCode}');
      }
    } catch (error) {
      yield ErrorState(error.toString());
    }
  }
}
