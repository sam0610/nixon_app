part of nixon_app;

class MyFormTextField extends StatefulWidget {
  MyFormTextField(
      {this.labelText,
      this.initialValue,
      this.onSave,
      @required this.controller,
      this.maxLines = 1,
      this.nullable = true,
      this.keyboardType = TextInputType.text});
  final String labelText;
  final TextEditingController controller;
  final Function onSave;
  final String initialValue;
  final int maxLines;
  final bool nullable;
  final TextInputType keyboardType;

  @override
  _MyFormTextFieldState createState() => new _MyFormTextFieldState();
}

class _MyFormTextFieldState extends State<MyFormTextField> {
  @override
  void initState() {
    super.initState();
    if (widget.controller != null)
      widget.controller.text.isEmpty
          ? widget.controller.text = widget.initialValue
          : '';
  }

  @override
  Widget build(BuildContext context) {
    return new TextFormField(
      style: Theme.of(context).textTheme.body2,
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        labelText: widget.labelText,
      ),
      controller: widget.controller,
      onFieldSubmitted: (value) => widget.controller.text = value,
      validator: (value) => widget.nullable == false && value.isEmpty
          ? '${widget.labelText} can\'t be empty'
          : null,
      onSaved: widget.onSave,
    );
  }
}
