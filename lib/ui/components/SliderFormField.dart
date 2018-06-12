part of nixon_app;

class SliderFormField extends StatefulWidget {
  final String labelText;
  final int initialValue;
  final ValueChanged<int> onChanged;
  final FormFieldSetter<int> onSaved;
  final FormFieldValidator<int> validator;
  SliderFormField(
      {@required this.initialValue,
      @required this.labelText,
      @required this.onChanged,
      @required this.onSaved,
      @required this.validator});

  @override
  _SliderFormFieldState createState() => new _SliderFormFieldState();
}

class _SliderFormFieldState extends State<SliderFormField> {
  final int _defaultMin = 20;
  final int _defaultMax = 100;

  int _selected; //10 for not set -1 for na positive for score, 20 is minimum score
  bool _checked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _selected = widget.initialValue ?? _defaultMin;
    if (_selected == -1) {
      _checked = true;
    } else if (_selected < _defaultMin) {
      _selected = _defaultMin;
    }
  }

  void _checkChanged(bool value, FormFieldState field) {
    setState(() {
      _checked = !_checked;
      _checked ? _selected = -1 : _selected = _defaultMax;
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
      padding: const EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0),
      child: new Checkbox(
          value: _checked, onChanged: (value) => _checkChanged(value, field)),
    );
  }

  Widget _makeSlider(FormFieldState field) {
    return _checked == false
        ? new Slider(
            value: _selected.toDouble(),
            min: 20.0,
            max: 100.0,
            divisions: 8,
            onChanged: (value) => _sliderChanged(value, field))
        // : null;
        : new Text("");
  }

  Widget _makeText(FormFieldState field) {
    return new Container(
      width: 40.0,
      alignment: AlignmentDirectional.center,
      child: new Padding(
        padding: new EdgeInsets.all(5.0),
        child: new Text(
          field.value == -1 ? 'N/A' : field.value.toString(),
          style: new TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 3.0,
      ),
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
                borderRadius: new BorderRadius.circular(5.0),
              ),
              contentPadding: new EdgeInsets.all(3.0),
            ),
            child: new Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _makeCheckBox(field),
                  _makeText(field),
                  new Expanded(child: _makeSlider(field))
                ]),
          );
        },
      ),
    );
  }
}
