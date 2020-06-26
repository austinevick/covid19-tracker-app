import 'package:covid19_app/api_key.dart';

enum Endpoint{
cases,
casesSuspected,
casesConfirmed,
deaths,
recovered
}



class API {
  String apiKey;
  API({this.apiKey});
  factory API.sandbox() {
    return API(apiKey: ApiKey.ncovApiKey);
  }

  static final String host = 'apigw.nubentos.com';
  static final int port = 443;
  static final String basePath = 't/nubentos.com/ncovapi/1.0.0';

  Uri tokenUri() {
    return Uri(
        scheme: 'https',
        host: host,
        port: port,
        path: 'token',
        queryParameters: {'grant_type': 'client_credentials'});
  }

Uri endpointUri(Endpoint endpoint){
  return Uri(
scheme: 'https',
host: host,
port: port,
path: '$basePath/${_paths[endpoint]}'
  );
}

static Map<Endpoint, String> _paths = {
Endpoint.cases: 'cases',
Endpoint.casesSuspected: 'cases/suspected',
Endpoint.casesConfirmed:'cases/confirmed',
Endpoint.deaths:'deaths',
Endpoint.recovered:'recovered'
};


}
