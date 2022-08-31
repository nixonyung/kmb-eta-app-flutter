import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/generateFavoriteKey.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timer_builder/timer_builder.dart';

class RouteEtaItem extends HookWidget {
  final int index;
  final String route;
  final String bound;
  final String serviceType;
  final String stopId;
  final List<String> etaList;

  RouteEtaItem({
    Key? key,
    required this.index,
    required this.route,
    required this.bound,
    required this.serviceType,
    required this.stopId,
    required this.etaList,
  }) : super(key: key);

  final dataBox = Hive.box("data"); // use a box

  @override
  Widget build(BuildContext context) {
    final stopNameResult = useQuery(
      ['stop', stopId],
      () async => (await Dio()
              .get("https://data.etabus.gov.hk/v1/transport/kmb/stop/$stopId"))
          .data,
      refetchOnMount: RefetchOnMount.never,
    );

    if (stopNameResult.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (stopNameResult.isError) {
      return Text(stopNameResult.error!.toString());
    }

    return TimerBuilder.periodic(
      const Duration(seconds: 1),
      builder: (context) => ListTile(
        title: Text(stopNameResult.data!["data"]["name_tc"]),
        subtitle: etaList.isEmpty
            ? Text("No data")
            : Text.rich(
                TextSpan(
                  children: (etaList).mapIndexed(
                    (index, element) {
                      final eta = DateTime.parse(element);
                      final absDiffInDuration = DateTime.parse(element)
                          .difference(DateTime.now())
                          .abs();

                      if (eta.isAfter(DateTime.now())) {
                        return TextSpan(
                          text:
                              "${absDiffInDuration.inMinutes}m ${absDiffInDuration.inSeconds % 60}s${index == etaList.length - 1 ? "" : "\n"}",
                        );
                      } else {
                        return TextSpan(
                          text:
                              "-${absDiffInDuration.inMinutes}m ${absDiffInDuration.inSeconds % 60}s${index == etaList.length - 1 ? "" : "\n"}",
                          style: TextStyle(color: Colors.red),
                        );
                      }
                    },
                  ).toList(),
                ),
              ),
        trailing: ValueListenableBuilder<Box>(
          valueListenable: dataBox.listenable(),
          builder: (context, _box, widget) {
            final key = generateFavoriteKey(
              route: route,
              bound: bound,
              serviceType: serviceType,
              index: index,
              stopId: stopId,
            );

            return IconButton(
              icon: _box.containsKey(key)
                  ? Icon(Icons.star)
                  : Icon(Icons.star_outline),
              onPressed: () {
                if (_box.containsKey(key)) {
                  _box.delete(key);
                } else {
                  _box.put(key, 1);
                }
              },
            );
          },
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      ),
    );
  }
}
