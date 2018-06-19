part of nixon_app;

class ViewInfo extends StatefulWidget {
  @override
  _ViewInfoState createState() => new _ViewInfoState();
}

class _ViewInfoState extends State<ViewInfo>
//with AutomaticKeepAliveClientMixin
{
  FocusNode _focusNode1 = new FocusNode();
  FocusNode _focusNode2 = new FocusNode();
  FocusNode _focusNode3 = new FocusNode();
  FocusNode _focusNode4 = new FocusNode();
  FocusNode _focusNode5 = new FocusNode();
  FocusNode _focusNode6 = new FocusNode();

  InspectionModel model;
  TextEditingController _bldgNameController;
  TextEditingController _bldgCodeController;
  TextEditingController _nxNumberController;
  TextEditingController _staffNameController;
  TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    model = ModelFinder<InspectionModel>().of(context);
    _bldgNameController = new TextEditingController(text: model.form.bldgName);
    _bldgCodeController = new TextEditingController(text: model.form.bldgCode);
    _locationController =
        new TextEditingController(text: model.form.foundLocation);
    model.form.nixonNumber == null
        ? _nxNumberController = new TextEditingController()
        : _nxNumberController =
            new TextEditingController(text: model.form.nixonNumber.toString());
    _staffNameController =
        new TextEditingController(text: model.form.staffName);
  }

  void _showBuildingDialog() async {
    BuildingData building =
        await Navigator.of(context).push(new MaterialPageRoute<BuildingData>(
            builder: (BuildContext context) {
              return new BuildingDialog();
            },
            fullscreenDialog: true));

    if (building != null) {
      model.form.bldgName = building.buildingName;
      model.form.bldgCode = building.accBuildingCode;
      _bldgNameController =
          new TextEditingController(text: model.form.bldgName);
      _bldgCodeController =
          new TextEditingController(text: model.form.bldgCode);

      setState(() {});
    }
  }

  void _showStaffDialog() async {
    if (model.form.bldgCode.isNotEmpty) {
      StaffData staffData =
          await Navigator.of(context).push(new MaterialPageRoute<StaffData>(
              builder: (BuildContext context) {
                return new StaffDialog(bldgCode: model.form.bldgCode);
              },
              fullscreenDialog: true));

      if (staffData != null) {
        setState(() {
          model.form.nixonNumber = staffData.nixonNumber;
          model.form.staffName = staffData.givenName;

          model.form.nixonNumber == null
              ? _nxNumberController = new TextEditingController()
              : _nxNumberController = new TextEditingController(
                  text: model.form.nixonNumber.toString());
          _staffNameController =
              new TextEditingController(text: model.form.staffName);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return
        //new ScopedModelDescendant<InspectionModel>(
        //builder: (context, _, model) =>
        new ListView(
      padding: const EdgeInsets.all(10.0),
      children: <Widget>[
        new DateTextField(
          labelText: Inspection.translate('inspectionDate'),
          initialValue: model.form.inspectionDate,
          validator: (value) => _validateField(
              model.form.inspectionDate, value, model,
              nullable: false),
          onChanged: (value) => model.form.inspectionDate = value,
          onSaved: (value) => model.form.inspectionDate = value,
        ),
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Expanded(
              flex: 1,
              child: TimeTextField(
                  labelText: Inspection.translate('arrivedTime'),
                  initialValue: FormHelper.strToTime(model.form.arrivedTime),
                  validator: (value) => _validateField(model.form.arrivedTime,
                      FormHelper.timetoString(value), model, nullable: false),
                  onChanged: (value) {
                    setState(() {
                      model.form.arrivedTime = FormHelper.timetoString(value);
                      model.form.leaveTime = model.form.arrivedTime;
                    });
                  },
                  onSaved: (value) => model.form.arrivedTime = FormHelper
                      .timetoString(value) //FormHelper.timetoString(value)),
                  ),
            ),
            new Expanded(
              flex: 1,
              child: TimeTextField(
                  labelText: Inspection.translate('leaveTime'),
                  initialValue: FormHelper.strToTime(model.form.leaveTime),
                  validator: (value) => _validateField(model.form.leaveTime,
                      FormHelper.timetoString(value), model, nullable: false),
                  onChanged: (value) =>
                      model.form.leaveTime = FormHelper.timetoString(value),
                  onSaved: (value) => model.form.leaveTime = FormHelper
                      .timetoString(value) // FormHelper.timetoString(value))),
                  ),
            ),
          ],
        ),
        new EnsureVisibleWhenFocused(
          focusNode: _focusNode1,
          child: new TextFormField(
            focusNode: _focusNode1,
            style: Theme.of(context).textTheme.body2,
            decoration: InputDecoration(
              suffixIcon: new IconButton(
                  icon: new Icon(Icons.search), onPressed: _showBuildingDialog),
              labelText: Inspection.translate('bldgCode'),
            ),
            controller: _bldgCodeController,
            onFieldSubmitted: (value) => model.form.bldgCode = value,
            validator: (value) =>
                _validateField(model.form.bldgCode, value, model),
            onSaved: (value) => model.form.bldgCode = value,
          ),
        ),
        new EnsureVisibleWhenFocused(
          focusNode: _focusNode2,
          child: new TextFormField(
            style: Theme.of(context).textTheme.body2,
            decoration: InputDecoration(
              labelText: Inspection.translate('bldgName'),
            ),
            controller: _bldgNameController,
            focusNode: _focusNode2,
            onFieldSubmitted: (value) => model._form.bldgName = value,
            validator: (value) =>
                _validateField(model.form.bldgName, value, model),
            onSaved: (value) => model.form.bldgName = value,
          ),
        ),
        new EnsureVisibleWhenFocused(
          focusNode: _focusNode3,
          child: new TextFormField(
            style: Theme.of(context).textTheme.body2,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              suffixIcon: new IconButton(
                  icon: new Icon(Icons.search), onPressed: _showStaffDialog),
              labelText: Inspection.translate('nixonNumber'),
            ),
            controller: _nxNumberController,
            focusNode: _focusNode3,
            onFieldSubmitted: (value) =>
                model.form.nixonNumber = FormHelper.strToInt(value),
            validator: (value) => _validateField(
                model.form.nixonNumber, FormHelper.strToInt(value), model),
            onSaved: (value) =>
                model.form.nixonNumber = FormHelper.strToInt(value),
          ),
        ),
        new EnsureVisibleWhenFocused(
          focusNode: _focusNode4,
          child: new TextFormField(
              style: Theme.of(context).textTheme.body2,
              decoration:
                  InputDecoration(labelText: Inspection.translate('staffName')),
              controller: _staffNameController,
              focusNode: _focusNode4,
              validator: (value) =>
                  _validateField(model.form.staffName, value, model),
              onFieldSubmitted: (value) => model.form.staffName = value,
              onSaved: (value) => model.form.staffName = value),
        ),
        new Row(
          children: <Widget>[
            new Expanded(
              flex: 1,
              child: new EnsureVisibleWhenFocused(
                focusNode: _focusNode5,
                child: new TextFormField(
                  style: Theme.of(context).textTheme.body2,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: Inspection.translate('foundLocation'),
                  ),
                  controller: _locationController,
                  focusNode: _focusNode5,
                  onFieldSubmitted: (value) => model.form.foundLocation = value,
                  validator: (value) =>
                      _validateField(model.form.foundLocation, value, model),
                  onSaved: (value) => model.form.foundLocation = value,
                ),
              ),
            ),
            new Expanded(
              flex: 1,
              child: new DropDownFormField(
                initialValue: model.form.postName,
                values: ['商場', '洗手間'],
                validator: (value) =>
                    _validateField(model.form.postName, value, model),
                onSave: (value) => model.form.postName = value,
                labelText: Inspection.translate('postName'),
                onChanged: (value) => model.form.postName = value,
              ),
            ),
            new Expanded(
              flex: 1,
              child: NumberFormField(
                  labelText: Inspection.translate('guestsProportion'),
                  validator: (value) => null,
                  initialValue: int.tryParse(model.form.guestsProportion) ?? 0,
                  onChanged: (value) =>
                      model.form.guestsProportion = value.toString(),
                  onSaved: (value) =>
                      model.form.guestsProportion = value.toString()),
            ),
          ],
        ),
        new EnsureVisibleWhenFocused(
          focusNode: _focusNode6,
          child: MyFormTextField(
              labelText: Inspection.translate('situationRemark'),
              nullable: false,
              initialValue: model.form.situationRemark,
              maxLines: 1,
              onFieldSubmitted: (value) => model.form.situationRemark = value,
              focusNode: _focusNode6,
              onSave: (value) => model.form.situationRemark = value),
        ),
      ],
      //),
    );
  }

  //@override
  //bool get wantKeepAlive => true;
}
