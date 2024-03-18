
abstract class AddressScreenEvent  {
  const AddressScreenEvent();

  @override
  List<Object> get props => [];
}

class FetchDataEvent extends AddressScreenEvent {}

class AddAddressEvent extends AddressScreenEvent {
  String address;
  AddAddressEvent({required this.address});
}

class UpdateAddressEvent extends AddressScreenEvent {
  String id;
  String address;
  UpdateAddressEvent({ required this.id, required this.address});
}

class DeleteAddressEvent extends AddressScreenEvent {
  String id;
  DeleteAddressEvent({ required this.id});
}
