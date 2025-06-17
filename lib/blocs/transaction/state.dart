import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../models/transaction.dart';

@immutable
abstract class TransactionState extends Equatable {
  const TransactionState();
  List<Object> get props => [];
}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<Transaction> transactions;

  TransactionLoaded(this.transactions);
}
