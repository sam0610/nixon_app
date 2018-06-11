part of nixon_app;

class ViewInfo extends StatefulWidget {
  @override
  _ViewInfoState createState() => new _ViewInfoState();
}

class _ViewInfoState extends State<ViewInfo>
//with AutomaticKeepAliveClientMixin
{
  TextEditingController _staffNameController = new TextEditingController(),
      _situationRemarkController = new TextEditingController(),
      _foundLocationController = new TextEditingController(),
      _nxNumberController = new TextEditingController(),
      _bldgNameController = new TextEditingController(),
      _bldgCodeController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    InspectionModel model = ModelFinder<InspectionModel>().of(context);
    _bldgNameController.text = model.form.bldgName.toString();
    _bldgCodeController.text = model.form.bldgCode.toString();
    _nxNumberController.text = model.form.nixonNumber.toString();
  }

  void _showBuildingDialog() async {
    BuildingData building =
        await Navigator.of(context).push(new MaterialPageRoute<BuildingData>(
            builder: (BuildContext context) {
              return new BuildingDialog();
            },
            fullscreenDialog: true));

    if (building != null) {
      setState(() {
        _bldgNameController.text = building.buildingName;
        _bldgCodeController.text = building.accBuildingCode;
      });
    }
  }

  void _showStaffDialog() async {
    StaffData staffData =
        await Navigator.of(context).push(new MaterialPageRoute<StaffData>(
            builder: (BuildContext context) {
              return new StaffDialog(bldgCode: _bldgCodeController.text);
            },
            fullscreenDialog: true));

    if (staffData != null) {
      setState(() {
        _nxNumberController.text = staffData.nixonNumber.toString();
        _staffNameController.text = staffData.givenName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new ScopedModelDescendant<InspectionModel>(
      builder: (context, _, model) => new ListView(
            padding: const EdgeInsets.all(10.0),
            children: <Widget>[
              new DateTextField(
                labelText: Inspection.translate('inspectionDate'),
                initialValue: model.form.inspectionDate,
                validator: (value) =>
                    model.form.inspectionDate == null ? 'Date is Empty' : null,
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
                        initialValue:
                            FormHelper.strToTime(model.form.arrivedTime),
                        validator: (value) =>
                            model.form.arrivedTime == null ? "not set" : null,
                        onChanged: (value) {
                          setState(() {
                            model.form.arrivedTime =
                                FormHelper.timetoString(value);
                            model.form.leaveTime = model.form.arrivedTime;
                          });
                        },
                        onSaved: (value) => model.form.arrivedTime =
                            FormHelper.timetoString(
                                value) //FormHelper.timetoString(value)),
                        ),
                  ),
                  new Expanded(
                    flex: 1,
                    child: TimeTextField(
                        labelText: Inspection.translate('leaveTime'),
                        initialValue:
                            FormHelper.strToTime(model.form.leaveTime),
                        validator: (value) =>
                            model.form.leaveTime == null ? "not set" : null,
                        onChanged: (value) => model.form.leaveTime =
                            FormHelper.timetoString(value),
                        onSaved: (value) => model.form.leaveTime =
                            FormHelper.timetoString(
                                value) // FormHelper.timetoString(value))),
                        ),
                  ),
                ],
              ),
              new TextFormField(
                style: Theme.of(context).textTheme.body2,
                decoration: InputDecoration(
                  suffixIcon: new IconButton(
                      icon: new Icon(Icons.search),
                      onPressed: _showBuildingDialog),
                  labelText: Inspection.translate('bldgCode'),
                ),
                controller: _bldgCodeController,
                onFieldSubmitted: (value) => _bldgCodeController.text = value,
                validator: (value) => value.isEmpty ? ' can\'t be empty' : null,
                onSaved: (value) => model.form.bldgCode = value,
              ),
              new TextFormField(
                style: Theme.of(context).textTheme.body2,
                decoration: InputDecoration(
                  labelText: Inspection.translate('bldgName'),
                ),
                controller: _bldgNameController,
                onFieldSubmitted: (value) => _bldgNameController.text = value,
                validator: (value) => value.isEmpty ? ' can\'t be empty' : null,
                onSaved: (value) => model.form.bldgName = value,
              ),
              new TextFormField(
                style: Theme.of(context).textTheme.body2,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  suffixIcon: new IconButton(
                      icon: new Icon(Icons.search),
                      onPressed: _showStaffDialog),
                  labelText: Inspection.translate('nixonNumber'),
                ),
                controller: _nxNumberController,
                onFieldSubmitted: (value) => _nxNumberController.text = value,
                validator: (value) => value.isEmpty ? ' can\'t be empty' : null,
                onSaved: (value) =>
                    model.form.nixonNumber = FormHelper.strToInt(value),
              ),
              MyFormTextField(
                  labelText: Inspection.translate('staffName'),
                  initialValue: model.form.staffName,
                  controller: _staffNameController,
                  nullable: false,
                  onSave: (value) => model.form.staffName = value),
              new Row(
                children: <Widget>[
                  new Expanded(
                    flex: 1,
                    child: MyFormTextField(
                        labelText: Inspection.translate('foundLocation'),
                        initialValue: model.form.foundLocation,
                        controller: _foundLocationController,
                        onSave: (value) => model.form.foundLocation = value),
                  ),
                  new Expanded(
                    flex: 1,
                    child: new DropDownFormField(
                      initialValue: model.form.postName,
                      values: ['商場', '洗手間'],
                      validator: (value) => value == 0 ? 'Not Set' : null,
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
                        initialValue:
                            int.tryParse(model.form.guestsProportion) ?? 0,
                        onChanged: (value) =>
                            model.form.guestsProportion = value.toString(),
                        onSaved: (value) =>
                            model.form.guestsProportion = value.toString()),
                  ),
                ],
              ),
              MyFormTextField(
                  labelText: Inspection.translate('situationRemark'),
                  initialValue: model.form.situationRemark,
                  maxLines: 1,
                  controller: _situationRemarkController,
                  onSave: (value) => model.form.situationRemark = value),
            ],
          ),
    );
  }

  //@override
  //bool get wantKeepAlive => true;
}
