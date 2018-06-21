part of nixon_app;

class ViewService extends StatefulWidget {
  @override
  _ViewServiceState createState() => new _ViewServiceState();
}

class _ViewServiceState extends State<ViewService>
//with AutomaticKeepAliveClientMixin
{
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<InspectionModel>(
      builder: (context, _, model) => new ListView(
            children: <Widget>[
              new ExpansionContainer(
                  name: TranslateHelper.translate('grooming'),
                  children: <Widget>[
                    makeSliderWidget(
                      initialValue: model.form.grooming.groomingScore,
                      labelText: TranslateHelper.translate('groomingScore'),
                      onChanged: (value) {
                        setState(() {
                          model.form.grooming.groomingScore = value;
                        });
                      },
                    ),
                    makeSliderWidget(
                      initialValue: model.form.grooming.hairScore,
                      labelText: TranslateHelper.translate('hairScore'),
                      onChanged: (value) {
                        setState(() {
                          model.form.grooming.hairScore = value;
                        });
                      },
                    ),
                    makeSliderWidget(
                      initialValue: model.form.grooming.uniformScore,
                      labelText: TranslateHelper.translate('uniformScore'),
                      onChanged: (value) {
                        setState(() {
                          model.form.grooming.uniformScore = value;
                        });
                      },
                    ),
                    makeSliderWidget(
                      initialValue: model.form.grooming.decorationScore,
                      labelText: TranslateHelper.translate('decorationScore'),
                      onChanged: (value) {
                        setState(() {
                          model.form.grooming.decorationScore = value;
                        });
                      },
                    ),
                    makeSliderWidget(
                      initialValue: model.form.grooming.maskWearScore,
                      labelText: TranslateHelper.translate('maskWearScore'),
                      onChanged: (value) {
                        setState(() {
                          model.form.grooming.maskWearScore = value;
                        });
                      },
                    ),
                    makeSliderWidget(
                      initialValue: model.form.grooming.maskCleanScore,
                      labelText: TranslateHelper.translate('maskCleanScore'),
                      onChanged: (value) {
                        setState(() {
                          model.form.grooming.maskCleanScore = value;
                        });
                      },
                    )
                  ]),
              new ExpansionContainer(
                name: TranslateHelper.translate('behavior'),
                children: <Widget>[
                  makeSliderWidget(
                    initialValue: model.form.behavior.behaviorScore,
                    labelText: TranslateHelper.translate('behaviorScore'),
                    onChanged: (value) {
                      setState(() {
                        model.form.behavior.behaviorScore = value;
                      });
                    },
                  ),
                  makeSliderWidget(
                    initialValue: model.form.behavior.mindScore,
                    labelText: TranslateHelper.translate('mindScore'),
                    onChanged: (value) {
                      setState(() {
                        model.form.behavior.mindScore = value;
                      });
                    },
                  ),
                ],
              ),
              new ExpansionContainer(
                  name: TranslateHelper.translate(
                    'serveCust',
                  ),
                  children: [
                    makeSliderWidget(
                      initialValue: model.form.serveCust.smileScore,
                      labelText: TranslateHelper.translate('smileScore'),
                      onChanged: (value) {
                        setState(() {
                          model.form.serveCust.smileScore = value;
                        });
                      },
                    ),
                    makeSliderWidget(
                      initialValue: model.form.serveCust.greetingScore,
                      labelText: TranslateHelper.translate('greetingScore'),
                      onChanged: (value) {
                        setState(() {
                          model.form.serveCust.greetingScore = value;
                        });
                      },
                    ),
                  ]),
              new ExpansionContainer(
                  name: TranslateHelper.translate('listenCust'),
                  children: [
                    makeSliderWidget(
                      initialValue: model.form.listenCust.listenCustScore,
                      labelText: TranslateHelper.translate('listenCustScore'),
                      onChanged: (value) {
                        setState(() {
                          model.form.listenCust.listenCustScore = value;
                        });
                      },
                    ),
                  ]),
              new ExpansionContainer(
                  name: TranslateHelper.translate('handleCust'),
                  children: [
                    makeSliderWidget(
                      initialValue: model.form.handleCust.indicateWithPalmScore,
                      labelText:
                          TranslateHelper.translate('indicateWithPalmScore'),
                      onChanged: (value) {
                        setState(() {
                          model.form.handleCust.indicateWithPalmScore = value;
                        });
                      },
                    ),
                    makeSliderWidget(
                      initialValue: model.form.handleCust.respondCustNeedScore,
                      labelText:
                          TranslateHelper.translate('respondCustNeedScore'),
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
                          TranslateHelper.translate('unexpectedSituationScore'),
                      onChanged: (value) {
                        setState(() {
                          model.form.handleCust.unexpectedSituationScore =
                              value;
                        });
                      },
                    ),
                  ]),
              new ExpansionContainer(
                  name: TranslateHelper.translate('farewellScore'),
                  children: [
                    makeSliderWidget(
                      initialValue: model.form.closure.farewellScore,
                      labelText: TranslateHelper.translate('farewellScore'),
                      onChanged: (value) {
                        setState(() {
                          model.form.closure.farewellScore = value;
                        });
                      },
                    ),
                  ]),
              new ExpansionContainer(
                  name: TranslateHelper.translate('communicationSkill'),
                  children: [
                    makeSliderWidget(
                      initialValue: model.form.communicationSkill.soundLevel,
                      labelText: TranslateHelper.translate('soundLevel'),
                      onChanged: (value) {
                        setState(() {
                          model.form.communicationSkill.soundLevel = value;
                        });
                      },
                    ),
                    makeSliderWidget(
                      initialValue: model.form.communicationSkill.soundSpeed,
                      labelText: TranslateHelper.translate('soundSpeed'),
                      onChanged: (value) {
                        setState(() {
                          model.form.communicationSkill.soundSpeed = value;
                        });
                      },
                    ),
                    makeSliderWidget(
                      initialValue: model.form.communicationSkill.polite,
                      labelText: TranslateHelper.translate('polite'),
                      onChanged: (value) {
                        setState(() {
                          model.form.communicationSkill.polite = value;
                        });
                      },
                    ),
                    makeSliderWidget(
                      initialValue: model.form.communicationSkill.attitudeScore,
                      labelText: TranslateHelper.translate('attitudeScore'),
                      onChanged: (value) {
                        setState(() {
                          model.form.communicationSkill.attitudeScore = value;
                        });
                      },
                    ),
                    makeSliderWidget(
                      initialValue: model.form.communicationSkill.skillScore,
                      labelText: TranslateHelper.translate('skillScore'),
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
                  labelText: TranslateHelper.translate('warmHeartScore'),
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
