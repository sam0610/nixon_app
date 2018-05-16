import 'package:flutter/material.dart';

import '../../Helper/formHelper.dart';

class TimeTextField extends StatefulWidget {
  final String labelText;
  final TimeOfDay initialValue;
  final ValueChanged<TimeOfDay> onChanged;
  final FormFieldValidator validator;
  final Function onSaved;
  TimeTextField(
      {this.initialValue,
      this.labelText,
      this.onChanged,
      this.onSaved,
      this.validator});

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
      initialValue: _defaultValue,
      validator: widget.validator,
      onSaved: (TimeOfDay value) => widget.onSaved(value),
      //
      //

      builder: (FormFieldState<TimeOfDay> field) {
        if (Form.of(field.context).widget.autovalidate) {
          field.validate();
        }
        // Draw Widget From here
        return new InputDecorator(
          decoration: new InputDecoration(
              errorText: field.errorText,
              labelText: widget.labelText,
              border: InputBorder.none),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(2.0),
                child: new RaisedButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(5.0)),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    selectTime(context, field, initialTime: _defaultValue);
                  },
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Icon(Icons.access_time),
                      new Padding(
                        padding: EdgeInsets.only(right: 10.0),
                      ),
                      new Text(FormHelper.timetoString(field.value)),
                    ],
                  ),
                ),
              ),
              // new GestureDetector(
              //   child: new Icon(Icons.add_circle_outline),
              //   onTap: () => _timeIncrement(field),
              // ),
              // new GestureDetector(
              //   child: new Icon(Icons.remove_circle_outline),
              //   onTap: () => _timeDecrement(field),
              // ),
              new Dismissible(
                key: new ValueKey(field.value),
                resizeDuration: null,
                direction: DismissDirection.vertical,
                onDismissed: (DismissDirection direction) {
                  setState(() {
                    direction == DismissDirection.up
                        ? _timeIncrement(field)
                        : _timeDecrement(field);
                  });
                },
                child: new Container(
                    color: Theme.of(context).accentColor,
                    child: new Column(
                      children: <Widget>[
                        new Icon(Icons.add),
                        new Icon(Icons.remove),
                      ],
                    )),
              ),
            ],
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

  _timeIncrement(FormFieldState<TimeOfDay> field) {
    TimeOfDay oldValue = field.value;
    int hr = oldValue.hour;
    int min = oldValue.minute;
    if (min < 60) {
      min += 1;
    } else {
      hr += 1;
      min = 0;
    }
    TimeOfDay newValue = TimeOfDay(hour: hr, minute: min);
    setState(
      () {
        _defaultValue = newValue;
        field.didChange(newValue);
      },
    );
  }

  _timeDecrement(FormFieldState<TimeOfDay> field) {
    TimeOfDay oldValue = field.value;
    int hr = oldValue.hour;
    int min = oldValue.minute;
    if (min == 0) {
      min = 59;
      hr -= 1;
    } else {
      min -= 1;
    }
    TimeOfDay newValue = TimeOfDay(hour: hr, minute: min);
    setState(
      () {
        _defaultValue = newValue;
        field.didChange(newValue);
      },
    );
  }
}
