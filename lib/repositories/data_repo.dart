import 'package:covid19_app/repositories/endpoints_data.dart';
import 'package:covid19_app/services/api.dart';
import 'package:covid19_app/services/api_service.dart';
import 'package:covid19_app/services/data_cache_service.dart';
import 'package:covid19_app/services/endpoint_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class DataRepository {
  final APIService apiService;
  final DataCacheService dataCacheService;

  DataRepository({@required this.apiService, @required this.dataCacheService});
  String _accessToken;

  Future<EndpointData> getEndpointData(Endpoint endpoint) async =>
      await getDataRefreshingToken<EndpointData>(
        onGetData: () => apiService.getEndpointData(
            accessToken: _accessToken, endpoint: endpoint),
      );

      EndpointsData getAllEndpointsCachedData()=> dataCacheService.getData();

  Future<EndpointsData> getAllEndpointData() async {
     final endpointsData = await getDataRefreshingToken<EndpointsData>(
        onGetData: () => _getAllEndpointData(),
      );
      await dataCacheService.setData(endpointsData);
      return endpointsData;
      }

  Future<T> getDataRefreshingToken<T>({Future<T> Function() onGetData}) async {
    try {
      if (_accessToken == null) {
        _accessToken = await apiService.getAccessToken();
      }
      return await onGetData();
    } on Response catch (response) {
      if (response.statusCode == 401) {
        _accessToken = await apiService.getAccessToken();
        return await onGetData();
      }
      rethrow;
    }
  }

  Future<EndpointsData> _getAllEndpointData() async {
    final values = await Future.wait([
      apiService.getEndpointData(
          accessToken: _accessToken, endpoint: Endpoint.cases),
      apiService.getEndpointData(
          accessToken: _accessToken, endpoint: Endpoint.casesSuspected),
      apiService.getEndpointData(
          accessToken: _accessToken, endpoint: Endpoint.casesConfirmed),
      apiService.getEndpointData(
          accessToken: _accessToken, endpoint: Endpoint.deaths),
      apiService.getEndpointData(
          accessToken: _accessToken, endpoint: Endpoint.recovered),
    ]);
    return EndpointsData(values: {
      Endpoint.cases: values[0],
      Endpoint.casesSuspected: values[1],
      Endpoint.casesConfirmed: values[2],
      Endpoint.deaths: values[3],
      Endpoint.recovered: values[4]
    });
  }
}
