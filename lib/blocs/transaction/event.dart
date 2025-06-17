import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
@immutable
abstract class TransactionEvent extends Equatable {
  const TransactionEvent();
  List<Object> get props=>[];
}

class LoadTransactions extends TransactionEvent {
  const LoadTransactions();
}
