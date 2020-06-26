import 'package:covid19_app/pages/dashboard.dart';
import 'package:covid19_app/repositories/data_repo.dart';
import 'package:covid19_app/services/api.dart';
import 'package:covid19_app/services/api_service.dart';
import 'package:covid19_app/services/data_cache_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp(
    sharedPreferences: sharedPreferences,
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({Key key, this.sharedPreferences}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Provider<DataRepository>(
      create: (_) => DataRepository(
          dataCacheService:
              DataCacheService(sharedPreferences: sharedPreferences),
          apiService: APIService(api: API.sandbox())),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          appBarTheme: AppBarTheme(color: Colors.purple),
          scaffoldBackgroundColor: Colors.black,
        ),
        home: Dashboard(),
      ),
    );
  }
}
