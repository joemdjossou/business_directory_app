import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'data/repositories/business_repository.dart';
import 'data/services/api_service.dart';
import 'data/services/local_storage_service.dart';
import 'providers/business_provider.dart';
import 'screens/business_list_screen.dart';
import 'utils/color_scheme.dart';
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
          colorScheme: AppColorScheme.lightColorScheme,
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            centerTitle: true,
            elevation: 0,
            backgroundColor: AppColorScheme.primaryGreen,
            foregroundColor: AppColorScheme.textOnPrimary,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: AppColorScheme.primaryGreenDark,
              statusBarIconBrightness: Brightness.light,
            ),
          ),
          cardTheme: CardTheme(
            elevation: AppConstants.cardElevation,
            color: AppColorScheme.cardBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                AppConstants.cardBorderRadius,
              ),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColorScheme.primaryGreen,
              foregroundColor: AppColorScheme.textOnPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppConstants.cardBorderRadius,
                ),
              ),
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: AppColorScheme.primaryGreen,
            foregroundColor: AppColorScheme.textOnPrimary,
          ),
        ),
        darkTheme: ThemeData(
          colorScheme: AppColorScheme.darkColorScheme,
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            centerTitle: true,
            elevation: 0,
            backgroundColor: AppColorScheme.surfaceDark,
            foregroundColor: AppColorScheme.textOnPrimary,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: AppColorScheme.surfaceDark,
              statusBarIconBrightness: Brightness.light,
            ),
          ),
          cardTheme: CardTheme(
            elevation: AppConstants.cardElevation,
            color: AppColorScheme.cardBackgroundDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                AppConstants.cardBorderRadius,
              ),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColorScheme.primaryGreenLight,
              foregroundColor: AppColorScheme.textPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppConstants.cardBorderRadius,
                ),
              ),
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: AppColorScheme.primaryGreenLight,
            foregroundColor: AppColorScheme.textPrimary,
          ),
        ),
        themeMode: ThemeMode.system,
        home: const BusinessListScreen(),
      ),
    );
  }
}
