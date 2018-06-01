part of nixon_app;

class DateTextField extends StatefulWidget {
  final String labelText;
  final DateTime initialValue;
  final ValueChanged<DateTime> onChanged;
  final Function onSaved;
  final FormFieldValidator validator;
  DateTextField(
      {this.initialValue,
      this.labelText,
      this.onChanged,
      this.onSaved,
      this.validator});

  @override
  _DateTextFieldState createState() => new _DateTextFieldState();
}

class _DateTextFieldState extends State<DateTextField> {
  DateTime _defaultValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _defaultValue = widget.initialValue ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return new FormField<DateTime>(
      initialValue: _defaultValue,
      validator: widget.validator,
      onSaved: (DateTime value) => widget.onSaved(value),
      builder: (FormFieldState<DateTime> field) {
        if (Form.of(field.context).widget.autovalidate) {
          field.validate();
        }
        return new InputDecorator(
            decoration: new InputDecoration(
                labelText: widget.labelText,
                border: InputBorder.none,
                errorText: field.errorText),
            child: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new InkWell(
                // shape: new RoundedRectangleBorder(
                //     borderRadius: new BorderRadius.circular(5.0)),
                // color: Theme.of(context).accentColor,
                //onPressed:
                onTap: () => selectDate(context),
                child: new Text(
                  FormHelper.datetoString(_defaultValue),
                ),
              ),
            ));
      },
    );
  }

  selectDate(BuildContext context) async {
    final DateTime picked = await FormHelper.selectDateDialog(ctx: context);
    if (picked != null) {
      setState(
        () {
          _defaultValue = picked;
          widget.onChanged(picked);
        },
      );
    }
  }
}
