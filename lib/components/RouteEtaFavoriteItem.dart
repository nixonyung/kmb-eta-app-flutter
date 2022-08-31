import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/generateFavoriteKey.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timer_builder/timer_builder.dart';

class RouteEtaFavoriteItem extends HookWidget {
  final String route;
  final String bound;
  final String serviceType;
  final int index;
  final String stopId;

  RouteEtaFavoriteItem({
    Key? key,
    required this.route,
    required this.bound,
    required this.serviceType,
    required this.index,
    required this.stopId,
  }) : super(key: key);

  final dataBox = Hive.box("data"); // use a box

  @override
  Widget build(BuildContext context) {
    final routeInfoResult = useQuery(
      ['route', route, bound, serviceType],
      () async => (await Dio().get(
              "https://data.etabus.gov.hk/v1/transport/kmb/route/$route/${bound == "I" ? "inbound" : "outbound"}/$serviceType"))
          .data,
      refetchOnMount: RefetchOnMount.never,
    );

    final etaListResult = useQuery(
      ['route-eta', route, serviceType],
      () async => (await Dio().get(
              "https://data.etabus.gov.hk/v1/transport/kmb/route-eta/$route/$serviceType"))
          .data,
      refetchInterval: Duration(seconds: 5),
      refetchOnMount: RefetchOnMount.always,
    );

    final stopNameResult = useQuery(
      ['stop', stopId],
      () async => (await Dio()
              .get("https://data.etabus.gov.hk/v1/transport/kmb/stop/$stopId"))
          .data,
      refetchOnMount: RefetchOnMount.never,
    );

    if (routeInfoResult.isLoading ||
        etaListResult.isLoading ||
        stopNameResult.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (routeInfoResult.isError) {
      return Text(routeInfoResult.error!.toString());
    }
    if (etaListResult.isError) {
      return Text(stopNameResult.error!.toString());
    }
    if (stopNameResult.isError) {
      return Text(stopNameResult.error!.toString());
    }

    final etaLists = groupBy(
      etaListResult.data!["data"],
      (p0) => (p0 as Map)["seq"],
    )
        .map(
          (key, value) => (MapEntry(
            key,
            value
                .where(
                  (element) =>
                      (element as Map)["dir"] == bound &&
                      (element)["eta"] != null,
                )
                .map(
                  (e) => (e as Map)["eta"] as String,
                )
                .toList(),
          )),
        )
        .values
        .toList();

    final etaList = etaLists[index];

    return TimerBuilder.periodic(
      const Duration(seconds: 1),
      builder: (context) => ListTile(
        title: Text(
            "$route  往  ${routeInfoResult.data!["data"]["dest_tc"]}\n${stopNameResult.data!["data"]["name_tc"]}"),
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
        tileColor: Get.isDarkMode
            ? bound == "I"
                ? Color(0xaa67e491)
                : Color(0xaa67bae4)
            : bound == "I"
                ? Color(0xaa0b9b46)
                : Color(0xaa0b709b),
      ),
    );
  }
}
