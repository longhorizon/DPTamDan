import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../const/const.dart';
import '../events/address_event.dart';
import '../models/address.dart';
import '../states/address_state.dart';

class AddressScreenBloc extends Bloc<AddressScreenEvent, AddressScreenState> {
  AddressScreenBloc() : super(InitialState());

  @override
  Stream<AddressScreenState> mapEventToState(
    AddressScreenEvent event,
  ) async* {
    if (event is FetchDataEvent) {
      yield* _mapFetchDataToState();
    } else if (event is AddAddressEvent) {
      yield* _mapAddToState(event);
    } else if (event is UpdateAddressEvent) {
      yield* _mapUpdateToState(event);
    } else if (event is DeleteAddressEvent) {
      yield* _mapDeleteToState(event);
    }
  }

  Stream<AddressScreenState> _mapFetchDataToState() async* {
    yield LoadingState();
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String uid = prefs.getString('user_id').toString();
      String token = prefs.getString('token').toString();
      var uri = Uri.https(Constants.apiUrl, 'api/client/address');
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
          final List<Address> addresses = (data['result'] as List<dynamic>)
              .map<Address>(
                  (item) => Address.fromJson(item as Map<String, dynamic>))
              .toList();
          yield LoadedState(
            addresses: addresses,
          );
        } else if (data['status'] == 419)
          yield ErrorState("Phiên đang nhập đã hết hạn!", errorsCode: 419);
        else if (data['status'] == 400) yield ErrorState(data['message']);
      } else {
        print('Failed to fetch branchs: ${response.statusCode}');
      }
    } catch (error) {
      yield ErrorState(error.toString());
    }
  }

  Stream<AddressScreenState> _mapAddToState(AddAddressEvent event) async* {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String uid = prefs.getString('user_id').toString();
      String token = prefs.getString('token').toString();
      var uri = Uri.https(Constants.apiUrl, 'api/client/address/add');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'text/plain'},
        body: json.encode({
          "uid": uid,
          "token": token,
          "address": event.address,
          "is_primary": "1"
        }),
      );

      if (response.statusCode == 200) {print(response.body);
      final data = json.decode(response.body);
      if (data['status'] == 200) {
      } else if (data['status'] == 419)
        yield ErrorState("Phiên đang nhập đã hết hạn!", errorsCode: 419);
      else if (data['status'] == 400) yield ErrorState(data['message']);
      } else {
        print('Failed to fetch branchs: ${response.statusCode}');
      }
    } catch (error) {
      yield ErrorState(error.toString());
    }
  }

  Stream<AddressScreenState> _mapUpdateToState(UpdateAddressEvent event) async* {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String uid = prefs.getString('user_id').toString();
      String token = prefs.getString('token').toString();
      var uri = Uri.https(Constants.apiUrl, 'api/client/address/update');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'text/plain'},
        body: json.encode({
          "uid": uid,
          "token": token,
          "address": event.address,
          "id": event.id,
          "is_primary": "1"
        }),
      );

      if (response.statusCode == 200) {print(response.body);
      final data = json.decode(response.body);
      if (data['status'] == 200) {
      } else if (data['status'] == 419)
        yield ErrorState("Phiên đang nhập đã hết hạn!", errorsCode: 419);
      else if (data['status'] == 400) yield ErrorState(data['message']);
      } else {
        print('Failed to fetch branchs: ${response.statusCode}');
      }
    } catch (error) {
      yield ErrorState(error.toString());
    }
  }

  Stream<AddressScreenState> _mapDeleteToState(DeleteAddressEvent event) async* {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String uid = prefs.getString('user_id').toString();
      String token = prefs.getString('token').toString();
      var uri = Uri.https(Constants.apiUrl, 'api/client/address/remove');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'text/plain'},
        body: json.encode({
          "uid": uid,
          "token": token,
          "id": event.id,
        }),
      );

      if (response.statusCode == 200) {print(response.body);
      final data = json.decode(response.body);
      if (data['status'] == 200) {
      } else if (data['status'] == 419)
        yield ErrorState("Phiên đang nhập đã hết hạn!", errorsCode: 419);
      else if (data['status'] == 400) yield ErrorState(data['message']);
      } else {
        print('Failed to fetch branchs: ${response.statusCode}');
      }
    } catch (error) {
      yield ErrorState(error.toString());
    }
  }
}
