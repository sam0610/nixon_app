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
  String _value;
  List<String> _values = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _values.addAll(widget.values);
    _value = widget.initialValue ?? null;
    if (!_values.contains(_value)) _value = null;
  }

  void _checkChanged(String v, FormFieldState field) {
    setState(() {
      _value = v;
      widget.onChanged(_value);
      field.didChange(_value);
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
        return new InputDecorator(
          decoration: InputDecoration(
            labelText: widget.labelText,
            border: InputBorder.none,
          ),
          //isEmpty: field.value == '',
          child: new DropdownButtonHideUnderline(
            child: new DropdownButton<String>(
              value: field.value,
              hint: new Text('請選擇'),
              isDense: true,
              onChanged: (v) => _checkChanged(v, field),
              items: _values.map((String value) {
                return new DropdownMenuItem<String>(
                    child: new Text(value), value: value);
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
