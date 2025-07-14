import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_router.dart';
import 'core/utils/app_state_manager.dart';
import 'core/utils/dependency_injection.dart';

void main() {
  // Initialize dependency injection
  final di = DependencyInjection();
  di.init();

  runApp(const CopticLiturgyApp());
}

class CopticLiturgyApp extends StatelessWidget {
  const CopticLiturgyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final di = DependencyInjection();

    return ChangeNotifierProvider(
      create: (context) => AppStateManager(),
      child: Consumer<AppStateManager>(
        builder: (context, appState, _) {
          return di.wrapWithRepositoryProviders(
            MaterialApp(
              title: 'المكتبة الطقسية',
              theme:
                  appState.isDarkMode
                      ? AppTheme.darkTheme
                      : AppTheme.lightTheme,
              initialRoute: AppRouter.home,
              onGenerateRoute: AppRouter.generateRoute,
              debugShowCheckedModeBanner: false,
            ),
          );
        },
      ),
    );
  }
} 
