import 'package:flutter/material.dart';
import 'package:nixon_app/Helper/formHelper.dart';

class SliderFormField extends StatefulWidget {
  final String labelText;
  final int initialValue;
  final ValueChanged<int> onChanged;
  final Function onSaved;
  final FormFieldValidator validator;
  SliderFormField(
      {this.initialValue,
      this.labelText,
      this.onChanged,
      this.onSaved,
      this.validator});

  @override
  _SliderFormFieldState createState() => new _SliderFormFieldState();
}

class _SliderFormFieldState extends State<SliderFormField> {
  int _selected = 0; //-2 for null -1 for na positive for score
  bool _checked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selected = widget.initialValue;
    if (_selected == -1) _checked = true;
  }

  void _checkChanged(bool value, FormFieldState field) {
    setState(() {
      _checked = !_checked;
      _checked ? _selected = -1 : _selected = 0;
      field.didChange(_selected);
      widget.onChanged(_selected);
    });
  }

  void _sliderChanged(double value, FormFieldState field) {
    setState(() {
      _selected = value.toInt();
      widget.onChanged(_selected);
      field.didChange(_selected);
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

  Widget _makeSlider(FormFieldState field) {
    return _checked == false
        ? new Slider(
            value: _selected.toDouble(),
            min: 0.0,
            max: 100.0,
            divisions: 10,
            onChanged: (value) => _sliderChanged(value, field))
        // : null;
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
                  new Expanded(child: _makeSlider(field)),
                  new Padding(
                    padding: new EdgeInsets.all(10.0),
                    child: new Text(
                      field.value == 0
                          ? 'not set'
                          : field.value == -1 ? 'N/A' : field.value.toString(),
                      style: new TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ]),
          );
        },
      ),
    );
  }
}
