import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import '../functions/api.dart';

import '../config.dart' as config;

import '../widgets/slideLeftBackground.widget.dart';

class WeightList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WeightListState();
  }
}

class _WeightListState extends State<WeightList> {
  List<dynamic> _weights = [];
  Api api = new Api(config.apiKey);

  void fetchWeight() async {
    var weights = await api.fetchWeight();
    setState(() {
      _weights = weights;
      if (_weights.length == 0) {
        _weights.add("empty");
      }
    });
  }

  void insertWeight(weight) async {
    var result = await api.insertWeight(weight);
    if (result["success"] == true) {
      _getData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gewicht konnte nicht hinzugefügt werden.')));
    }
  }

  void deleteWeight(String weight) async {
    var result = await api.deleteWeight(weight);
    if (result["success"] == true) {
      _getData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gewicht konnte nicht gelöscht werden.')));
    }
  }

  int _id(dynamic weight) {
    return weight['id'];
  }

  String _date(dynamic weight) {
    List<String> dateList = weight['date'].split("T");
    dateList = dateList[0].split("-");
    return dateList[2] + "." + dateList[1] + "." + dateList[0];
  }

  String _weight(Map<dynamic, dynamic> weight) {
    return weight['weight'].toString() + " Gramm";
  }

  Widget checkIfEmpty() {
    return _weights[0] == "empty"
        ? RefreshIndicator(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Noch keine Einträge vorhanden"),
                  MaterialButton(
                    onPressed: _getData,
                    child: Text("Aktualisieren"),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                  )
                ],
              ),
            ),
            onRefresh: _getData)
        : ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: _weights.length,
            itemBuilder: (BuildContext context, int index) {
              return index == 0
                  ? Dismissible(
                      key: Key(_id(_weights[index]).toString()),
                      onDismissed: (d) {
                        deleteWeight(_id(_weights[index]).toString());
                      },
                      background: slideLeftBackground(),
                      direction: DismissDirection.endToStart,
                      child: Container(
                        height: 400,
                        width: double.infinity,
                        child: InkWell(
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(_weight(_weights[index]),
                                    style: TextStyle(
                                      fontSize: 28.0,
                                      color: Colors.lightBlue,
                                    )),
                                Text(_date(_weights[index]),
                                    style: TextStyle(
                                        fontSize: 14.0, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ),
                      ))
                  : Dismissible(
                      onDismissed: (d) {
                        deleteWeight(_id(_weights[index]).toString());
                      },
                      key: Key(_id(_weights[index]).toString()),
                      background: slideLeftBackground(),
                      direction: DismissDirection.endToStart,
                      child: InkWell(
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                title: Text(_weight(_weights[index])),
                                subtitle: Text(_date(_weights[index])),
                              )
                            ],
                          ),
                        ),
                      ));
            });
  }

  Widget _buildList() {
    return _weights.length != 0
        ? RefreshIndicator(
            child: checkIfEmpty(),
            onRefresh: _getData,
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  Future<void> _getData() async {
    setState(() {
      fetchWeight();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchWeight();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Gewichtslog')),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(15),
              bottomLeft: Radius.circular(15)),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15)),
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Theme.of(context).primaryColor,
                    Theme.of(context).accentColor
                  ])),
        ),
      ),
      body: Container(
        child: _buildList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => _buildAddWeightDialog(context),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildAddWeightDialog(BuildContext context) {
    int _currentWeightValue = 10;
    int _finalWeightValue = 10;

    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: const Text('Eintrag hinzufügen'),
        content: NumberPicker(
          value: _currentWeightValue,
          minValue: 10,
          maxValue: 100,
          step: 1,
          itemHeight: 50,
          haptics: true,
          onChanged: (value) => setState(() => _currentWeightValue = value),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black26),
          ),
        ),
        actions: <Widget>[
          new TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Abbrechen'),
          ),
          new TextButton(
            onPressed: () {
              setState(() {
                _finalWeightValue = _currentWeightValue;
              });
              print(_finalWeightValue);
              insertWeight(_finalWeightValue.toString());
              Navigator.of(context).pop();
            },
            child: const Text('Speichern'),
          ),
        ],
      );
    });
  }
}
