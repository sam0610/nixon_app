import 'package:flutter/material.dart';
import 'package:nixon_app/Models/Inspection.dart';

class ViewSummary extends StatefulWidget {
  ViewSummary(this.inspection);
  final Inspection inspection;

  @override
  _ViewSummaryState createState() => new _ViewSummaryState();
}

class _ViewSummaryState extends State<ViewSummary> {
  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[],
    );
  }
}
