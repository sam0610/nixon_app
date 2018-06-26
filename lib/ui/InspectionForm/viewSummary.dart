part of nixon_app;

class ViewSummary extends StatefulWidget {
  @override
  _ViewSummaryState createState() => new _ViewSummaryState();
}

class _ViewSummaryState extends State<ViewSummary> {
  InspectionModel model;
  @override
  void initState() {
    super.initState();
    model = ModelFinder<InspectionModel>().of(context);
  }

  void showSnackBar(BuildContext context, String msg,
      {Color bgcolor = Colors.blue}) {
    Scaffold.of(context).showSnackBar(
          new SnackBar(
              duration: new Duration(seconds: 1),
              content: new Text(msg),
              backgroundColor: bgcolor),
        );
  }

  TableRow dRow(String title, double score) {
    return new TableRow(
      children: [
        new Padding(
          padding: const EdgeInsets.all(10.0),
          child: new Text(
            title + " : ",
            style: Theme.of(context).textTheme.body2,
          ),
        ),
        new Padding(
          padding: const EdgeInsets.all(10.0),
          child: score > -1
              ? new Text(
                  score.toInt().toString(),
                  style: Theme
                      .of(context)
                      .textTheme
                      .body2
                      .copyWith(color: Colors.blue),
                  textAlign: TextAlign.center,
                )
              : new Text(
                  'incomplete',
                  style: Theme
                      .of(context)
                      .textTheme
                      .body2
                      .copyWith(color: Colors.blue),
                  textAlign: TextAlign.center,
                ),
        ),
      ],
    );
  }

  List<TableRow> _buildRow(Inspection form) {
    Map<String, dynamic> rowData = {
      'grooming': model.form.grooming.toJson(),
      'behavior': model.form.behavior.toJson(),
      'serveCust': model.form.serveCust.toJson(),
      'listenCust': model.form.listenCust.toJson(),
      'handleCust': model.form.handleCust.toJson(),
      'closure': model.form.closure.toJson(),
      'communicationSkill': model.form.communicationSkill.toJson(),
      'warmHeart': model.form.warmHeart.toJson(),
      'cleanlinessMall': model.form.cleanlinessMall == null
          ? null
          : model.form.cleanlinessMall.toJson(),
      'cleanlinessToilet': model.form.cleanlinessToilet == null
          ? null
          : model.form.cleanlinessToilet.toJson(),
    };

    if (model.form.postName == '洗手間')
      rowData.removeWhere((k, v) => k == 'cleanlinessMall');
    if (model.form.postName == '商場')
      rowData.removeWhere((k, v) => k == 'cleanlinessToilet');

    List<TableRow> _row = new List();
    _row.add(new TableRow(children: [
      new Padding(
        padding: const EdgeInsets.all(10.0),
        child: new Text(
          "項目",
          style: Theme
              .of(context)
              .textTheme
              .body2
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      new Padding(
        padding: const EdgeInsets.all(10.0),
        child: new Text(
          "得分",
          textAlign: TextAlign.center,
          style: Theme
              .of(context)
              .textTheme
              .body2
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    ]));
    rowData.forEach((String key, dynamic value) {
      _row.add(
          dRow(TranslateHelper.translate(key), FormHelper.calculate(value)));
    });
    return _row;
  }

  Future<bool> _confirmSave() async => await FormHelper()._confirmDialog(
      context: context,
      title: '請確認無誤',
      msg: '一經確認記錄將無法修改!!',
      trueText: '是',
      falseText: '取消');

  _save(BuildContext context) {
    final form = model._globalKey.currentState;
    if (form.validate()) {
      form.save();
      if (model.form.files != null) {
        if (model.form.id == null) {
          InspectionRepos.addInspection(model.form).whenComplete(() {
            Navigator.pop(context);
          }).catchError((onError) =>
              showSnackBar(context, onError.toString(), bgcolor: Colors.red));
        } else {
          InspectionRepos.updateInspection(model.form).whenComplete(() {
            Navigator.pop(context);
          }).catchError((onError) =>
              showSnackBar(context, onError.toString(), bgcolor: Colors.red));
        }
      }
    } else {
      showSnackBar(context, 'Please fill in blank field', bgcolor: Colors.red);
      model.setAutoValidate(true);
    }
  }

  _saveToComplete(InspectionModel model) {
    if (!model.form.checkForComplete()) {
      showSnackBar(context, 'form incompleted');
    } else {
      _confirmSave().then((result) {
        if (result == true) {
          if (model.form.postName == "洗手間") {
            model.form.cleanlinessMall = null;
          } else if (model.form.postName == "商場") {
            model.form.cleanlinessToilet = null;
          }
          model.form.status = InspectionStatus.complete;
          _save(context);
        } else {
          showSnackBar(context, 'canceled by user', bgcolor: Colors.red);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.all(10.0),
      child: new ListView(
        children: <Widget>[
          new Table(
            border: new TableBorder.all(color: Theme.of(context).accentColor),
            children: _buildRow(model.form),
            defaultColumnWidth: FlexColumnWidth(15.0),
          ),
          new SizedBox(height: 15.0),
          model.isFormCompleted
              ? new Container()
              : new RaisedButton.icon(
                  icon: new Icon(Icons.done_all),
                  label: new Text('提交'),
                  onPressed: () => _saveToComplete(model),
                )
        ],
      ),
    );
  }
}
