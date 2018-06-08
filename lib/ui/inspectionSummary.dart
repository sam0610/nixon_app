part of nixon_app;

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
    _row.add(dRow(Inspection.translate('grooming'),
        FormHelper.calculate(widget.inspection.grooming.toJson())));
    _row.add(dRow(Inspection.translate('behavior'),
        FormHelper.calculate(widget.inspection.behavior.toJson())));
    _row.add(dRow(Inspection.translate('serveCust'),
        FormHelper.calculate(widget.inspection.serveCust.toJson())));
    _row.add(dRow(Inspection.translate('listenCust'),
        FormHelper.calculate(widget.inspection.listenCust.toJson())));
    _row.add(dRow(Inspection.translate('handleCust'),
        FormHelper.calculate(widget.inspection.handleCust.toJson())));
    _row.add(dRow(Inspection.translate('closure'),
        FormHelper.calculate(widget.inspection.closure.toJson())));
    _row.add(dRow(Inspection.translate('communicationSkill'),
        FormHelper.calculate(widget.inspection.communicationSkill.toJson())));
    _row.add(dRow(Inspection.translate('warmHeart'),
        FormHelper.calculate(widget.inspection.warmHeart.toJson())));
    if (myform.postName == "商場") {
      _row.add(dRow(Inspection.translate('cleanlinessMall'),
          FormHelper.calculate(widget.inspection.cleanlinessMall.toJson())));
    } else if (myform.postName == "洗手間") {
      _row.add(dRow(Inspection.translate('cleanlinessToilet'),
          FormHelper.calculate(widget.inspection.cleanlinessToilet.toJson())));
    }

    return new Card(
      elevation: 4.0,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(5.0)),
      child: new ListView(
        children: <Widget>[
          new Table(
            border: new TableBorder.all(color: Theme.of(context).accentColor),
            children: _row,
            defaultColumnWidth: FlexColumnWidth(15.0),
          ),
        ],
      ),
    );
  }
}
