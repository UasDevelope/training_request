class Transaction {
  final String id;
  final String transactionId;
  final double amount;
  final String date;
  final String time;
  final String status;

  Transaction({
    required this.id,
    required this.transactionId,
    required this.amount,
    required this.date,
    required this.time,
    required this.status,
  });
}

class TransactionResponse {
  final String message;
  List<TransactionModel> transaction;
  TransactionResponse({required this.message, required this.transaction});
  factory TransactionResponse.fromMap(Map<String, dynamic> map) {
    return TransactionResponse(
      message: map['message'] ?? '',
      transaction:
          List<Map<String, dynamic>>.from(
            map["transactions"] ?? [],
          ).map((tx) => TransactionModel.fromMap(tx)).toList(),
    );
  }
}

class TransactionModel {
  final String recordId;
  final String transactionId;
  final double amount;
  final String date;
  final String status;
  TransactionModel({
    required this.recordId,
    required this.transactionId,
    required this.amount,
    required this.date,
    required this.status,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      recordId: map['recordId'] ?? '',
      transactionId: map['transactionId'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      date: map['date'] ?? '',
      status:map["status"]
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'recordId': recordId,
      'transactionId': transactionId,
      'amount': amount,
      'date': date,
      "status":status
    };
  }
}
