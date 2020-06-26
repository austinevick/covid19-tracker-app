import 'package:flutter/cupertino.dart';

class EndpointData {
  final int value;
  final DateTime date;

  EndpointData({@required this.value, this.date}):assert(value != null);

  @override
  String toString() =>'date: $date, value: $value';
}