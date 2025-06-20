import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_request/blocs/transaction/state.dart';
import 'package:training_request/repositories/transaction.dart';

import '../../models/transaction.dart';
import 'event.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TranSactionRepository tranSactionRepository;

  TransactionBloc({required this.tranSactionRepository})
    : super(TransactionLoading()) {
    on<LoadTransactions>((event, emit) async {
      final  response =
          await tranSactionRepository.FetchHistory(); // ✅ Await response
      emit(
        TransactionLoaded(response.transaction),
      );
    });
  }
}
