// To parse this JSON data, do
//
//     final vinModel = vinModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

VinModel vinModelFromJson(String str) => VinModel.fromJson(json.decode(str));


class VinModel {
  final int count;
  final String message;
  final String searchCriteria;
  final List<Result> results;

  VinModel({
    required this.count,
    required this.message,
    required this.searchCriteria,
    required this.results,
  });

  factory VinModel.fromJson(Map<String, dynamic> json) => VinModel(
    count: json["Count"],
    message: json["Message"].toString(),
    searchCriteria: json["SearchCriteria"].toString(),
    results: List<Result>.from(json["Results"].map((x) => Result.fromJson(x))),
  );


}

class Result {
  final String value;
  final String valueId;
  final String variable;
  final int variableId;

  Result({
    required this.value,
    required this.valueId,
    required this.variable,
    required this.variableId,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    value: json["Value"].toString(),
    valueId: json["ValueId"].toString(),
    variable: json["Variable"].toString(),
    variableId: json["VariableId"],
  );


}
