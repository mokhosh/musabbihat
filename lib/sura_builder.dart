import 'package:flutter/cupertino.dart';
import 'suras.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SuraBuilder {
  static List<Widget> build() {
    return suras
        .map(
          (sura) => ListView(
            padding: EdgeInsets.all(12),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: SvgPicture.asset('assets/besmele.svg'),
              ),
              Text(
                sura['text'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                ),
              ),
              SizedBox(
                height: 64,
              ),
            ],
          ),
        )
        .toList();
  }
}
