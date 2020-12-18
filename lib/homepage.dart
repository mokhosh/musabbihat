import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moor/moor.dart';
import 'package:tasbeeh/database.dart';
import 'package:provider/provider.dart';

import 'sura_builder.dart';
import 'suras.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String title = 'حديد';
  Widget fab;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: NotificationListener<ScrollEndNotification>(
        onNotification: scrollChanged,
        child: PageView(
          onPageChanged: (index) {
            setState(() {
              title = suras[index]['name'];
            });
          },
          children: SuraBuilder.build(),
        ),
      ),
      floatingActionButton: fab,
    );
  }

  void commitRecitationDone() {
    final weekdays = [
      '۱شنبه',
      '۲شنبه',
      '۳شنبه',
      '۴شنبه',
      '۵شنبه',
      'جمعه',
      'شنبه'
    ];
    final database = Provider.of<MyDatabase>(context, listen: false);
    database.addRecitation(RecitationsCompanion(
      title: Value(title),
      date: Value(weekdays[DateTime.now().weekday]),
    ));
  }

  void showRecentRecitations() {
    final database = Provider.of<MyDatabase>(context, listen: false);
    showModalBottomSheet(
      context: context,
      builder: (context) => FutureBuilder(
        future: database.recentRecitations,
        builder: (context, AsyncSnapshot<List<Recitation>> snapshot) {
          final recitations = snapshot.data ?? List();

          return ListView.builder(
            itemCount: recitations.length,
            itemBuilder: (_, index) {
              final recitation = recitations[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 96,
                      child: Text(
                        recitation.date,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.indigoAccent,
                        ),
                      ),
                    ),
                    Text(
                      recitation.title,
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  bool scrollChanged(ScrollEndNotification notification) {
    //runtimeType.toString()
    //axis.toString()
    if (notification.metrics.axis.toString() == 'Axis.vertical' &&
        notification.metrics.pixels == notification.metrics.maxScrollExtent) {
      setState(() {
        fab = FloatingActionButton(
          tooltip: 'ثبت تلاوت',
          child: Icon(Icons.assignment_turned_in),
          backgroundColor: Colors.green,
          onPressed: commitRecitationDone,
        );
      });
    } else {
      setState(() {
        fab = FloatingActionButton(
          tooltip: 'تلاوت هاي قبل',
          child: Icon(Icons.history),
          backgroundColor: null,
          onPressed: showRecentRecitations,
        );
      });
    }
    return true;
  }
}
