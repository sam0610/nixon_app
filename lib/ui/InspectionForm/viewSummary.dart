part of nixon_app;

class ViewSummary extends StatefulWidget {
  @override
  _ViewSummaryState createState() => new _ViewSummaryState();
}

class _ViewSummaryState extends State<ViewSummary> {
  @override
  void initState() {
    super.initState();
  }

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
          child: score > -1
              ? new Text(
                  score.toInt().toString(),
                  style: style.copyWith(color: Colors.blue),
                  textAlign: TextAlign.center,
                )
              : new Text(
                  'incomplete',
                  style: style.copyWith(color: Colors.blue),
                  textAlign: TextAlign.center,
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<TableRow> _buildRow(Inspection form) {
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
          FormHelper.calculate(form.grooming.toJson())));
      _row.add(dRow(Inspection.translate('behavior'),
          FormHelper.calculate(form.behavior.toJson())));
      _row.add(dRow(Inspection.translate('serveCust'),
          FormHelper.calculate(form.serveCust.toJson())));
      _row.add(dRow(Inspection.translate('listenCust'),
          FormHelper.calculate(form.listenCust.toJson())));
      _row.add(dRow(Inspection.translate('handleCust'),
          FormHelper.calculate(form.handleCust.toJson())));
      _row.add(dRow(Inspection.translate('closure'),
          FormHelper.calculate(form.closure.toJson())));
      _row.add(dRow(Inspection.translate('communicationSkill'),
          FormHelper.calculate(form.communicationSkill.toJson())));
      _row.add(dRow(Inspection.translate('warmHeart'),
          FormHelper.calculate(form.warmHeart.toJson())));
      if (form.postName == "商場") {
        _row.add(dRow(Inspection.translate('cleanlinessMall'),
            FormHelper.calculate(form.cleanlinessMall.toJson())));
      } else if (form.postName == "洗手間") {
        _row.add(dRow(Inspection.translate('cleanlinessToilet'),
            FormHelper.calculate(form.cleanlinessToilet.toJson())));
      }
      return _row;
    }

    _saveToComplete(InspectionModel model) {
      model.form.status = InspectionStatus.complete.toString();
      SaveActionButton(
        model,
      )._save(context);
    }

    RaisedButton buildRaisedButton(
        BuildContext context, InspectionModel model) {
      return new RaisedButton(
        color: Theme.of(context).accentColor,
        child: new Container(
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Row(
                  children: <Widget>[
                    new Icon(
                      Icons.file_upload,
                    ),
                    new Text('Complete'),
                  ],
                ),
              ),
            ],
          ),
        ),
        onPressed: () => _saveToComplete(model),
      );
    }

    return new Container(
        padding: EdgeInsets.all(10.0),
        child: ScopedModelDescendant<InspectionModel>(
          builder: (context, _, model) => new ListView(
                children: <Widget>[
                  new Table(
                    border: new TableBorder.all(
                        color: Theme.of(context).accentColor),
                    children: _buildRow(model.form),
                    defaultColumnWidth: FlexColumnWidth(15.0),
                  ),
                  new SizedBox(height: 10.0),
                  model.isFormCompleted
                      ? new SizedBox(
                          height: 0.0,
                        )
                      : buildRaisedButton(context, model)
                ],
              ),
        ));
  }
}
