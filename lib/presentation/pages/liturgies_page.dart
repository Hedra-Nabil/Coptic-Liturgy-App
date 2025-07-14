import 'package:flutter/material.dart';
import '../../core/utils/app_router.dart';
import '../../core/utils/constants.dart';
import '../../domain/entities/menu_item_entity.dart';
import '../../domain/usecases/get_menu_items_usecase.dart';
import '../../data/repositories/menu_repository_impl.dart';
import '../../data/datasources/menu_local_data_source.dart';
import '../widgets/content_tile_widget.dart';

class LiturgiesPage extends StatelessWidget {
  const LiturgiesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final menuDataSource = MenuLocalDataSourceImpl();
    final menuRepository = MenuRepositoryImpl(menuDataSource);
    final getMenuItemsUseCase = GetMenuItemsUseCase(menuRepository);
    final items = getMenuItemsUseCase.execute(AppConstants.liturgiesCategory);

    return Scaffold(
      appBar: AppBar(
        title: const Text('القداسات'),
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
          itemCount: items.length,
          itemBuilder: (context, index) {
            final menuItem = items[index];
            return ContentTileWidget(
              menuItem: menuItem,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRouter.content,
                  arguments: {
                    'title': menuItem.title,
                    'jsonFile': menuItem.jsonFile,
                  },
                );
              },
            );
          },
        ),
      ),
    );
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