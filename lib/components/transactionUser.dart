import 'package:dispesas/components/transactionForm.dart';
import 'package:dispesas/components/transactionList.dart';
import 'package:dispesas/models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionUser extends StatefulWidget {
  const TransactionUser({super.key});

  @override
  State<TransactionUser> createState() => _TransactionUserState();
}

class _TransactionUserState extends State<TransactionUser> {
  final _transaction = [
    Transaction(
      id: 't1',
      title: 'Novo tenis',
      value: 310.05,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Novo sapato',
      value: 202.5,
      date: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TransactionList(_transaction),
        TransactionForm(),
      ],
    );
  }
}