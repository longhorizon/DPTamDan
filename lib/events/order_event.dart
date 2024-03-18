abstract class OrderScreenEvent {
  const OrderScreenEvent();

  @override
  List<Object> get props => [];
}

class FetchDataEvent extends OrderScreenEvent {
  int type;
  int page;
  FetchDataEvent({this.type = -1, this.page = 0});
}
