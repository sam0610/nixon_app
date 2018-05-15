import 'package:flutter/material.dart';

import '../../Helper/formHelper.dart';

class TimeTextField extends StatefulWidget {
  final String labelText;
  final TimeOfDay initialValue;
  final ValueChanged<TimeOfDay> onChanged;
  final FormFieldValidator validator;
  final bool autoValidate;
  final Function onSaved;
  TimeTextField(
      {this.initialValue,
      this.labelText,
      this.onChanged,
      this.onSaved,
      this.validator,
      this.autoValidate = false});

  @override
  _TimeTextFieldState createState() => new _TimeTextFieldState();
}

class _TimeTextFieldState extends State<TimeTextField> {
  TimeOfDay _defaultValue;
  FormState form;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _defaultValue =
        widget.initialValue != null ? widget.initialValue : TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return new FormField<TimeOfDay>(
      autovalidate: widget.autoValidate,
      initialValue: _defaultValue,
      validator: widget.validator,
      onSaved: (TimeOfDay value) => widget.onSaved(value),
      builder: (FormFieldState<TimeOfDay> field) {
        return new InputDecorator(
          decoration: new InputDecoration(
              errorText: field.errorText,
              labelText: widget.labelText,
              border: InputBorder.none),
          child: new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new FlatButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              color: Theme.of(context).accentColor,
              onPressed: () {
                selectTime(context, field, initialTime: _defaultValue);
              },
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Icon(Icons.timer),
                  new Padding(
                    padding: EdgeInsets.only(right: 10.0),
                  ),
                  new Text(FormHelper.timetoString(field.value)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  selectTime(BuildContext context, FormFieldState field,
      {TimeOfDay initialTime}) async {
    final TimeOfDay picked = await FormHelper.selectTimeDialog(
        ctx: context, initialTime: initialTime);
    if (picked != null) {
      setState(
        () {
          _defaultValue = picked;
          field.didChange(picked);
          widget.onChanged(picked);
        },
      );
    }
  }
}
