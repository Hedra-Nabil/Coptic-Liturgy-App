import '../entities/menu_item_entity.dart';
import '../repositories/menu_repository.dart';

class GetMenuItemsUseCase {
  final MenuRepository repository;

  GetMenuItemsUseCase(this.repository);

  List<MenuItemEntity> execute(String category) {
    return repository.getMenuItems(category);
  }
}