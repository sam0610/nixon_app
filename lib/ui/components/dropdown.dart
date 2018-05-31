import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import '../../nixon_app.dart';

class DropDownFormField extends StatefulWidget {
  final String labelText;
  final BuildingData initialValue;
  final ValueChanged<BuildingData> onChanged;
  final Function onSaved;
  final FormFieldValidator validator;
  DropDownFormField(
      {@required this.initialValue,
      @required this.labelText,
      @required this.onChanged,
      @required this.onSaved,
      @required this.validator});

  @override
  _DropDownFormFieldState createState() => new _DropDownFormFieldState();
}

class _DropDownFormFieldState extends State<DropDownFormField> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new FutureBuilder<List<BuildingData>>(
        future: fetchBldgList(new http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return new Text(snapshot.error);
          }
          return snapshot.hasData
              ? new BuildingDropdown(
                  values: snapshot.data,
                  labelText: widget.labelText,
                  initialValue: widget.initialValue,
                  onChanged: widget.onChanged,
                  onSaved: widget.onSaved,
                  validator: widget.validator,
                )
              : new Center(child: new AnimatedCircularProgress());
        },
      ),
    );
  }
}

class BuildingDropdown extends StatefulWidget {
  BuildingDropdown(
      {@required this.values,
      @required this.labelText,
      @required this.initialValue,
      @required this.onChanged,
      @required this.onSaved,
      @required this.validator});
  final List<BuildingData> values;
  final String labelText;
  final BuildingData initialValue;
  final ValueChanged<BuildingData> onChanged;
  final Function onSaved;
  final FormFieldValidator validator;
  @override
  _BuildingDropdownState createState() => new _BuildingDropdownState();
}

class _BuildingDropdownState extends State<BuildingDropdown> {
  BuildingData _selected;

  @override
  void initState() {
    super.initState();
    //_selected = widget.initialValue ?? widget.values.first;
  }

  onChanged(BuildingData value, FormFieldState field) {
    _selected = value;
    widget.onChanged(value);
    field.didChange(value);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: new FormField<BuildingData>(
        initialValue: _selected,
        validator: widget.validator,
        onSaved: (BuildingData value) => widget.onSaved(value),
        builder: (FormFieldState<BuildingData> field) {
          if (Form.of(field.context).widget.autovalidate) {
            field.validate();
          }
          return new InputDecorator(
            decoration: new InputDecoration(
              labelText: widget.labelText,
              errorText: field.errorText,
              border: OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(5.0)),
              contentPadding: new EdgeInsets.all(3.0),
            ),
            child: new DropdownButton(
              value: field.value,
              items: widget.values.map((value) {
                return new DropdownMenuItem(
                    value: value,
                    child: new Row(
                      children: <Widget>[
                        new Text(value.accBuildingCode.toString()),
                        new Padding(
                          padding: EdgeInsets.all(10.0),
                        ),
                        new Text(value.buildingName.toString()),
                      ],
                    ));
              }).toList(),
              onChanged: (value) => onChanged(value, field),
            ),
          );
        },
      ),
    );
  }
}
