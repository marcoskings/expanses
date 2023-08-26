import 'package:expanses/components/chart_bar.dart';
import 'package:expanses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransaction;
  const Chart(this.recentTransaction);
  
  List<Map<String,Object>> get groupedTransactions{
    return List.generate( 7 , (index){
      //Gera a data de comparação
      final weekDay = DateTime.now().subtract(
        Duration(days : index)
      );
      //Compara a data da lista com a weekday armazenando verdadeiro ou falso
      double totalSum = 0.0;
      for (var i = 0; i < recentTransaction.length; i++) {
        bool sameDay = recentTransaction[i].date.day == weekDay.day;
        bool sameMonth = recentTransaction[i].date.month == weekDay.month;
        bool sameYear = recentTransaction[i].date.year == weekDay.year;
        //Se todas afirmação for verdadeira adicionar o valor a somaTotal
        if (sameDay && sameMonth && sameYear){
          totalSum += recentTransaction[i].value;
        }
      }
    

      //Retorna uma map com a letra do dia formatada e a somaTotal 
      return {
      'day': DateFormat(DateFormat.WEEKDAY, 'pt_BR').format(weekDay)[0].toUpperCase(),
      'value':totalSum,
      };
    }).reversed.toList(); 
  }
  //Calcular o valor total da semana
  double get _weekTotalValue {
    return groupedTransactions.fold(0.0, (sum, tr) => sum + (tr['value'] as double));
  }

  @override
  Widget build(BuildContext context) {
    groupedTransactions;
    return  Card(
      elevation: 5,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactions.map((tr) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                label: tr['day'].toString(),
                value: tr['value'] as double,
                percentage: (tr['value'] as double) / _weekTotalValue,
                ),
            );
          }).toList(),
        ),
      ),
    );
  }
}