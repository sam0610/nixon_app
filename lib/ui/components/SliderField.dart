import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class SliderField extends StatefulWidget {
  SliderField({
    this.initialValue,
    this.labelText,
    @required this.onChanged,
  });

  final int initialValue;
  final ValueChanged<int> onChanged;
  final String labelText;

  @override
  _SliderFieldState createState() => new _SliderFieldState();
}

class _SliderFieldState extends State<SliderField> {
  int _selected = 0;
  bool _checked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selected = widget.initialValue;
    if (_selected == -1) _checked = true;
  }

  void _checkChanged(bool value) {
    setState(() {
      _checked = !_checked;
      _checked ? _selected = -1 : _selected = 0;
      widget.onChanged(_selected);
    });
  }

  void _sliderChanged(double value) {
    setState(() {
      _selected = value.toInt();
      widget.onChanged(value.toInt());
    });
  }

  Widget _makeCheckBox() {
    return new Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: new Row(
        children: <Widget>[
          new Text("NA:"),
          new Checkbox(value: _checked, onChanged: _checkChanged),
        ],
      ),
    );
  }

  Widget _makeSlider() {
    return _checked == false
        ? new Slider(
            value: _selected.toDouble(),
            min: 0.0,
            max: 100.0,
            divisions: 10,
            onChanged: _sliderChanged)
        // : null;
        : new Text("NA");
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(3.0),
      child: new InputDecorator(
        decoration: new InputDecoration(
          labelText: widget.labelText,
          border:
              OutlineInputBorder(borderRadius: new BorderRadius.circular(5.0)),
          contentPadding: new EdgeInsets.all(8.0),
        ),
        child: new Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _makeCheckBox(),
              new Expanded(child: _makeSlider()),
              new Padding(
                padding: new EdgeInsets.all(10.0),
                child: new Text(
                  _selected.toString(),
                  style: new TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ]),
      ),
    );
  }
}
