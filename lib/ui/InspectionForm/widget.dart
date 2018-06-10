part of nixon_app;

Widget makeSwitchWidget(
    {@required String labelText,
    @required int initialValue,
    @required ValueChanged<int> onChanged}) {
  return new Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
      child: new CheckBoxFormField(
        initialValue: initialValue,
        validator: (value) => value == 0 ? '$labelText Not Set' : null,
        onSaved: (value) => print(value),
        labelText: labelText,
        onChanged: onChanged,
      ));
}

Widget makeSliderWidget(
    {@required String labelText,
    @required int initialValue,
    @required ValueChanged<int> onChanged(value)}) {
  return new Padding(
    padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
    child: new SliderFormField(
        initialValue: initialValue,
        validator: (value) => value == 0 ? '$labelText Not Set' : null,
        onSaved: (value) => print(value),
        labelText: labelText,
        onChanged: (value) => onChanged(value)),
  );
}

class ExpansionContainer extends StatefulWidget {
  ExpansionContainer({this.children, this.name});
  final List<Widget> children;
  final String name;

  @override
  _ExpansionContainerState createState() => _ExpansionContainerState();
}

class _ExpansionContainerState extends State<ExpansionContainer> {
  Widget buildTitle() {
    return new Row(children: <Widget>[
      new Container(
        margin: const EdgeInsets.only(left: 5.0),
        child: new FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: new Text(
            widget.name,
          ),
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
      child: new ExpansionTile(
        onExpansionChanged: (b) => setState(() {
              PageStorage
                  .of(context)
                  .writeState(context, b, identifier: ValueKey(widget.name));
            }),
        initiallyExpanded: PageStorage
                .of(context)
                .readState(context, identifier: ValueKey(widget.name)) ??
            false,
        title: buildTitle(),
        children: widget.children,
      ),
    );
  }
}
