import 'package:covid19_app/services/api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class EndpointCardData {
  final String title;
  final String assetName;
  final Color color;

  EndpointCardData({this.title, this.assetName, this.color});
}


class EndpointCard extends StatelessWidget {
  final Endpoint endpoint;
  final int value;

  const EndpointCard({Key key, this.value, this.endpoint}) : super(key: key);

  static Map<Endpoint, EndpointCardData> _cardTilesData = {
    Endpoint.cases: EndpointCardData(title: 'Cases',assetName: 'assets/count.png',color: Colors.yellow),
    Endpoint.casesSuspected: EndpointCardData(title: 'Suspected cases',assetName: 'assets/suspect.png',color: Colors.yellow.shade800),
    Endpoint.casesConfirmed: EndpointCardData(title: 'Confirmed cases',assetName: 'assets/fever.png',color: Colors.yellow.shade900),
    Endpoint.deaths: EndpointCardData(title: 'Deaths',assetName: 'assets/death.png',color: Colors.red),
    Endpoint.recovered: EndpointCardData(title: 'Recovered',assetName: 'assets/patient.png',color: Colors.green)
  };
String get formattedValue{
  if (value == null) {
    return '';
  }
  return NumberFormat('#,###,###,###').format(value);
}



  @override
  Widget build(BuildContext context) {
    final cardData =   _cardTilesData[endpoint];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                Text(
                  cardData.title,
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          color: cardData.color,
                        ),
                  ),
                  SizedBox(height: 4,),
              SizedBox(height: 52,
                              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(cardData.assetName,color: cardData.color,),
                  
                    Text(
                     formattedValue,
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          .copyWith(color: cardData.color,),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
