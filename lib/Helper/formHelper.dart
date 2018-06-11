part of nixon_app;

class FormHelper {
  static String datetoString(DateTime date) {
    try {
      String str = new DateFormat("yyyy.MM.dd").format(date);
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
      DateTime d = new DateFormat("yyyy.MM.dd").parseStrict(str);
      return d;
    } catch (e) {
      return null;
    }
  }

  static void showSnackBar(BuildContext context, String message,
      {Color bgColor = Colors.lightBlue}) {
    SnackBar bar = new SnackBar(
      content: new Text(message),
      duration: new Duration(seconds: 2),
      backgroundColor: bgColor,
    );
    Scaffold.of(context).showSnackBar(bar);
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

  static int strToInt(dynamic str) {
    try {
      var num = int.tryParse(str) ?? null;
      return num;
    } catch (e) {
      return null;
    }
  }

  static double calculate(Map<String, dynamic> object) {
    double count = 0.0;
    double sum = 0.0;
    bool incomplete = false;
    object.forEach((k, v) {
      if (v is int) {
        int value = v;
        if (value >= 20 && value <= 100) {
          count += 1.0;
          sum += v;
        } else if (value != -1) {
          incomplete = true;
        }
      } else {
        incomplete = true;
      }
    });
    if (incomplete) return -1.0;
    final double total = count == 0.0 ? 0.0 : sum / count;
    return total;
  }
}
