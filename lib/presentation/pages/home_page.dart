import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/app_router.dart';
import '../../core/utils/app_state_manager.dart';
import '../../core/utils/constants.dart';
import '../../domain/entities/menu_item_entity.dart';
import '../../domain/usecases/get_menu_items_usecase.dart';
import '../../data/repositories/menu_repository_impl.dart';
import '../../data/datasources/menu_local_data_source.dart';
import '../widgets/content_tile_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final menuDataSource = MenuLocalDataSourceImpl();
    final menuRepository = MenuRepositoryImpl(menuDataSource);
    final getMenuItemsUseCase = GetMenuItemsUseCase(menuRepository);
    final appState = Provider.of<AppStateManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('المكتبة الطقسية'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/icon.png'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'المكتبة الطقسية',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('الرئيسية'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('البحث'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRouter.search);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('الإعدادات'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRouter.settings);
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                appState.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              ),
              title: const Text('تبديل الوضع'),
              onTap: () {
                appState.toggleDarkMode();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250, // 👈 أقصى عرض للبلاطة
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.75, // 👈 عدد الأعمدة
        ),
          itemCount: getMenuItemsUseCase.execute(AppConstants.mainCategory).length,
          itemBuilder: (context, index) {
            final menuItem = getMenuItemsUseCase.execute(AppConstants.mainCategory)[index];
            return ContentTileWidget(
              menuItem: menuItem,
              onTap: () => _navigateToContent(context, menuItem),
            );
          },
        ),
      ),
    );
  }

  void _navigateToContent(BuildContext context, MenuItemEntity menuItem) {
    if (menuItem.title == AppConstants.liturgiesTitle) {
      Navigator.pushNamed(context, AppRouter.liturgies);
    } else {
      Navigator.pushNamed(
        context,
        AppRouter.content,
        arguments: {
          'title': menuItem.title,
          'jsonFile': menuItem.jsonFile,
        },
      );
    }
  }
}

// Temporary provider for dependency injection
class MenuRepositoryProvider extends InheritedWidget {
  final dynamic repository;

  const MenuRepositoryProvider({
    Key? key,
    required this.repository,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(MenuRepositoryProvider oldWidget) {
    return repository != oldWidget.repository;
  }
}