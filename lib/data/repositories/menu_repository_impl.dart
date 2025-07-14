import '../../domain/entities/menu_item_entity.dart';
import '../../domain/repositories/menu_repository.dart';
import '../datasources/menu_local_data_source.dart';

class MenuRepositoryImpl implements MenuRepository {
  final MenuLocalDataSource localDataSource;

  MenuRepositoryImpl(this.localDataSource);

  @override
  List<MenuItemEntity> getMenuItems(String category) {
    try {
      final menuItems = localDataSource.getMenuItems(category);
      return menuItems;
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}