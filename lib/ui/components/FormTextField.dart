part of nixon_app;

class MyFormTextField extends StatefulWidget {
  MyFormTextField(
      {@required this.labelText,
      @required this.initialValue,
      this.onSave,
      @required this.onFieldSubmitted,
      //this.controller,
      this.maxLines = 1,
      this.nullable = true,
      this.keyboardType = TextInputType.text,
      this.focusNode});

  final String labelText;
  //final TextEditingController controller;
  final Function onSave;
  final ValueChanged<String> onFieldSubmitted;
  final String initialValue;
  final int maxLines;
  final bool nullable;
  final TextInputType keyboardType;
  final FocusNode focusNode;

  @override
  _MyFormTextFieldState createState() => new _MyFormTextFieldState();
}

class _MyFormTextFieldState extends State<MyFormTextField> {
  @override
  void initState() {
    super.initState();
    // if (widget.controller != null)
    //   widget.controller.text.isEmpty
    //       ? widget.controller.text = widget.initialValue
    //       : '';
  }

  @override
  Widget build(BuildContext context) {
    InspectionModel model = ModelFinder<InspectionModel>().of(context);
    return new TextFormField(
      style: new TextStyle(
        fontSize: 20.0,
        color: Colors.black,
      ),
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardType,
      focusNode: widget.focusNode,
      decoration: InputDecoration(
        labelText: widget.labelText,
      ),
      //controller: widget.controller,
      initialValue: widget.initialValue,
      validator: (value) => _validateField(widget.initialValue, value, model,
          nullable: widget.nullable),
      onFieldSubmitted: widget.onFieldSubmitted,
      onSaved: widget.onSave,
    );
  }
}
