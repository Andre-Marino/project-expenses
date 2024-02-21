import 'package:dispesas/components/transactionForm.dart';
import 'package:dispesas/components/transactionList.dart';
import 'package:dispesas/models/transaction.dart';
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(ExpensesApp());
}

class ExpensesApp extends StatelessWidget {
  const ExpensesApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData tema = ThemeData();
    return MaterialApp(
      home: MyHomePage(),
      theme: tema.copyWith(
        colorScheme: tema.colorScheme.copyWith(
          primary: Colors.yellow,
          secondary: Colors.orange,
        ),
        textTheme: tema.textTheme.copyWith(
          titleLarge: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

  _addTransaction(String title, double value) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: DateTime.now(),
    );

    setState(() {
      _transaction.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TransactionForm(_addTransaction);
        });
  }

  //-------------------------------------- TELA INICIAL ---------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: CustomAppBar(_openTransactionFormModal),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: double.infinity,
              child: Card(
                child: Text('Gráfico'),
              ),
            ),
            TransactionList(_transaction),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _openTransactionFormModal(context),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

//-------------------------------------- CUSTM APP_BAR ---------------------------------

class CustomAppBar extends StatelessWidget {
  final void Function(BuildContext) _openModal;

  CustomAppBar(this._openModal);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary, // Cor de fundo do AppBar
        borderRadius: BorderRadius.only(
          bottomLeft:
              Radius.circular(20.0), // Arredonda o canto inferior esquerdo
          bottomRight:
              Radius.circular(20.0), // Arredonda o canto inferior direito
        ),
      ),
      child: AppBar(
        centerTitle: true,
        elevation: 0, // Remove a sombra do AppBar
        backgroundColor:
            Colors.transparent, // Torna o fundo do AppBar transparente
        title: Text('Despesas Pessoais'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _openModal(context),
          )
        ],
      ),
    );
  }
}
