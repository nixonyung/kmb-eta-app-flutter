import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/RouteEtaFavoriteItem.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Screen2 extends StatelessWidget {
  Screen2({Key? key}) : super(key: key);

  final dataBox = Hive.box("data");

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ValueListenableBuilder<Box>(
        valueListenable: Hive.box("data").listenable(),
        builder: (context, box, widget) => ListView.separated(
          itemCount: dataBox.keys.length,
          separatorBuilder: (context, index) => Divider(
            height: 8,
            thickness: 2,
          ),
          itemBuilder: (context, index) {
            final tokens = dataBox.keys.toList()[index].split("_");
            return RouteEtaFavoriteItem(
              route: tokens[0],
              bound: tokens[1],
              serviceType: tokens[2],
              index: int.parse(tokens[3]),
              stopId: tokens[4],
            );
          },
          // physics: ClampingScrollPhysics(),
        ),
      ),
    );
  }
}
