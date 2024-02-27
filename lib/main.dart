import 'package:dispesas/components/chart.dart';
import 'package:dispesas/components/transactionForm.dart';
import 'package:dispesas/components/transactionList.dart';
import 'package:dispesas/models/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:io';

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
  final List<Transaction> _transaction = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _transaction.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transaction.add(newTransaction);
    });

    Navigator.of(context).pop();
    print(_transaction.length);
  }

  _removeTransaction(String id) {
    setState(() {
      _transaction.removeWhere((tr) => tr.id == id);
    });
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) {
          return TransactionForm(_addTransaction);
        });
  }

  //-------------------------------------- TELA INICIAL ---------------------------------

  @override
  Widget build(BuildContext context) {
    void _toggleChart(bool value) {
      setState(() {
        _showChart = value;
      });
    }

    final mediaQuery = MediaQuery.of(context);

    bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    final appBar = PreferredSize(
      preferredSize: Size.fromHeight(80.0),
      child: CustomAppBar(_openTransactionFormModal, _showChart, _toggleChart),
    );

    final availabeHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    final boryPage = SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /*if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Exibir Gráfico'),
                  Switch(
                    value: _showChart,
                    onChanged: (value) {
                      setState(() {
                        _showChart = value;
                      });
                    },
                  ),
                ],
              ),*/
          if (_showChart || !isLandscape)
            Container(
              height: availabeHeight * (isLandscape ? 0.8 : 0.3),
              child: Chart(_recentTransactions),
            ),
          if (!_showChart || !isLandscape)
            Container(
              height: availabeHeight * (isLandscape ? 1 : 0.75),
              child: TransactionList(_transaction, _removeTransaction),
            ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar,
      body: boryPage,
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => _openTransactionFormModal(context),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

//-------------------------------------- CUSTM APP_BAR ---------------------------------

class CustomAppBar extends StatefulWidget {
  final void Function(BuildContext) _openModal;
  final void Function(bool) _toggleChart;
  bool showChart;

  CustomAppBar(this._openModal, this.showChart, this._toggleChart);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
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
          if (isLandscape)
            IconButton(
              icon: Icon(widget.showChart ? Icons.list : Icons.show_chart),
              onPressed: () {
                setState(() {
                  widget.showChart = !widget.showChart;
                });
                widget._toggleChart(widget.showChart);
              },
            ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => widget._openModal(context),
          ),
        ],
      ),
    );
  }
}
