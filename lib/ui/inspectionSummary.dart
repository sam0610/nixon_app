import 'package:flutter/material.dart';
import '../Models/Inspection.dart';

class ViewSummary extends StatefulWidget {
  ViewSummary(this.inspection);
  final Inspection inspection;

  @override
  _ViewSummaryState createState() => new _ViewSummaryState();
}

class _ViewSummaryState extends State<ViewSummary> {
  Widget text(String title, double score) {
    TextStyle style =
        new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Row(
        children: <Widget>[
          new Text(
            title + " : ",
            style: style,
          ),
          new Text(
            score.toInt().toString(),
            style: style.copyWith(color: Colors.blue),
          ),
        ],
      ),
    );
  }

  TextStyle style = new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);

  TableRow dRow(String title, double score) {
    return new TableRow(
      children: [
        new Padding(
          padding: const EdgeInsets.all(10.0),
          child: new Text(
            title + " : ",
            style: style,
          ),
        ),
        new Padding(
          padding: const EdgeInsets.all(10.0),
          child: new Text(
            score.toInt().toString(),
            style: style.copyWith(color: Colors.blue),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<TableRow> _row = new List();
    _row.add(new TableRow(children: [
      new Padding(
        padding: const EdgeInsets.all(10.0),
        child: new Text(
          "項目",
          style: style.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      new Padding(
        padding: const EdgeInsets.all(10.0),
        child: new Text(
          "得分",
          textAlign: TextAlign.center,
          style: style.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    ]));
    _row.add(dRow("儀容", calculate(widget.inspection.grooming.toJson())));
    _row.add(dRow("舉止", calculate(widget.inspection.behavior.toJson())));
    _row.add(dRow("接待顧客", calculate(widget.inspection.serveCust.toJson())));
    _row.add(dRow("了解需要", calculate(widget.inspection.listenCust.toJson())));
    _row.add(dRow("處理顧客要求", calculate(widget.inspection.handleCust.toJson())));
    _row.add(dRow("結束對話", calculate(widget.inspection.closure.toJson())));
    _row.add(
        dRow("溝通技巧", calculate(widget.inspection.communicationSkill.toJson())));
    _row.add(dRow("窩心", calculate(widget.inspection.warmHeart.toJson())));

    return new Card(
      elevation: 4.0,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(5.0)),
      child: new Table(
        border: new TableBorder.all(color: Theme.of(context).accentColor),
        children: _row,
        defaultColumnWidth: FlexColumnWidth(15.0),
      ),
    );
  }
}

double calculate(Map<String, dynamic> object) {
  double count = 0.0;
  double sum = 0.0;
  object.forEach((k, v) {
    int value = v is int ? v : 0;
    if (value > 0) {
      count += 1.0;
      sum += v;
    }
  });
  final double total = count == 0.0 ? 0.0 : sum / count;
  return total;
}
