import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:training_request/api/api_constants.dart';
import 'package:training_request/blocs/order/state.dart';
import 'package:training_request/repositories/order_repo.dart';
import 'event.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository orderRepository;

  OrderBloc({required this.orderRepository}) : super(OrderInitalStat()) {
    on<OrderLoadEvent>((event, emit) async {
      emit(OrderLoadingStat());
      try {
        var response = await orderRepository.fetchBookings(event.endPoint);
        emit(OrderLoadedStat(orderModel: response));
      } catch (e) {
        emit(OrderErrorStat(message: e.toString()));
        log("Error$e");
      }
    });
    on<FetchLocationDetailsEvent>(onFetchLocationDetails);
    on<AcceptRejectProposal>(acceptRejectProposal);
  }

  void onFetchLocationDetails(
    FetchLocationDetailsEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(LocationLoadingState());
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        event.latitude,
        event.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final city = place.locality ?? '';
        final country = place.country ?? '';
        final address = [
          place.name,
          place.subLocality,
          place.locality,
          place.administrativeArea,
          place.country,
        ].where((e) => e != null && e.isNotEmpty).join(', ');

        emit(LocationLoaded(city: city, country: country, address: address));
      } else {
        emit(LocationError("Location not found"));
      }
    } catch (e) {
      emit(LocationError("Error: ${e.toString()}"));
    }
  }

  void acceptRejectProposal(
    AcceptRejectProposal event,
    Emitter<OrderState> emit,
  ) async {
    emit(ProposalLoadingStat());
    try {
      var response = await orderRepository.proposalAcceptReject(
        "${ApiConstants.BASEURL}/bookings/proposals/${event.proposalId}/${event.purpose}",
      );
      emit(ProposalLoadedStat("Successfully ${event.purpose}"));
    } catch (e) {
      emit(OrderErrorStat(message: e.toString()));
      log("Error$e");
    }
  }
}
