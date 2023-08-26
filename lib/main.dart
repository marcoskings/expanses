// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors

import 'dart:io';
import 'dart:math';
import 'package:expanses/components/chart.dart';
import 'package:expanses/components/transaction_form.dart';
import 'package:flutter/material.dart';
import 'models/transaction.dart';
import 'components/transaction_list.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(ExpansesApp());

class ExpansesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [const Locale('pt', 'BR')],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.purple, accentColor: Colors.amber),
        fontFamily: 'Quicksand',
        appBarTheme: ThemeData.light().appBarTheme.copyWith(
              titleTextStyle: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
        textTheme: ThemeData.light().textTheme.copyWith(
            titleLarge: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: TextStyle(fontWeight: FontWeight.bold),
            backgroundColor: Colors.purple, // background (button) color
            foregroundColor: Colors.white, // foreground (text) color
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [];
  bool _showChart = false;
  //Função get que filtra somente as transações dos últimos 7 dias
  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
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
        date: date);

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return TransactionForm(_addTransaction);
        });
  }

  _removeLista(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    bool isLandscape = mediaQuery.orientation == Orientation.landscape;
    final appBar = AppBar(
      title: const Text("Despesas Pessoais"),
      centerTitle: true,
      actions: [
        if (isLandscape) IconButton(
            icon: Icon(_showChart ? Icons.list : Icons.show_chart),
            onPressed: () => {
              setState((){
                _showChart = !_showChart;
            }) 
            }
          ),
          
        IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _openTransactionFormModal(context)),
      ],
    );
    final avalableheight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // if(isLandscape)Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text("Exibir Gráfico"),
            //   Switch(
            //     value: _showChart,
            //     onChanged: (value) {
            //       setState(() {
            //         _showChart = value;
            //       });
            //     },
            //   )
            // ]),
            if(_showChart || !isLandscape)
              Container(
              height: avalableheight * (isLandscape ? 0.7 : 0.34),
              child: Chart(_recentTransactions),
            ),
          
            if (!_showChart || !isLandscape)Container(
              height: avalableheight * (isLandscape ? 1 : 0.7),
              child: TransactionList(_transactions, _removeLista),
            ),
          ],
        ),
      ),
      floatingActionButton: Platform.isIOS ? 
      Container()
      :FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.black,
          ),
          onPressed: () => _openTransactionFormModal(context)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
