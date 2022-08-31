import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/RouteEtaItem.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';

class RouteEtaList extends HookWidget {
  final String route;
  final String bound;
  final String serviceType;

  const RouteEtaList({
    Key? key,
    required this.route,
    required this.bound,
    required this.serviceType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stopIdListResult = useQuery(
      ['route-stop', route, bound, serviceType],
      () async => (await Dio().get(
              "https://data.etabus.gov.hk/v1/transport/kmb/route-stop/$route/${bound == 'I' ? "inbound" : "outbound"}/$serviceType"))
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

    if (stopIdListResult.isLoading || etaListResult.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (stopIdListResult.isError) {
      return Center(child: Text(stopIdListResult.error!.toString()));
    }
    if (etaListResult.isError) {
      return Center(child: Text(stopIdListResult.error!.toString()));
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
                      (element as Map)["eta"] != null,
                )
                .map(
                  (e) => (e as Map)["eta"] as String,
                )
                .toList(),
          )),
        )
        .values
        .toList();

    return ListView.separated(
      itemCount: stopIdListResult.data["data"]!.length,
      separatorBuilder: (context, index) => Divider(height: 20),
      itemBuilder: (context, index) => RouteEtaItem(
          index: index,
          route: route,
          bound: bound,
          serviceType: serviceType,
          stopId: stopIdListResult.data!["data"][index]["stop"],
          etaList: etaLists[index]),
    );
  }
}
