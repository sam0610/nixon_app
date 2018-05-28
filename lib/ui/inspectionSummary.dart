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

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        text("儀容", calculate(widget.inspection.grooming.toJson())),
        text("舉止", calculate(widget.inspection.behavior.toJson())),
        text("接待顧客", calculate(widget.inspection.serveCust.toJson())),
        text("了解需要", calculate(widget.inspection.listenCust.toJson())),
        text("處理顧客要求", calculate(widget.inspection.handleCust.toJson())),
        text("結束對話", calculate(widget.inspection.closure.toJson())),
        text("溝通技巧", calculate(widget.inspection.communicationSkill.toJson())),
        text("窩心", calculate(widget.inspection.warmHeart.toJson())),
      ],
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
