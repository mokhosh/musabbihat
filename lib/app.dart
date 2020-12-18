import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tasbeeh/database.dart';
import 'package:provider/provider.dart';

import 'homepage.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<MyDatabase>(
      create: (_) => MyDatabase(),
      dispose: (_, db) => db.close(),
      child: MaterialApp(
        title: 'مسبحات',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          fontFamily: 'Uthman',
        ),
        home: MyHomePage(),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          Locale("fa", "IR"),
        ],
        locale: Locale("fa", "IR"),
      ),
    );
  }
}