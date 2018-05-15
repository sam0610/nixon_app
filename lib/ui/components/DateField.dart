import 'package:flutter/material.dart';
import 'package:nixon_app/Helper/formHelper.dart';

class DateTextField extends StatefulWidget {
  final String labelText;
  final DateTime initialValue;
  final ValueChanged<DateTime> onChanged;
  final Function onSaved;
  final FormFieldValidator validator;
  final bool autoValidate;
  DateTextField(
      {this.initialValue,
      this.labelText,
      this.onChanged,
      this.onSaved,
      this.validator,
      this.autoValidate});

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
      autovalidate: widget.autoValidate,
      onSaved: (DateTime value) => widget.onSaved(value),
      builder: (FormFieldState<DateTime> field) {
        return new InputDecorator(
            decoration: new InputDecoration(
                labelText: widget.labelText,
                border: InputBorder.none,
                errorText: field.errorText),
            child: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new FlatButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0)),
                color: Theme.of(context).accentColor,
                onPressed: () => selectDate(context),
                child: new Text(FormHelper.datetoString(_defaultValue)),
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
