part of nixon_app;

class DropDownFormField extends StatefulWidget {
  final String labelText;
  final String initialValue;
  final List<String> values;
  final ValueChanged<String> onChanged;
  final Function onSave;
  final FormFieldValidator validator;
  DropDownFormField(
      {@required this.initialValue,
      @required this.values,
      @required this.labelText,
      @required this.onChanged,
      @required this.onSave,
      @required this.validator});

  @override
  _DropDownFormFieldState createState() => new _DropDownFormFieldState();
}

class _DropDownFormFieldState extends State<DropDownFormField> {
  String _value = '';
  List<String> _values = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _values.add('');
    _values.addAll(widget.values);
    _value = widget.initialValue ?? '';
    if (!_values.contains(_value)) _values.add(_value);
  }

  void _checkChanged(String value, FormFieldState field) {
    setState(() {
      _value = value;
      field.didChange(value);
      widget.onChanged(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new FormField<String>(
      initialValue: _value,
      validator: widget.validator,
      onSaved: (String value) => widget.onSave(value),
      builder: (FormFieldState<String> field) {
        if (Form.of(field.context).widget.autovalidate) {
          field.validate();
        }
        return new Container(
          child: new InputDecorator(
            decoration: InputDecoration(labelText: widget.labelText),
            isEmpty: field.value == '',
            child: new Padding(
              padding: const EdgeInsets.all(4.0),
              child: new DropdownButtonHideUnderline(
                child: new DropdownButton<String>(
                  value: field.value,
                  isDense: true,
                  onChanged: (value) => _checkChanged(value, field),
                  items: _values.map((String value) {
                    return new DropdownMenuItem(
                        child: new Text(value), value: value);
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
