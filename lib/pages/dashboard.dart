import 'dart:io';

import 'package:covid19_app/pages/endpoint_card.dart';
import 'package:covid19_app/pages/last_updated_date.dart';
import 'package:covid19_app/pages/show_alert_dialog.dart';
import 'package:covid19_app/repositories/data_repo.dart';
import 'package:covid19_app/repositories/endpoints_data.dart';
import 'package:covid19_app/services/api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  EndpointsData _endpointsData;

  Future<void> updataData() async {
    try {
      final dataRepository =
          Provider.of<DataRepository>(context, listen: false);
      final endpointsData = await dataRepository.getAllEndpointData();
      setState(() {
        _endpointsData = endpointsData;
      });
    } on SocketException catch (_) {
      showAlertDialog(
          context: context,
          title: 'Connection Error',
          content: 'Could not retrieve data, Please try again later',
          defaultActionText: 'OK');
    }catch(_){
       showAlertDialog(
          context: context,
          title: 'Unknown Error',
          content: 'Please contact support or try again later',
          defaultActionText: 'OK');
    }
  }

  @override
  void initState() {
    final dataRepository = Provider.of<DataRepository>(context,listen: false);
    _endpointsData = dataRepository.getAllEndpointsCachedData();
    updataData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formatter = LastUpdatedDateFormatter(
        lastUpdated: _endpointsData != null
            ? _endpointsData.values[Endpoint.cases]?.date
            : null);
    return Scaffold(
      appBar: AppBar(
        
        centerTitle: true,
        title: Text('Coronavirus Tracker'),
      ),
      body: RefreshIndicator(
        onRefresh: updataData,
        child: ListView(
          children: <Widget>[
            LastUpdatedDateStatus(
              text: formatter.lastUpdatedStatusText(),
            ),
            Center(child: Text('Global Record',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800),)),
            for (var endpoint in Endpoint.values)
              EndpointCard(
                endpoint: endpoint,
                value: _endpointsData != null
                    ? _endpointsData.values[endpoint]?.value
                    : null,
              )
          ],
        ),
      ),
    );
  }
}
