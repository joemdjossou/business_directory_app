import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repositories/business_repository.dart';
import 'data/services/api_service.dart';
import 'data/services/local_storage_service.dart';
import 'providers/business_provider.dart';
import 'screens/business_list_screen.dart';
import 'utils/constants.dart';

void main() {
  runApp(const BusinessDirectoryApp());
}

class BusinessDirectoryApp extends StatelessWidget {
  const BusinessDirectoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Services
        Provider<ApiService>(create: (_) => ApiService()),
        Provider<LocalStorageService>(create: (_) => LocalStorageService()),

        // Repository
        ProxyProvider2<ApiService, LocalStorageService, BusinessRepository>(
          create:
              (context) => BusinessRepository(
                context.read<ApiService>(),
                context.read<LocalStorageService>(),
              ),
          update:
              (context, apiService, localStorageService, previous) =>
                  previous ??
                  BusinessRepository(apiService, localStorageService),
        ),

        // Provider
        ChangeNotifierProxyProvider<BusinessRepository, BusinessProvider>(
          create:
              (context) => BusinessProvider(context.read<BusinessRepository>()),
          update:
              (context, repository, previous) =>
                  previous ?? BusinessProvider(repository),
        ),
      ],
      child: MaterialApp(
        title: 'Business Directory',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
          cardTheme: CardTheme(
            elevation: AppConstants.cardElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                AppConstants.cardBorderRadius,
              ),
            ),
          ),
        ),
        home: const BusinessListScreen(),
      ),
    );
  }
}
