import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/RouteEtaList.dart';
import 'package:flutter_application_1/components/StyledTextField.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:get/get.dart';

class Screen1 extends HookWidget {
  Screen1({Key? key}) : super(key: key);

  final enteredValue = "".obs;

  @override
  Widget build(BuildContext context) {
    final routesResult = useQuery(
        ['route'],
        () async => (await Dio()
                .get('https://data.etabus.gov.hk/v1/transport/kmb/route'))
            .data["data"],
        refetchOnMount: RefetchOnMount.never);

    if (routesResult.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (routesResult.isError) {
      return Center(child: Text(routesResult.error!.toString()));
    }

    return Column(
      children: [
        StyledTextField(enteredValue: enteredValue),
        Expanded(
          child: Obx(
            () {
              final filteredRoutes = (routesResult.data! as List)
                  .where(
                    (element) => element["route"].startsWith(
                      enteredValue.value.toUpperCase(),
                    ),
                  )
                  .toList();

              return ListView.separated(
                itemCount: filteredRoutes.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 8,
                  thickness: 2,
                ),
                itemBuilder: (context, index) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.fromLTRB(20, 0, 30, 0),
                  leading: Text(
                    filteredRoutes[index]["route"],
                    style: TextStyle(fontSize: 20),
                  ),
                  title: Text(
                    "${filteredRoutes[index]["dest_tc"]}${filteredRoutes[index]["service_type"] == "1" ? "" : " (特別班)"}",
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: RouteEtaList(
                          route: filteredRoutes[index]["route"],
                          bound: filteredRoutes[index]["bound"],
                          serviceType: filteredRoutes[index]["service_type"],
                        ),
                      ),
                    );
                  },
                  tileColor: Get.isDarkMode
                      ? filteredRoutes[index]["bound"] == "I"
                          ? Color(0xaa67e491)
                          : Color(0xaa67bae4)
                      : filteredRoutes[index]["bound"] == "I"
                          ? Color(0xaa0b9b46)
                          : Color(0xaa0b709b),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
