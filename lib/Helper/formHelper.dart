import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormHelper {
  static String formatDate(DateTime value) {
    return new DateFormat("yyyy.MM.dd").format(value);
  }

  static Future<Null> showAlertDialog(
      BuildContext context, String title, String message) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(title),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<DateTime> selectDateDialog(
      {BuildContext ctx, DateTime firstDate, initialDate, lastDate}) async {
    final DateTime picked = await showDatePicker(
      context: ctx,
      firstDate: firstDate ?? DateTime.now(),
      initialDate: initialDate ?? DateTime.now(),
      lastDate: lastDate ?? DateTime.now(),
    );
    if (picked != null) {
      return picked;
    }
    return null;
  }
}
