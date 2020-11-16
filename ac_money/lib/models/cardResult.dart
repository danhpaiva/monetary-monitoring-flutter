class CardResult {
  String maxValue;
  String minValue;
  String createDate;

  CardResult();

  CardResult.fromJson(Map<String, dynamic> json)
      : maxValue = json['high'],
        minValue = json['low'],
        createDate = json['create_date'];
}
