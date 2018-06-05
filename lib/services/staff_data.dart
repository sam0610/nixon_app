part of nixon_app;

//http://sammobile.azurewebsites.net/api/Staff/bldg/212702/2018-05-28
//

class StaffData {
  int nixonNumber;
  String englishName;
  String givenName;

  StaffData({this.nixonNumber, this.englishName, this.givenName});

  factory StaffData.fromJson(Map<String, dynamic> json) {
    return new StaffData(
        nixonNumber: json['nixonNumber'],
        englishName: json['englishName'],
        givenName: json['givenName']);
  }
}

Future<List<StaffData>> fetchStaffList(http.Client client, String bldgCode,
    {DateTime date}) async {
  assert(bldgCode.isNotEmpty);

  if (date == null) date = DateTime.now();

  String dateStr = DateFormat("yyyy-MM-dd").format(date);

  var urlList =
      'http://sammobile.azurewebsites.net/api/Staff/bldg/$bldgCode/$dateStr/l';
  final response = await client.get(urlList);
  return compute(parseStaff, response.body);
}

List<StaffData> parseStaff(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<StaffData>((json) => new StaffData.fromJson(json)).toList();
}
