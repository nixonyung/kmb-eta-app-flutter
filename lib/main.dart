import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/Screen2.dart';
import 'package:flutter_application_1/values/themes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fquery/fquery.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'screens/Screen1.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox("data");

  // Hive.box("data").clear();

  runApp(
    QueryClientProvider(
      queryClient: QueryClient(),
      child: ProviderScope(
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final themeMode = ThemeMode.dark.obs;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.dark,
      theme: lightThemeData,
      darkTheme: darkThemeData,
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("KMB ETA APP"),
            actions: [
              IconButton(
                icon: Obx(() => themeMode.value == ThemeMode.dark
                    ? Icon(Icons.dark_mode_outlined)
                    : Icon(Icons.light_mode_outlined)),
                onPressed: () {
                  Get.changeThemeMode(
                      Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
                  themeMode.value = themeMode.value == ThemeMode.dark
                      ? ThemeMode.light
                      : ThemeMode.dark;
                },
                padding: EdgeInsets.only(right: 10),
              ),
            ],
          ),
          body: TabBarView(
            children: [
              Screen1(),
              Screen2(),
            ],
          ),
          bottomNavigationBar: Builder(
            builder: (context) => ConvexAppBar(
              style: TabStyle.reactCircle,
              backgroundColor: Theme.of(context).primaryColor,
              items: const [
                TabItem(icon: Icons.directions_bus, title: 'Routes'),
                TabItem(icon: Icons.favorite, title: 'Favorites'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
