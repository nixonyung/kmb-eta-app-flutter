import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

@immutable
class BusRoute {
  const BusRoute({required this.route, required this.dest_tc});

  final String route;
  final String dest_tc;
}

class RoutesNotifier extends StateNotifier<List<BusRoute>> {
  RoutesNotifier() : super([]);

  void loadRoutes() async {
    var res = await http
        .get(Uri.parse('https://data.etabus.gov.hk/v1/transport/kmb/route'));

    state = List<BusRoute>.from(
      jsonDecode(res.body)["data"].map(
        (r) => BusRoute(route: r["route"], dest_tc: r["dest_tc"]),
      ),
    );
  }
}

final routesProvider =
    StateNotifierProvider<RoutesNotifier, List<BusRoute>>((ref) {
  return RoutesNotifier();
});
