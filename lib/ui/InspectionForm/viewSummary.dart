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

  void showSnackBar(BuildContext context, String msg,
      {Color bgcolor = Colors.blue}) {
    Scaffold.of(context).showSnackBar(
          new SnackBar(
              duration: new Duration(seconds: 10),
              content: new Text(msg),
              backgroundColor: bgcolor),
        );
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

    Future<bool> _confirmSave() async => await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text(
              '請確認無誤',
              style: Theme
                  .of(context)
                  .textTheme
                  .body2
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            content: const Text('一經確認記錄將無法修改?'),
            actions: <Widget>[
              new FlatButton(
                color: Colors.redAccent,
                child: Text(
                  '否',
                  style: Theme
                      .of(context)
                      .textTheme
                      .body1
                      .copyWith(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              new FlatButton(
                color: Colors.blueAccent,
                child: Text(
                  '是',
                  style: Theme
                      .of(context)
                      .textTheme
                      .body1
                      .copyWith(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });

    _saveToComplete(InspectionModel model) {
      if (!model.form.checkForComplete()) {
        showSnackBar(context, 'form incompleted');
      } else {
        if ((_confirmSave) == true) {
          if (model.form.postName == "洗手間") model.form.cleanlinessMall = null;
          if (model.form.postName == "商場") model.form.cleanlinessToilet = null;
          model.form.status = InspectionStatus.complete.toString();
          SaveActionButton(
            model,
          )._save(context);
        } else {
          showSnackBar(context, 'canceled by user');
        }
      }
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
                    new Text('確認表格'),
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
