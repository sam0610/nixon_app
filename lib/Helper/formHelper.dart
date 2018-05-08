import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormHelper {
  static String datetoString(DateTime date) {
    try {
      String str = new DateFormat.yMd().format(date);
      return str;
    } catch (e) {
      return null;
    }
  }

  static String timetoString(TimeOfDay time) {
    try {
      String strHr = time.hour < 10
          ? '0${time.hour.toString()}'
          : '${time.hour.toString()}';
      String strMin = time.minute < 10
          ? '0${time.minute.toString()}'
          : '${time.minute.toString()}';
      return '$strHr:$strMin';
    } catch (e) {
      return null;
    }
  }

  static TimeOfDay strToTime(String str) {
    try {
      var colonIndex = str.indexOf(':');
      int hr = int.parse(str.substring(0, colonIndex));
      var strmin = str.substring(colonIndex + 1);
      int min = int.parse(strmin);
      TimeOfDay t = new TimeOfDay(hour: hr, minute: min);
      return t;
    } catch (e) {
      return null;
    }
  }

  static DateTime strToDate(String str) {
    try {
      DateTime d = new DateFormat.yMd().parseStrict(str);
      return d;
    } catch (e) {
      return null;
    }
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
      firstDate: firstDate ?? new DateTime(DateTime.now().year - 1),
      initialDate: initialDate ?? DateTime.now(),
      lastDate: lastDate ?? DateTime.now(),
    );
    if (picked != null) {
      return picked;
    }
    return null;
  }

  static Future<TimeOfDay> selectTimeDialog(
      {BuildContext ctx, TimeOfDay initialTime}) async {
    final TimeOfDay picked = await showTimePicker(
      context: ctx,
      initialTime: initialTime ?? new TimeOfDay.now(),
    );
    if (picked != null) {
      return picked;
    }
    return null;
  }
}
