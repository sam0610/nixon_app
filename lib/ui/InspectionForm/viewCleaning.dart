part of nixon_app;

class ViewCleaning extends StatefulWidget {
  @override
  _ViewCleaningState createState() => new _ViewCleaningState();
}

class _ViewCleaningState extends State<ViewCleaning> {
  int postType = 0;

  @override
  void initState() {
    super.initState();
    InspectionModel model = ModelFinder<InspectionModel>().of(context);
    if (model.form.postName == "洗手間") {
      postType = 2;
    } else if (model.form.postName == "商場") {
      postType = 1;
    } else {
      postType = 0;
    }
  }

  Widget buildToiletLayout() {
    return ScopedModelDescendant<InspectionModel>(
      builder: (context, _, model) => new ListView(
            children: <Widget>[
              new ExpansionContainer(
                name: Inspection.translate('cleanlinessToilet'),
                //padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                children: <Widget>[
                  makeSwitchWidget(
                    initialValue: model.form.cleanlinessToilet.toilet_1,
                    labelText: Inspection.translate('toilet_1'),
                    onChanged: (value) =>
                        model.form.cleanlinessToilet.toilet_1 = value,
                  ),
                  makeSwitchWidget(
                    initialValue: model.form.cleanlinessToilet.toilet_2,
                    labelText: Inspection.translate('toilet_2'),
                    onChanged: (value) =>
                        model.form.cleanlinessToilet.toilet_2 = value,
                  ),
                  makeSwitchWidget(
                    initialValue: model.form.cleanlinessToilet.toilet_3,
                    labelText: Inspection.translate('toilet_3'),
                    onChanged: (value) =>
                        model.form.cleanlinessToilet.toilet_3 = value,
                  ),
                  makeSwitchWidget(
                    initialValue: model.form.cleanlinessToilet.toilet_4,
                    labelText: Inspection.translate('toilet_4'),
                    onChanged: (value) =>
                        model.form.cleanlinessToilet.toilet_4 = value,
                  ),
                  makeSwitchWidget(
                    initialValue: model.form.cleanlinessToilet.toilet_5,
                    labelText: Inspection.translate('toilet_5'),
                    onChanged: (value) =>
                        model.form.cleanlinessToilet.toilet_5 = value,
                  ),
                  makeSwitchWidget(
                    initialValue: model.form.cleanlinessToilet.toilet_6,
                    labelText: Inspection.translate('toilet_6'),
                    onChanged: (value) =>
                        model.form.cleanlinessToilet.toilet_6 = value,
                  ),
                ],
              ),
            ],
          ),
    );
  }

  Widget buildMallLayout() {
    return ScopedModelDescendant<InspectionModel>(
      builder: (context, _, model) => new ListView(
            children: <Widget>[
              new ExpansionContainer(
                name: Inspection.translate('cleanlinessMall'),
                //padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                children: <Widget>[
                  makeSwitchWidget(
                    initialValue: model.form.cleanlinessMall.mall_1,
                    labelText: Inspection.translate('mall_1'),
                    onChanged: (value) =>
                        model.form.cleanlinessMall.mall_1 = value,
                  ),
                  makeSwitchWidget(
                    initialValue: model.form.cleanlinessMall.mall_2,
                    labelText: Inspection.translate('mall_2'),
                    onChanged: (value) =>
                        model.form.cleanlinessMall.mall_2 = value,
                  ),
                  makeSwitchWidget(
                    initialValue: model.form.cleanlinessMall.mall_3,
                    labelText: Inspection.translate('mall_3'),
                    onChanged: (value) =>
                        model.form.cleanlinessMall.mall_3 = value,
                  ),
                ],
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (postType == 2) {
      return buildToiletLayout();
    } else if (postType == 1) {
      return buildMallLayout();
    } else {
      return new ListView(
        children: <Widget>[
          new Text('請選擇崗位', style: Theme.of(context).textTheme.body2)
        ],
      );
    }
  }
}
