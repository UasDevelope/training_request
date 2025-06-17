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
