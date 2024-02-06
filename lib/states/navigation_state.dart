abstract class NavigationState {}

class TabChangedState extends NavigationState {
  final int tabIndex;

  TabChangedState(this.tabIndex);
}