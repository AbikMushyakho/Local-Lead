import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';
import 'package:local_lead/core/providers/user_provider.dart';
import 'package:local_lead/core/router/app_router.dart';
import 'package:local_lead/core/theme/app_theme.dart';

void main() {
  usePathUrlStrategy();
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'LocalLead',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}