import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'providers/auth_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/booking_provider.dart';
import 'providers/resource_provider.dart';
import 'routes/app_router.dart';

void main() {
  runApp(const KrishiRentApp());
}

class KrishiRentApp extends StatelessWidget {
  const KrishiRentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => ResourceProvider()),
      ],
      child: MaterialApp.router(
        title: 'KrishiRent',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        routerConfig: appRouter,
      ),
    );
  }
}
