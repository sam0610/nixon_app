part of nixon_app;

class NumberFormField extends StatefulWidget {
  final String labelText;
  final int initialValue;
  final ValueChanged<int> onChanged;
  final Function onSaved;
  final FormFieldValidator validator;
  NumberFormField(
      {@required this.initialValue,
      @required this.labelText,
      @required this.onChanged,
      @required this.onSaved,
      @required this.validator});

  @override
  _NumberFormFieldState createState() => new _NumberFormFieldState();
}

class _NumberFormFieldState extends State<NumberFormField> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void changed(int value, FormFieldState field) {
    setState(() {
      int _value = field.value + value;
      widget.onChanged(_value);
      field.didChange(_value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new FormField<int>(
      initialValue: widget.initialValue ?? 0,
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
          ),
          child: new Container(
            height: 30.0,
            child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Expanded(
                      child: new Center(
                    child: new Text(field.value.toString(),
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.body2),
                  )),
                  new GestureDetector(
                    child: Icon(
                      Icons.add_circle,
                      color: Colors.blue,
                    ),
                    onTap: () => changed(1, field),
                  ),
                  new GestureDetector(
                    child: Icon(
                      Icons.remove_circle,
                      color: Colors.red,
                    ),
                    onTap: () => changed(-1, field),
                  )
                ]),
          ),
        );
      },
    );
  }
}
