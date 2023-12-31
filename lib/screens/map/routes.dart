// This file defines the routes for the map screens in the Traffic Report System app.
import 'package:flutter/material.dart';
import 'home_map.dart';

// This is a map of routes for the map screens. Each key is a string representing a route, and each value is a function that takes a BuildContext and returns a Widget representing
// the screen for that route.
Map<String, WidgetBuilder> mapRoutes = {
  '/home': (context) => const HomeMapScreen(),
  // ... 其他地圖相關路由
};