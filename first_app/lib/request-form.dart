import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './validator.dart';

class Record {
  String _name = '';
  int _rows = 0;
  Status _status = Status.success;
  Record(String name, int rows, Status status) {
    this._name = name;
    this._rows = rows;
    this._status = status;
  }
  String get record {
    return this._name +
        " " +
        this._rows.toString() +
        " " +
        this._status.toString();
  }

  IconData getIcon() {
    switch (this._status) {
      case Status.error:
        {
          return Icons.error;
        }
      case Status.success:
        {
          return Icons.check;
        }
      case Status.warning:
        {
          return Icons.warning;
        }
    }
  }
}

enum Status {
  error('Ошибка'),
  success('Успех'),
  warning('Предупреждение');

  const Status(this.desc);
  final String desc;

  get text => name;
  get enable => true;

  @override
  String toString() {
    return desc;
  }
}

class MyFormPage extends StatefulWidget {
  @override
  State<MyFormPage> createState() => _MyFormPageState();
}

class _MyFormPageState extends State<MyFormPage> {
  final _formGlobalKey = GlobalKey<FormState>();
  Status status = Status.success;
  String _title = '';
  int _affectedRows = 0;
  List<Record> records = [];
  IconData icon = Icons.delete_forever;
  void deleteRecord(Record record) {
    setState(() {
      records.remove(record);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Widget page;

    return Center(
        child: Column(children: [
      Form(
          key: _formGlobalKey,
          child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      maxLength: 20,
                      decoration: const InputDecoration(
                        label: Text('Тип записи'),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => Validator.maxLength(v, 20),
                      onSaved: (value) {
                        _title = value!;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text('Количество затронутых рядков'),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => Validator.minValue(v, 0),
                      onSaved: (value) {
                        _affectedRows = int.tryParse('${value!}')!;
                      },
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField(
                        value: Status.success,
                        decoration: const InputDecoration(
                            label: Text('Статус'),
                            border: OutlineInputBorder()),
                        items: Status.values.map((p) {
                          return DropdownMenuItem(
                            value: p,
                            child: Text(p.desc),
                          );
                        }).toList(),
                        onChanged: (value) {
                          status = value!;
                        }),
                    SizedBox(height: 20),
                    FilledButton(
                      onPressed: () {
                        if (_formGlobalKey.currentState!.validate()) {
                          _formGlobalKey.currentState!.save();
                          setState(() {
                            records
                                .add(new Record(_title, _affectedRows, status));
                          });
                          _formGlobalKey.currentState!.reset();
                        }
                      },
                      child: const Text('Добавить'),
                      style: FilledButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                    ),
                  ]))),
      SizedBox(height: 40),
      Container(
        height: 300,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            for (var i = 0; i < records.length; i++)
              ListTile(
                leading: ElevatedButton.icon(
                  onPressed: () {
                    deleteRecord(records[i]);
                  },
                  icon: Icon(icon),
                  label: Text('Удалить'),
                ),
                title: Text(records[i].record),
              )
          ],
        ),
      )
    ]));
  }
}
