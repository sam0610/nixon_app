import 'package:flutter/material.dart';
import 'package:nixon_app/Helper/formHelper.dart';

class DateTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String initialValue;
  final Function onSave;
  DateTextField(
      {this.controller, this.initialValue, this.labelText, this.onSave});

  @override
  _DateTextFieldState createState() => new _DateTextFieldState();
}

class _DateTextFieldState extends State<DateTextField> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.controller.text = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return new Row(children: [
      new Expanded(
        child: new TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            labelText: widget.labelText,
          ),
          keyboardType: TextInputType.datetime,
          validator: (value) =>
              value.isEmpty ? '${widget.labelText} can\'t be empty' : null,
          onSaved: widget.onSave,
        ),
      ),
      new IconButton(
        icon: new Icon(Icons.arrow_drop_down),
        onPressed: () => selectDate(context),
      )
    ]);
  }

  selectDate(BuildContext context) async {
    final DateTime picked = await FormHelper.selectDateDialog(ctx: context);
    if (picked != null) {
      setState(
        () {
          widget.controller.text = FormHelper.datetoString(picked);
        },
      );
    }
  }
}
