import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();
  @override
  List<Object> get props => [];
}


class OrderLoadEvent extends OrderEvent {
  final String endPoint;
  const OrderLoadEvent({required this.endPoint});
  @override
  List<Object> get props => [endPoint];
}
class FetchLocationDetailsEvent extends OrderEvent {
  final double latitude;
  final double longitude;

  const FetchLocationDetailsEvent({required this.latitude, required this.longitude});
}

class AcceptRejectProposal extends OrderEvent{
  String proposalId;
  String purpose;
  double? price; // Add price for payment processing
  AcceptRejectProposal({required this.proposalId,required this.purpose, this.price});
  @override
  List<Object> get props => [proposalId,purpose, price ?? 0.0];
}
