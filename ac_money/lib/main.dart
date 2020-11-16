import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/cardResult.dart';

String currency = 'USD-BRL';
String day = '-1';
String maiorValor = '';
String menorValor = '';

void main() {
  runApp(MaterialApp(
    home: MonetaryMonitoring(),
  ));
}

class MonetaryMonitoring extends StatefulWidget {
  @override
  _MonetaryMonitoringState createState() => _MonetaryMonitoringState();
}

class _MonetaryMonitoringState extends State<MonetaryMonitoring> {
  List<CardResult> list = [];

  var jsonResponseR;
  readCardAndChange() {
    getData(currency, day).then((response) {
      setState(() {
        Iterable jsonResponseR = convert.jsonDecode(response.body);
        list =
            jsonResponseR.map((model) => CardResult.fromJson(model)).toList();
      });
    });
  }

  initState() {
    super.initState();
    readCardAndChange();
  }

  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent[400],
          title: Text('Acompanhamento Monetário'),
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    width: 400,
                    child: Text(
                      'Informe a moeda',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 300, top: 10),
                    width: 100,
                    child: DropDownMoney(),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Column(
                children: [
                  Container(
                    width: 400,
                    child: Text(
                      'Informe o número de dias',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 330, top: 10),
                    width: 50,
                    child: DropDownDay(),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10, top: 10),
              height: 45,
              child: RaisedButton(
                color: Colors.deepPurpleAccent[400],
                onPressed: () {
                  setState(() {
                    readCardAndChange();
                  });
                },
                child: const Text('Consulta',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
            ),
            Expanded(
              child: Container(
                  child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  var newDate = list[0].createDate.substring(0, 10);
                  String dataCorrigida = corretorDeData(newDate, index);

                  return Card(
                    color: Colors.white70,
                    child: Column(
                      children: [
                        Container(
                          color: Colors.deepPurple[200],
                          width: double.infinity,
                          padding:
                              EdgeInsets.only(top: 10, bottom: 10, left: 15),
                          child: Text(
                            'Data: $dataCorrigida',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10, bottom: 4),
                          margin: EdgeInsets.only(right: 160),
                          child: Text(
                            'Menor valor: ${list[index].maxValue}',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 4, bottom: 15),
                          margin: EdgeInsets.only(right: 160),
                          child: Text(
                            'Menor valor: ${list[index].minValue}',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )),
            ),
          ],
        ),
      ),
    );
  }
}

class DropDownDay extends StatefulWidget {
  @override
  _DropDownDayState createState() => _DropDownDayState();
}

class _DropDownDayState extends State<DropDownDay> {
  String dropdownValue = '1';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        width: 500,
        height: 2,
        color: Colors.deepPurpleAccent[400],
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
          day = dropdownValue.toString();
        });
      },
      items: <String>['1', '2', '3', '4', '5', '6', '7', '8', '9', '10']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class DropDownMoney extends StatefulWidget {
  @override
  _DropDownMoneyState createState() => _DropDownMoneyState();
}

class _DropDownMoneyState extends State<DropDownMoney> {
  String dropdownValue = 'USD-BRL';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        width: 500,
        height: 2,
        color: Colors.deepPurpleAccent[400],
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
          currency = dropdownValue.toString();
        });
      },
      items: <String>['USD-BRL', 'EUR-BRL', 'BTC-BRL']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

Future<http.Response> getData(currency, day) async {
  if (day != '-1') {
    var url = 'https://economia.awesomeapi.com.br/json/daily/$currency/$day';
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Ocorreu um erro');
    }
  }
}

String corretorDeData(String data, int index) {
  int newData = int.parse(data[8] + data[9]);
  int result = newData - index;

  if (result < 0) {
    result = result + 30;
  }
  String newFormat;

  if (result < 10) {
    newFormat = '0' + result.toString();
  } else {
    newFormat = result.toString();
  }

  String dataCorrigida = newFormat +
      data[7] +
      data[6] +
      data[5] +
      data[4] +
      data[0] +
      data[1] +
      data[2] +
      data[3];

  return dataCorrigida;
}
