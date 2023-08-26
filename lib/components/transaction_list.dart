import 'package:expanses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final void Function(String) removeList;

  TransactionList(this.transactions, this.removeList);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (context, constraints) {
              return Column(children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    "Nenhuma Transação Cadastrada",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                SizedBox(height: constraints.maxHeight * 0.04),
                Container(
                  height: constraints.maxHeight * 0.4,
                  child: Image.asset(
                    "assets/images/waiting.png",
                    fit: BoxFit.cover,
                  ),
                )
              ]);
            },
          )
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (ctx, index) {
              final tr = transactions[index];
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 5,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    radius: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: FittedBox(
                          child: Text(
                        'R\$${tr.value}',
                      )),
                    ),
                  ),
                  title: Text(
                    tr.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  subtitle: Text(
                    DateFormat('d MMM y').format(tr.date),
                  ),
                  trailing: MediaQuery.of(context).size.width > 480
                      ? TextButton.icon(
                          onPressed: () {removeList(tr.id);},
                          icon:  Icon(Icons.delete,
                          color: Colors.redAccent),
                          label: Text("Excluir",
                          style: TextStyle(color: Colors.redAccent),
                          ),
                          
                        )
                      : IconButton(
                          onPressed: () {removeList(tr.id);},
                          icon: Icon(Icons.delete,
                          color: Colors.redAccent,)
                        ),
                ),
              );
            });
  }
}
