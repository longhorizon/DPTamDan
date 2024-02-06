import 'package:bloc/bloc.dart';
import '../states/navigation_state.dart';
import '../events/navigation_event.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(TabChangedState(0));

  @override
  Stream<NavigationState> mapEventToState(NavigationEvent event) async* {
    if (event is ChangeTabEvent) {
      yield TabChangedState(event.tabIndex);
    }
  }
}
