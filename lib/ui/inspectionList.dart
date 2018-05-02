import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../Helper/Route.dart';
import '../Models/Inspection.dart';

class InspectionRecord extends StatefulWidget {
  @override
  _InspectionRecordState createState() => new _InspectionRecordState();
}

class _InspectionRecordState extends State<InspectionRecord> {
  void _addNew() {
    Navigator.of(context).pop();
    Navigator.of(context).push(
          new AnimatedRoute(
            builder: (_) => new InspectionForm(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("inspectionList"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: new InspectionList(),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        backgroundColor: Colors.red,
        onPressed: _addNew,
      ),
    );
  }
}

class InspectionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: Firestore.instance.collection('Inspection').snapshots,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return new Text("Loading....");
          }
          if (snapshot.data.documents.length == 0) {
            return new Text("No Data");
          }

          return new ListView(
            children: snapshot.data.documents.map((document) {
              return new ListTile(
                title: new Text(
                  document.documentID,
                ),
                subtitle: new Text(
                  document.data['inspectionDate'],
                ),
              );
            }).toList(),
          );
        });
  }
}

class InspectionForm extends StatefulWidget {
  @override
  _InspectionFormState createState() => new _InspectionFormState();
}

class _InspectionFormState extends State<InspectionForm> {
  final String userid = FirebaseAuth.instance.currentUser().toString();
  DateTime _formDateTime;

  @override
  void initState() {
    super.initState();
    _formDateTime ??= DateTime.now();
  }

  void _save() {
    Inspection inspection = new Inspection(_formDateTime, userid);
    Firestore.instance
        .collection('Inspection')
        .document()
        .setData(inspection.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text("inspectionForm"),
          backgroundColor: Theme.of(context).primaryColor,
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.save),
              onPressed: _save,
            )
          ]),
      body: new Column(
        children: <Widget>[
          new DateTimeItem(
            dateTime: _formDateTime,
            onChanged: (DateTime value) {
              setState(
                () {
                  _formDateTime = value;
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class DateTimeItem extends StatelessWidget {
  DateTimeItem({Key key, DateTime dateTime, this.onChanged})
      : date = new DateTime(dateTime.year, dateTime.month, dateTime.day),
        time = new TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
        super(key: key) {
    assert(onChanged != null);
  }
  final DateTime date;
  final TimeOfDay time;
  final ValueChanged<DateTime> onChanged;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return new DefaultTextStyle(
        style: theme.textTheme.subhead,
        child: new Row(children: <Widget>[
          new Flexible(
              child: new Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  decoration: new BoxDecoration(
                      border: new Border(
                          bottom: new BorderSide(color: theme.dividerColor))),
                  child: new InkWell(
                      onTap: () {
                        showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: date.subtract(const Duration(days: 30)),
                            lastDate:
                                date.add(const Duration(days: 30))).then(
                            (DateTime value) {
                          onChanged(new DateTime(value.year, value.month,
                              value.day, time.hour, time.minute));
                        });
                      },
                      child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Text(
                                new DateFormat('EEE, MMM d yyyy').format(date)),
                            new Icon(Icons.arrow_drop_down,
                                color: Colors.black54),
                          ])))),
          new Container(
              margin: const EdgeInsets.only(left: 8.0),
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      bottom: new BorderSide(color: theme.dividerColor))),
              child: new InkWell(
                  onTap: () {
                    showTimePicker(context: context, initialTime: time)
                        .then((TimeOfDay value) {
                      onChanged(new DateTime(date.year, date.month, date.day,
                          value.hour, value.minute));
                    });
                  },
                  child: new Row(children: <Widget>[
                    new Text('$time'),
                    new Icon(Icons.arrow_drop_down, color: Colors.black54),
                  ])))
        ]));
  }
}
