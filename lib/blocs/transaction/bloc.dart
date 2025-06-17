import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_request/blocs/transaction/state.dart';

import '../../models/transaction.dart';
import 'event.dart';


class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionLoading()) {
    on<LoadTransactions>((event, emit) async {
      await Future.delayed(const Duration(seconds: 1)); // simulate delay

      emit(TransactionLoaded([
        Transaction(
          id: "BK10234",
          transactionId: "698094554317",
          amount: 50.0,
          date: "17 Sep 2023",
          time: "11:21 AM",
          status: "Pending",
        ),
        Transaction(
          id: "BK10234",
          transactionId: "698094554317",
          amount: 50.0,
          date: "17 Sep 2023",
          time: "11:21 AM",
          status: "Completed",
        ),
      ]));
    });
  }
}
