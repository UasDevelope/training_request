import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_request/repositories/transaction.dart';
import 'package:training_request/utils/const/app_color.dart';
import 'package:training_request/utils/const/app_img.dart';
import 'package:training_request/widgets/app_text.dart';

import '../../blocs/transaction/bloc.dart';
import '../../blocs/transaction/event.dart';
import '../../blocs/transaction/state.dart';
import '../../models/transaction.dart';

class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TransactionBloc()..add(LoadTransactions()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,

          title: const AppText(text: 'Transaction History'),
          centerTitle: true,
        ),
        body: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            if (state is TransactionLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TransactionLoaded) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text("Recent", style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 10),
                  ...state.transactions
                      .map((tx) => _TransactionCard(tx))
                      .toList(),
                ],
              );
            } else {
              return const Center(child: Text('Something went wrong.'));
            }
          },
        ),
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final Transaction tx;

  const _TransactionCard(this.tx);

  @override
  Widget build(BuildContext context) {
    bool isCompleted = tx.status == "Completed";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.pastel,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Image.asset(AppImages.tran, height: 40, width: 40),

          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(text: "ID: ${tx.id}", fontWeight: FontWeight.bold),
                AppText(
                  text: "Transaction ID\n${tx.transactionId}",
                  fontSize: 12,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppText(
                text: "\$ ${tx.amount.toStringAsFixed(2)}",

                color: isCompleted ? Colors.green : AppColor.blue,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isCompleted ? Colors.green[100] : Colors.red[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: AppText(
                  text: tx.status,

                  color: isCompleted ? Colors.green : Colors.red,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              AppText(
                text: "${tx.date}  ${tx.time}",
                fontSize: 11,
                color: AppColor.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
