import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  final void Function (String, double, DateTime) onSubmit;

  TransactionForm(this.onSubmit);

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _valueControler = TextEditingController();
  final _titleControler = TextEditingController();
  DateTime _dateSelected = DateTime.now();


  _submitForm(){
    final title = _titleControler.text;
    final value = double.tryParse(_valueControler.text) ?? 0.0; 
    if (title.isEmpty || value <= 0){
      return;
    }
    widget.onSubmit(title, value, _dateSelected);
  }

  _showDatePicker(){
    showDatePicker(
      context: context, 
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate ) {
      if (pickedDate == null){
        return;
      }
      setState(() {
        _dateSelected = pickedDate;
      });
    });
      
    
  }

  @override
  Widget build(BuildContext context) {
    print(_dateSelected);
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(
            top: 10,
            right: 10,
            left : 10,
            bottom: 10 * MediaQuery.of(context).viewInsets.bottom
          ),
          child: Column(
            children: [
              TextField(
                controller: _titleControler,
                onSubmitted: (_) => _submitForm(),
                decoration: InputDecoration(labelText: 'Titulo'),
              ),
              TextField(
                controller: _valueControler,
                onSubmitted: (_) => _submitForm(),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Valor (R\$)',
                ),
              ),
              Container(
                height: 70,
                child: FittedBox(
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Text("Data Selecionada:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${DateFormat("dd/MM/y").format(_dateSelected)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                            ],
                      ),
                      TextButton(
                        child: Text(
                          "Selecionar Data",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        onPressed: _showDatePicker, 
                      )
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    child: Text("Nova Transação"),
                    onPressed:_submitForm,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
