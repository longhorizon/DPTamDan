import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../const/const.dart';
import '../events/branch_event.dart';
import '../models/branch.dart';
import '../states/branch_state.dart';

class BranchScreenBloc extends Bloc<BranchScreenEvent, BranchScreenState> {
  BranchScreenBloc() : super(InitialState());

  @override
  Stream<BranchScreenState> mapEventToState(
    BranchScreenEvent event,
  ) async* {
    if (event is FetchDataEvent) {
      yield* _mapFetchDataToState();
    }
  }

  Stream<BranchScreenState> _mapFetchDataToState() async* {
    yield LoadingState();
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String uid = prefs.getString('user_id').toString();
      String token = prefs.getString('token').toString();
      var uri = Uri.https(Constants.apiUrl, 'api/client/branch');
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
          final List<Branch> branchs = (data['result'] as List<dynamic>)
              .map<Branch>(
                  (item) => Branch.fromJson(item as Map<String, dynamic>))
              .toList();
          yield LoadedState(
            branchs: branchs,
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
}
