part of nixon_app;

class ViewService extends StatefulWidget {
  @override
  _ViewServiceState createState() => new _ViewServiceState();
}

class _ViewServiceState extends State<ViewService>
//ith AutomaticKeepAliveClientMixin
{
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<InspectionModel>(
      builder: (context, _, model) => new ListView(
            children: <Widget>[
              new ExpansionContainer(name: Inspection.translate('grooming'),
                  //padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                  children: <Widget>[
                    makeSliderWidget(
                      initialValue: model.form.grooming.groomingScore,
                      labelText: Inspection.translate('groomingScore'),
                      onChanged: (value) {
                        setState(() {
                          model.form.grooming.groomingScore = value;
                        });
                      },
                    ),
                    makeSliderWidget(
                      initialValue: model.form.grooming.hairScore,
                      labelText: Inspection.translate('hairScore'),
                      onChanged: (value) {
                        setState(() {
                          model.form.grooming.hairScore = value;
                        });
                      },
                    ),
                    makeSliderWidget(
                      initialValue: model.form.grooming.uniformScore,
                      labelText: Inspection.translate('uniformScore'),
                      onChanged: (value) {
                        setState(() {
                          model.form.grooming.uniformScore = value;
                        });
                      },
                    ),
                    makeSliderWidget(
                      initialValue: model.form.grooming.decorationScore,
                      labelText: Inspection.translate('decorationScore'),
                      onChanged: (value) {
                        setState(() {
                          model.form.grooming.decorationScore = value;
                        });
                      },
                    ),
                    makeSliderWidget(
                      initialValue: model.form.grooming.maskWearScore,
                      labelText: Inspection.translate('maskWearScore'),
                      onChanged: (value) {
                        setState(() {
                          model.form.grooming.maskWearScore = value;
                        });
                      },
                    ),
                    makeSliderWidget(
                      initialValue: model.form.grooming.maskCleanScore,
                      labelText: Inspection.translate('maskCleanScore'),
                      onChanged: (value) {
                        setState(() {
                          model.form.grooming.maskCleanScore = value;
                        });
                      },
                    )
                  ]),
              new ExpansionContainer(
                name: Inspection.translate('behavior'),
                children: <Widget>[
                  makeSliderWidget(
                    initialValue: model.form.behavior.behaviorScore,
                    labelText: Inspection.translate('behaviorScore'),
                    onChanged: (value) {
                      setState(() {
                        model.form.behavior.behaviorScore = value;
                      });
                    },
                  ),
                  makeSliderWidget(
                    initialValue: model.form.behavior.mindScore,
                    labelText: Inspection.translate('mindScore'),
                    onChanged: (value) {
                      setState(() {
                        model.form.behavior.mindScore = value;
                      });
                    },
                  ),
                ],
              ),
              new ExpansionContainer(
                  name: Inspection.translate(
                    'serveCust',
                  ),
                  children: [
                    makeSliderWidget(
                      initialValue: model.form.serveCust.smileScore,
                      labelText: Inspection.translate('smileScore'),
                      onChanged: (value) {
                        setState(() {
                          model.form.serveCust.smileScore = value;
                        });
                      },
                    ),
                    makeSliderWidget(
                      initialValue: model.form.serveCust.greetingScore,
                      labelText: Inspection.translate('greetingScore'),
                      onChanged: (value) {
                        setState(() {
                          model.form.serveCust.greetingScore = value;
                        });
                      },
                    ),
                  ]),
              new ExpansionContainer(
                  name: Inspection.translate('listenCust'),
                  children: [
                    makeSliderWidget(
                      initialValue: model.form.listenCust.listenCustScore,
                      labelText: Inspection.translate('listenCustScore'),
                      onChanged: (value) {
                        setState(() {
                          model.form.listenCust.listenCustScore = value;
                        });
                      },
                    ),
                  ]),
              new ExpansionContainer(
                  name: Inspection.translate('handleCust'),
                  children: [
                    makeSliderWidget(
                      initialValue: model.form.handleCust.indicateWithPalmScore,
                      labelText: Inspection.translate('indicateWithPalmScore'),
                      onChanged: (value) {
                        setState(() {
                          model.form.handleCust.indicateWithPalmScore = value;
                        });
                      },
                    ),
                    makeSliderWidget(
                      initialValue: model.form.handleCust.respondCustNeedScore,
                      labelText: Inspection.translate('respondCustNeedScore'),
                      onChanged: (value) {
                        setState(() {
                          model.form.handleCust.respondCustNeedScore = value;
                        });
                      },
                    ),
                    makeSliderWidget(
                      initialValue:
                          model.form.handleCust.unexpectedSituationScore,
                      labelText:
                          Inspection.translate('unexpectedSituationScore'),
                      onChanged: (value) {
                        setState(() {
                          model.form.handleCust.unexpectedSituationScore =
                              value;
                        });
                      },
                    ),
                  ]),
              new ExpansionContainer(
                  name: Inspection.translate('farewellScore'),
                  children: [
                    makeSliderWidget(
                      initialValue: model.form.closure.farewellScore,
                      labelText: Inspection.translate('farewellScore'),
                      onChanged: (value) {
                        setState(() {
                          model.form.closure.farewellScore = value;
                        });
                      },
                    ),
                  ]),
              new ExpansionContainer(
                  name: Inspection.translate('communicationSkill'),
                  children: [
                    makeSliderWidget(
                      initialValue: model.form.communicationSkill.soundLevel,
                      labelText: Inspection.translate('soundLevel'),
                      onChanged: (value) {
                        setState(() {
                          model.form.communicationSkill.soundLevel = value;
                        });
                      },
                    ),
                    makeSliderWidget(
                      initialValue: model.form.communicationSkill.soundSpeed,
                      labelText: Inspection.translate('soundSpeed'),
                      onChanged: (value) {
                        setState(() {
                          model.form.communicationSkill.soundSpeed = value;
                        });
                      },
                    ),
                    makeSliderWidget(
                      initialValue: model.form.communicationSkill.polite,
                      labelText: Inspection.translate('polite'),
                      onChanged: (value) {
                        setState(() {
                          model.form.communicationSkill.polite = value;
                        });
                      },
                    ),
                    makeSliderWidget(
                      initialValue: model.form.communicationSkill.attitudeScore,
                      labelText: Inspection.translate('attitudeScore'),
                      onChanged: (value) {
                        setState(() {
                          model.form.communicationSkill.attitudeScore = value;
                        });
                      },
                    ),
                    makeSliderWidget(
                      initialValue: model.form.communicationSkill.skillScore,
                      labelText: Inspection.translate('skillScore'),
                      onChanged: (value) {
                        setState(() {
                          model.form.communicationSkill.skillScore = value;
                        });
                      },
                    ),
                  ]),
              new ExpansionContainer(name: '窩心', children: [
                makeSwitchWidget(
                  initialValue: model.form.warmHeart.warmHeartScore,
                  labelText: Inspection.translate('warmHeartScore'),
                  onChanged: (value) {
                    setState(() {
                      model.form.warmHeart.warmHeartScore = value;
                    });
                  },
                ),
              ])
            ],
          ),
    );
  }

  // TODO: implement wantKeepAlive
  // @override
  // bool get wantKeepAlive => true;
}
