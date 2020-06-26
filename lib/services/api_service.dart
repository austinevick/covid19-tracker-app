import 'dart:convert';

import 'package:covid19_app/services/api.dart';
import 'package:covid19_app/services/endpoint_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class APIService {
  final API api;
  APIService({this.api});

  Future<String> getAccessToken() async {
    final response = await http.post(api.tokenUri().toString(),
        headers: {'Authorization': 'Basic ${api.apiKey}'});
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final accessToken = data['access_token'];
      if (accessToken != null) {
        return accessToken;
      }
    }
    print('${response.statusCode} ${response.reasonPhrase}');
    throw response;
  }

  Future<EndpointData> getEndpointData({
      @required String accessToken, @required Endpoint endpoint}) async {
    final uri = api.endpointUri(endpoint);
    final response = await http
        .get(uri.toString(), headers: {'Authorization': 'Bearer $accessToken'});
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        final Map<String, dynamic> endpointData = data[0];
        final String _response = jsonKey[endpoint];
        final int value = endpointData[_response];
        final String dateString = endpointData['date'];
        final date = DateTime.tryParse(dateString);
        if (value != null) {
          return EndpointData(value: value,date: date);
        }
      }
    }
    print('${response.statusCode} ${response.reasonPhrase}');
    throw response;
  }

  static Map<Endpoint, String> jsonKey = {
    Endpoint.cases: 'cases',
    Endpoint.casesSuspected: 'data',
    Endpoint.casesConfirmed: 'data',
    Endpoint.deaths: 'data',
    Endpoint.recovered: 'data'
  };
}
