part of nixon_app;

//http://sammobile.azurewebsites.net/api/Staff/bldg/212702/2018-05-28
//

class BuildingData {
  String accBuildingCode;
  String buildingName;

  BuildingData({this.accBuildingCode, this.buildingName});

  factory BuildingData.fromJson(Map<String, dynamic> json) {
    return new BuildingData(
        accBuildingCode: json['accBuildingCode'],
        buildingName: json['buildingName']);
  }
}

Future<List<BuildingData>> fetchBldgList(http.Client client) async {
  var urlList = "http://sammobile.azurewebsites.net/api/BuildingData/r/NK1H";
  final response = await client.get(urlList);
  print(response.body.toString());
  return compute(parseBldgs, response.body);
}

List<BuildingData> parseBldgs(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed
      .map<BuildingData>((json) => new BuildingData.fromJson(json))
      .toList();
}
