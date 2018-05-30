import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class CheckBoxFormField extends StatefulWidget {
  final String labelText;
  final int initialValue;
  final ValueChanged<int> onChanged;
  final Function onSaved;
  final FormFieldValidator validator;
  CheckBoxFormField(
      {@required this.initialValue,
      @required this.labelText,
      @required this.onChanged,
      @required this.onSaved,
      @required this.validator});

  @override
  _CheckBoxFormFieldState createState() => new _CheckBoxFormFieldState();
}

class _CheckBoxFormFieldState extends State<CheckBoxFormField> {
  int _default = 100; //default is true
  int _selected; //0 for not set -1 for na positive for score
  bool _checked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selected = widget.initialValue ?? _default;
    if (_selected == -1) _checked = true;
  }

  void _checkChanged(bool value, FormFieldState field) {
    setState(() {
      _checked = !_checked;
      _checked ? _selected = -1 : _selected = _default;
      field.didChange(_selected);
      widget.onChanged(_selected);
    });
  }

  Widget _makeCheckBox(FormFieldState field) {
    return new Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: new Row(
        children: <Widget>[
          new Text("NA:"),
          new Checkbox(
              value: _checked,
              onChanged: (value) => _checkChanged(value, field)),
        ],
      ),
    );
  }

  void _switchChanged(int value, FormFieldState field) {
    setState(() {
      _selected = value;
      widget.onChanged(_selected);
      field.didChange(_selected);
    });
  }

  Widget _makeSwitch(FormFieldState field) {
    return _checked == false
        ? new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Container(
                child: new Row(children: <Widget>[
                  new Text("未能做到"),
                  new Radio<int>(
                      value: 20,
                      groupValue: _selected,
                      onChanged: (value) => _switchChanged(value, field)),
                ]),
              ),
              new Container(
                child: new Row(children: <Widget>[
                  new Text("達到"),
                  new Radio<int>(
                      value: 100,
                      groupValue: _selected,
                      onChanged: (value) => _switchChanged(value, field)),
                ]),
              )
            ],
          )
        : new Text("NA");
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(5.0),
      child: new FormField<int>(
        initialValue: _selected,
        validator: widget.validator,
        onSaved: (int value) => widget.onSaved(value),
        builder: (FormFieldState<int> field) {
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
            child: new Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _makeCheckBox(field),
                  new Expanded(child: _makeSwitch(field)),
                  new Container(
                    alignment: AlignmentDirectional.center,
                    width: 50.0,
                    child: new Padding(
                      padding: new EdgeInsets.all(10.0),
                      child: new Text(
                        field.value == -1 ? 'N/A' : field.value.toString(),
                        style: new TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ]),
          );
        },
      ),
    );
  }
}
